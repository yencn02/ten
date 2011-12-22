$(document).ready(function() {
    ClientRequestChange.bindCreateChangeBtn();
    ClientRequestChange.bindDiscardChangeBtn();
    AttachedFile.bindAttachBtn();
    ClientRequestChange.bindSaveChangeBtn();

    Message.toogle_header();
    Message.reply();
  
    $("#client-discussion .new a").click(function() {
        $(this).parent(".new").siblings(".form-wrapper").toggle();
        return false;
    });
  
    $("#client-discussion-cancel").click(function () {            
            $("#client-discussion-link").trigger('click');
        });
});

var ClientRequestChange = {
    bindSaveChangeBtn: function(){
        $("#changeSaveButton").unbind("click");
        $("#changeSaveButton").bind("click", function(){
            $("#description").val(tinyMCE.editors.description.getContent());
            $('form[data-remote=true]').trigger('onsubmit');
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
            ClientRequestChange.clear_client_change();
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
        var idSuffix = $('#fileIdSuffixes').val();
        $('#attachNew' + idSuffix).bind('click', function() {
            var newFile = $('#newFile' + idSuffix);
            if (newFile.is(":hidden")){
                newFile.show();
            }else{
                newFile.hide();
            }
            $("#newFileError" + idSuffix).hide();
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