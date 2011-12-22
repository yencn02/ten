$(document).ready(function() {    
    $("#checkAll").click(function(){ 
        var messages = $(".messageItem input.messageCheckedBox");
        ($(this).is(':checked')) ? messages.attr('checked', true) : messages.attr('checked', false);
    });
})