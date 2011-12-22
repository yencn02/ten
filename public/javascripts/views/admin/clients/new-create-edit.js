$(document).ready(function() {
  $("#set-activate").bind("click", function(){
    $("div.status").show();
    return false;
  });
});
var NewClient = {
  pupulateGroup: function(){
    var company = parseInt($("#client_company").val());
    if (company >= 0){
      $("#client_group").html(groups[company]);
    }else{
      $("#client_group").html(groups[0]);
    }
  }
}