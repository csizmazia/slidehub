var express = require("express");
var path = require('path');
var util = require("util");
var mysql = require("mysql");
var mu = require('mu2');
var io = require('socket.io');
var Cookies = require('cookies');
var app = express();
var server = require("http").createServer(app);
var io = io.listen(server);

// config
app.set("title","SlideHub");
app.set("env","dev"); // dev|prod

if (app.get("env") == "dev") {
  app.set("db host", "localhost");
  app.set("db user", "slidehub");
  app.set("db pass", "slidehub");
  app.set("db db", "slidehub");
}
if (app.get("env") == "prod") {
  
}

var db = mysql.createConnection({
  host     : app.get("db host"),
  user     : app.get("db user"),
  password : app.get("db pass"),
  database : app.get("db db")
});

app.configure(function() {
  //app.all("*", requireAuthentication);
  //app.all("*", loadUser);
  app.use(express.static(path.join(__dirname, 'public')));
  app.use(express.static(__dirname + "/public/presentations"));
  app.use(express.favicon(__dirname + "/public/img/favicon.ico"));
  app.use(express.logger());
});

mu.root = __dirname + '/templates';


// functions
function dbClose() {
  db.end();
}

function sendResponseJSON(res, ret) {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.write(JSON.stringify(ret));
  res.end();
}

function login(res, cookie, username) {
  if(username) {
    db.query("INSERT INTO user(username,email) VALUES(?,?)",[username,username+"@mailinator.com"], function(error, results) {
      var ret = {};
      if (error && error.code != "ER_DUP_ENTRY") {
        ret.success = false;
        ret.msg = error.code;
        sendResponseJSON(res, ret);
      }
      else {
        db.query("SELECT iduser,username,email FROM user WHERE username = ?",[username], function(error, results) {
          if (error) {
            ret.success = false;
            ret.msg = error.code;
          }
          else {
            ret.success = true;
            ret.data = results[0];
            cookie.set("slidehub-logged-in",username);
          }
          sendResponseJSON(res, ret);
          
        });
      }
    });
  }
  else {
    sendResponseJSON(res, {"success":false,"msg":"Please provide a username"});
  }
}

function searchPresentations(res, term) {
  if(term) {
    db.query("SELECT * FROM presentation WHERE title like ? OR filename like ?",["%"+term+"%","%"+term+"%"], function(error, results) {
      var ret = {};
      if (error) {
        ret.success = false;
        ret.msg = error.code;
      }
      else {
        ret.success = true;
        ret.data = results;
      }
      sendResponseJSON(res, ret);
    });
  }
  else {
    sendResponseJSON(res, {"success":true,"data":[]});
  }
}

// logic
app.get("/", function(req, res) { 
  db.query("SELECT presentation.*,COUNT(note.idnote) AS note_count FROM presentation " +
           "JOIN slide ON presentation.idpresentation = slide.idpresentation " +
           "LEFT OUTER JOIN note ON slide.idslide = note.idslide " +
           "GROUP BY presentation.idpresentation " +
           "ORDER BY timestamp DESC",[], function(error, results) {
    if (error) {
      console.log(error);
      throw error;
    }
    
    var view = {
      title: app.get("title"),
      presentations: results
    };
    
    if (app.get("env") == "dev") {
      mu.clearCache();
    }
    var stream = mu.compileAndRender('presentations.html', view);
    util.pump(stream, res);
  });
});

app.get("/top", function(req, res) {
  db.query("SELECT presentation.*,COUNT(note.idnote) AS note_count FROM presentation " +
           "JOIN slide ON presentation.idpresentation = slide.idpresentation " +
           "JOIN note ON slide.idslide = note.idslide " +
           "GROUP BY presentation.idpresentation " +
           "ORDER BY note_count DESC",[], function(error, results) {
    if (error) {
      console.log(error);
      throw error;
    }
    
    var view = {
      title: app.get("title"),
      presentations: results
    };
    
    if (app.get("env") == "dev") {
      mu.clearCache();
    }
    var stream = mu.compileAndRender('presentations.html', view);
    util.pump(stream, res);
  });
});

app.get("/ajax", function(req, res) {
  var ret;
  if(req.query && req.query.action) {
    switch(req.query.action) {
      case "login":
        var cookie = new Cookies(req, res);
        login(res, cookie, req.query.username);
        break;
      case "search":
        searchPresentations(res, req.query.term);
        break;
      default:
        sendResponseJSON(res, {"success":false,"msg":"what do you want?"});
        break;
    }
  }
  else {
    sendResponseJSON(res, {"success":false,"msg":"what do you want?"});
  }
});

app.get("/presentation/*", function(req, res) {
  var presentationId = req.url.split("/").pop();
  
  db.query("SELECT * FROM presentation WHERE filename = ?",[presentationId], function(error, results) {
    if (error) {
      console.log(error);
      throw error;
    }
    
    var view = {
      title: app.get("title"),
      is_available: results.length == 1,
      presentation: results[0]
    };
    
    if (app.get("env") == "dev") {
      mu.clearCache();
    }
    var stream = mu.compileAndRender('presentation.html', view);
    util.pump(stream, res);
  });
});

io.sockets.on('connection', function (socket) {
  socket.on('hello', function (data_in) {
    socket.join("presentation-"+data_in.idpresentation);
    socket.set("idpresentation", data_in.idpresentation, function () { socket.emit("hi"); })
  });
  
  socket.on('note', function (data_in) {
    socket.get("idpresentation", function (error, idpresentation) {
      db.query("INSERT INTO note(idpresentation,iduser,content,slide_no,slide_x,slide_y,type) VALUES(?,?,?,?,?,?,'std')",[idpresentation,data_in.user.iduser,data_in.text,data_in.slide.page,data_in.slide.x,data_in.slide.y], function(error, results) {
        if (error) {
          console.log(error);
          socket.emit("error",{"msg":"Could not store note","code":error.code,"original":data_in});
        }
      });
      var now = new Date();
      var data_out = {"user":data_in.user,"slide":data_in.slide,"note":{"text":data_in.text,"timestamp":now.getTime()}};
      socket.broadcast.to("presentation-"+idpresentation).emit("note", data_out);
    });
  });
});

server.listen(8000);
console.log("Socket Listening on port 8000");
