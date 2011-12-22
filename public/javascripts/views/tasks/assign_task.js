$(document).ready(function() {
//  $("#activeWorkerId").val($("input:radio:checked").val());
  $('input[name="radio-worker"]').click(function()
    { 
      var id = $(this).val();
      jQuery.ajax({data:{},
        dataType:'script',
        type:'post',
        success: switchActiveWorker(id),
        url:'/tasks/show_task_list?worker_id='+ id });
    })
});

function switchActiveWorker(newActiveWorkerId) {  
  var activeWorkerId = $("#activeWorkerId").val();
  $("input:radio:checked").attr("checked", false)
  $("#workerText" + activeWorkerId).hide();
  $("#workerLink" + activeWorkerId).show();
  $("#workerText" + newActiveWorkerId).show();
  $("#workerLink" + newActiveWorkerId).hide();
  $("#activeWorkerId").val(newActiveWorkerId);
  $("#radio_" + newActiveWorkerId).attr("checked", true);
  $("input:radio:checked").disable();
  $("#worker_id").val(newActiveWorkerId);  
}

