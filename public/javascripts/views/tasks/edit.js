$(document).ready(function() {
  $("#showHideChanges").bind("click", function(){
    ClientRequestChange.toggleChanges(this);
    return false;
  });

  $("#showHideFiles__client_request").bind("click", function(){
    AttachedFile.toggleFiles("__client_request");
    return false;
  });

  $("#showHideFiles__task").bind("click", function(){
    AttachedFile.toggleFiles("__task");
    return false;
  });

  $("#showHideMessages__client").bind("click", function(){
    Message.toggleMessages("__client");
    return false;
  });

  $("#showHideMessages__developer").bind("click", function(){
    Message.toggleMessages("__developer");
    return false;
  });

  $("#showHideNotes").bind("click", function(){
    TechnicalNote.toggleNotes(this);
    return false;
  });

  $("#createNote").bind("click", function(){
    TechnicalNote.toggleNewNoteForm();
    return false;
  });
});