$(document).ready(function() {
  $("#set-activate").bind("click", function(){
    $("div.status").show();
    return false;
  });
});
var NewWorker = {
  pupulateGroup: function(){
    var company = parseInt($("#worker_company").val());
    if (company >= 0){
      $("#worker_group").html(groups[company]);
    }else{
      $("#worker_group").html(groups[0]);
    }
  }
}