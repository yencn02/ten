$(document).ready(function() {
  $('a[rel*=facebox]').facebox();
  $("#facebox .footer").remove();
  $(document).bind('reveal.facebox', function() {
    $("#facebox input[value=Cancel]").bind("click", function(){
      $.facebox.close();
    });
    $("#facebox #project_name").focus();
  });
  
});
var ProjectForm = {
  toggleSpinner: function(){
    $("#facebox #spinner").toggle();
  }
}