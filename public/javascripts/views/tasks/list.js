$(document).ready(function() {
  //keypress input for billhour
  $('.billed_hour').keypress(function(event) {
    var key_code = event.which;    
    if (key_code == 8 || key_code == 13 )  //this is to allow backspace and Enter
      return true;
    if (key_code < 46 || key_code > 57 || key_code == 47)    
      event.preventDefault? event.preventDefault() : event.returnValue = false;   
    return true;
  });

  $(".completed").click(function(){
    var task_id = $(this).attr("id").replace("complete", "");
    TimesheetEntryForm.checkCompleted(task_id);
  });

  $(".cancel").click(function(){    
    var desc = $(this).parent('div').prev().children('textarea').val();
    var billHour = $(this).parent('div').children('input:text').val();
    if (((desc != "" || billHour != "")) && confirm('Do you want to save timesheet')){      
      $(this).prev().click();
    } 
    $(this).parent("div").parent("form").parent("div").hide();
    $(this).parent('div').prev().children('textarea').attr("value", "");
    $(this).parent('div').children('input:text').attr("value", "");
  });  
  TimesheetEntryForm.bindClock();
});


var TimesheetEntryForm = {
  checkCompleted: function(task_id){
    var hash_div = $("#commit_hash_div" + task_id);
    if($("#complete" + task_id).is(":checked") == true){
      hash_div.show();
    }else{
      hash_div.hide();
    }
  },
  bindClock: function(){
    $(".clock").bind("click", function() {
      var trs = $("tr div.timesheet-entry");  
      var text = "";    
      var timesheetEntry = $(this).parent("td").next("td").children(".timesheet-entry");
      var this_id = timesheetEntry.children("form").attr("id");
      for (i = 0; i < trs.length; i ++){
        if (!$("tr div.timesheet-entry").eq(i).is(':hidden')){       
          text = $("textarea").eq(i).val(); 
          if (text != "" &&  confirm('Do you want to save timesheet')){ 
            $("#Savebutton" + i).click();  
          }       
          $("textarea").eq(i).attr("value", "");           
        }
        if ( this_id != $("tr div.timesheet-entry").eq(i).children("form").attr("id")){
          $("tr div.timesheet-entry").eq(i).hide();    
        }
      }      
      timesheetEntry.toggle();
      timesheetEntry.children("form").children("div").children("textarea").focus();
      TimesheetEntryForm.checkCompleted($(this).attr("id").replace("clock",""));
      return false;
    })
  },
  onSubmit: function() {   
    $('#spinner').show();
  },
  onSuccess: function() {
    $("#changeSaveButton").enable();
    $('#spinner').hide();
  },
  onFocus: function(id) {
    $("#description" + id).focus();
  }
};


