var express = require("express");
var util = require("util");
var mysql = require("mysql");
var mu = require('mu2');
var io = require('socket.io');
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
  app.use(express.static(__dirname + "/public/img"));
  app.use(express.static(__dirname + "/public/css"));
  app.use(express.static(__dirname + "/public/js"));
  app.use(express.static(__dirname + "/public/presentations"));
  app.use(express.favicon(__dirname + "/public/img/favicon.ico"));
  app.use(express.logger());
});

mu.root = __dirname + '/templates';



// functions
function dbClose() {
  db.end();
}

function requireAuthentication() {

}

function loadUser() {
  
}

// logic
app.get("/", function(req, res){ 
  db.query("SELECT * FROM presentation",[], function(error, results) {
    if (error) {
      console.log(error);
      throw error;
    }
    
    console.log(results);
    
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

app.get("/testpres", function(req, res){
  res.send("testpresentation1");
});

app.get("/presentation/*", function(req, res){
  var presentationId = req.url.split("/").pop();
  
  db.query("SELECT * FROM presentation WHERE filename = ?",[presentationId], function(error, results) {
    if (error) {
      console.log(error);
      throw error;
    }
    
    console.log(results);
    
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
  socket.on('note', function (data) {
    console.log(data);
    // TODO: store note
    socket.broadcast.emit("note", data);
  });
});

//app.listen(8000);
//console.log("Listening on port 8000");

server.listen(8000);
console.log("Socket Listening on port 8000");