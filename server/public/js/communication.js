


var communication = {
  sessionId: null,
  socket: null,
  username: null,
  idpresentation: null,
  init: function(sessionId, idpresentation, username) {
    this.socket = io.connect();
    this.sessionId = sessionId;
    this.username = username;
    this.idpresentation = idpresentation;
    this.addBindings();
    this.sendHello();
  },

  sendHello: function() {
    this.socket.emit("hello",{ idpresentation: this.idpresentation });
  },


  addBindings: function() {
    $('#new-note').bind("keypress", this.addNoteEvent);
    this.socket.on('hi', this.socketReady); 
    this.socket.on('note', this.socketNote); 
    this.socket.on('comment', this.socketComment);
  },

  socketReady: function(data) {
    console.log("Socket is ready");
  },

  socketNote: function(data) {
    communication.addNote(data.user.username, data.user.email, data.note, moment(data.note.timestamp));
  },

  socketComment: function(data) {
    communication.addComment(data.idnote, data.comment.text, data.user.username, data.user.email);
  },

  addNoteEvent: function(event) {
    if(event.keyCode == 13){
      var content = $("#new-note").val();
      if(content.length > 0) {
        // TODO: The variable currentPage is a global one, this should be changed.
        communication.socket.emit("note", {"sid": communication.sessionId, "text": content, "slide":{"page":currentPage}});
        
        // Reset input field
        $("#new-note").val("");
        return false;
      }
    }
  },

  /**
   * This method adds a new note in the frontent.
   */
  addNote: function(username, email, note, date) {
    var gravatar = '"http://www.gravatar.com/avatar/'+$.md5(email)+'?s=32&d=identicon"';
    $("#notes-container").append('<div class="note"><a class="pull-left" ><img class="media-object" src='+gravatar+ 
      '></a><div class="media-body"><h5 class="media-heading">'+username+' (' + date.format("MMM Do YYYY, HH:mm:ss")+ ')'+'</h5>'+note.text+'' + 
      '<div class="comments-container" id="comments' + note.idnote +'"><a href="javascript:void(0)" onclick="communication.addCommentInputBox(this, ' +  note.idnote +');">add a comment</a></div></div></div></div>');
  },

  /**
   * This method add a new comment to the list in the frontent.
   */
  addComment: function(idnote, text, username, email) {
    var gravatar = '"http://www.gravatar.com/avatar/'+$.md5(email)+'?s=24&d=identicon"';
    $("#comments" + idnote).append('<div class="comment"><a class="pull-left" ><img class="media-object" src='+gravatar+'></a><h5 class="media-heading">'+username+'</h5>' +  text + '</div>');
  },

  /**
   * This method handles a onclick event for a new comment.
   */
  addCommentEvent: function(element, idnote) {
    this.socket.emit("comment", {"sid": this.sessionId, "text": $("#new-comment" +idnote).val(), "idnote":idnote});
    $(".commentInput").remove();
  },

  /**
   * This method handles a onclick event to show the input field for a new comment.
   */
  addCommentInputBox: function(element, idnote) {
    $("#comments" + idnote).append('<div class="commentInput" id="addComment'+ idnote +'"><input type="text" id="new-comment'+idnote+'"/><a href="javascript:void(0)" onclick="communication.addCommentEvent(this, ' +  idnote +');">add</a></div>');
  }


}









 // function commentNote(caller, noteId) {
 //          
 //        }

       
 //        function addComment(caller, noteId) {
 //           var socket = io.connect('http://localhost');
 //           var comment = $("#new-comment" +noteId).val();
 //           socket.emit("comment", {"sid": sid, "text":, "idnote":noteId});
 //           addCommentBox(noteId, comment);
 //          $(".commentInput").remove();
 //        }

 //        function addCommentBox(noteId, text, username) {
 //          $("#comments" + noteId).append('<div class="comment"><a class="pull-left" ><img class="media-object" src="http://placehold.it/24x24"></a>' + 
 //          text + '</div>');
 //        }

 //        function addNoteBox(noteDate, text, username) {
 //          $("#notes-container").append('<div class="note"><a class="pull-left" ><img class="media-object" src="http://placehold.it/32x32"></a><div class="media-body"><h5 class="media-heading">'+username+' (' + noteDate + ')'+'</h5>'+text+'</div>');
 //        }

// socket.on('note', function (data) {
// console.log(data);
// var noteDate = new Date(data.note.timestamp);
// addNoteBox(noteDate, data.note.text, data.user.username);
// });
// socket.on('comment', function (data) {
// console.log(data);
// addCommentBox(data.idnote, data.comment.text, data.user.username);
// });
// socket.on('vote', function (data) {
// console.log(data);
// // TODO: irgendwas sinnvolles mit dem vote tun
// });

// $('#next-button').click(nextSlide);
// $('#prev-button').click(prevSlide);

// $(window).resize(repaintPdf);

// $
// });
