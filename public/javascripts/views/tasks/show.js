$(document).ready(function() {    
    ClientRequestChange.bindCreateChangeBtn();
    ClientRequestChange.bindDiscardChangeBtn();
    AttachedFile.bindAttachBtn();
    ClientRequestChange.bindSaveChangeBtn();

    Message.load();
    $("#tech-note-cancel").click(function () {
        clear_description_note();
        $("#add-tech-note").trigger('click');
    });

    $("#file-tech-cancel").click(function () {
        $("#attachNew__task").trigger('click');        
    });


    $("#client_re_cancel").click(function () {
        client_re_change();
        $("#new-change").trigger('click');
    });   
  
    $("#client-discussion-cancel").click(function () {            
        $("#client-discussion-link").trigger('click');
    });
        
        $("#dev-discussion-cancel").click(function () {            
        $("#dev-discussion-link").trigger('click');
    });
    
    submit.show_task_sumary();
});

function clear_description_note() {
    tinyMCE.getInstanceById('Description').setContent('');
    return false;
}

function client_re_change() {
    $("#client_change").val("");
    return false;
}

var submit = {
    show_task_sumary: function(){
        $("#edit_task").click(function(){
            $("#taskEditPanel").toggle();
            $("table").toggle();
            $("input[type=text]").first().focus();
            return false;
        })
        $(".cancel").click(function () {
            $("#edit_task").trigger('click');
            return false;
        })
    }

}


var AddNote ={
    afterSave: function() {
        $("#errorExplanation").hide();
        clear_description_note();
        $("#add-tech-note").trigger('click');
    }
  
}

var ClientRequestChange = {
    bindSaveChangeBtn: function(){
        $("#changeSaveButton").unbind("click");
        $("#changeSaveButton").bind("click", function(){
            $("#description").val(tinyMCE.editors.description.getContent());
            $("#newChangeForm").trigger('onsubmit');
        })
    },
    bindCreateChangeBtn: function(){
        $('#createChange').unbind('click');
        $('#createChange').bind('click', function() {
            var newChange = $('#newChange');
            if (newChange.is(":hidden")){
                newChange.show();
                $('#description').focus();
            }
            else{
                newChange.hide();
            }
            $("#newChangeError").hide();
            return false;
        });
    },
    clear_client_change: function() {
        if (tinyMCE.getInstanceById('description') !=null) {
            tinyMCE.getInstanceById('description').setContent('');
        }
        return false;
    },
    bindDiscardChangeBtn: function(){
        $("#changeDiscardButton").unbind("click");
        $("#changeDiscardButton").bind("click", function(){
            $("#newChangeError").hide();
            $("#newChangeForm").reset();
            $("#newChange").hide();
            
        })
    },
    afterSave: function() {
        $('#newChangeForm').reset();
        $('#changeSaveButton').enable();
        $('#newChange').hide();
        ClientRequestChange.clear_client_change();
    },
    onSubmit: function() {
        $("#changeSaveButton").disable();
        $('#spinner').show();
    },
    onSuccess: function() {
        ClientRequestChange.bindCreateChangeBtn();
        $("#changeSaveButton").enable();
        $('#spinner').hide();
    }
}

var AttachedFile = {
    afterSave: function(idSuffix) {
        $("#noFileMessage" + idSuffix).hide();
        $("#newFileError" + idSuffix).hide();
        $("#newFileForm" + idSuffix).reset();
        $("#fileSaveButton" + idSuffix).enable();
        $("#fileDiscardButton" + idSuffix).enable();
        $('#newFile' + idSuffix).hide();
        AttachedFile.bindAttachBtn();
    },
    bindAttachBtn: function(){
        $('#attachNew__task').bind('click', function() {           
            var newFile = $('#newFile__task');
            if (newFile.is(":hidden")){
                newFile.show();
            }else{
                newFile.hide();
            }
            $("#newFileError__task").hide();
            return false;
        });
        $('#attachNew__client_request').bind('click', function() {
            var newFile = $('#newFile__client_request');
            if (newFile.is(":hidden")){
                newFile.show();
            }else{
                newFile.hide();
            }
            $("#newFileError__client_request").hide();
            return false;
        });
    },
    onSaveFailure: function(idSuffix) {
        $("#fileDiscardButton" + idSuffix).enable();
        saveButton = $("#fileSaveButton" + idSuffix);
        saveButton.enable();
        $("#attachNew" + idSuffix).focus();
    },
    onSave: function(idSuffix) {
        $("#fileSaveButton" + idSuffix).disable();
        $("#fileDiscardButton" + idSuffix).disable();
    },
    onSuccess: function() {
        AttachedFile.bindAttachBtn();
    },
    discard: function(idSuffix) {
        $("#newFileError" + idSuffix).hide();
        $("#newFileForm" + idSuffix).reset();
        $("#newFile" + idSuffix).hide();
    }
}
