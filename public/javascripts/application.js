$(document).ready(function() {
    $('.date-pick').datepicker({ dateFormat: 'dd-mm-yy' });
    $("input[type=text]").first().focus();
    BoxToggle.init();
    ExternalLinks.init(); 
});

/*
 * Set the "target" attribute to "_blank" for links which are marked as external.
 * http://articles.sitepoint.com/article/standards-compliant-world/3
 */
var ExternalLinks = {
    init: function() {
        $("a[rel=external]").each(function() {
            $(this).attr("target", "_blank");
        });
    }
}

/*
 * Toggles boxes.
 */
var BoxToggle = {
    init: function() {
        $("a.visible").click(function() {
            var nextDiv = $($(this).parent().get(0)).next();

            if (nextDiv.is(':visible')) {
                nextDiv.hide();
                $(this).css("background", "#333 url('/images/switch_plus.gif') 97% 50% no-repeat")
            }
            else {
                nextDiv.show();
                $(this).css("background", "#333 url('/images/switch_minus.gif') 97% 50% no-repeat")
            }

            return false;
        });
    }
}

var ClientRequestChange = {
    toggleChanges: function(element) {
        $("#changes").toggle();
        if ($(element).html() == "Hide") {
            $(element).html("Show");
        } else {
            $(element).html("Hide");
        }
        return false;
    }
}
var AttachedFile = {
    toggleFiles: function(idSuffix) {
        if(idSuffix == null || idSuffix.undefined)
        {
            alert('faild');
            idSuffix = "";
        }
        var filePanel = $("#files" + idSuffix);
        var showHideAnchor = $("#showHideFiles" + idSuffix);
        filePanel.toggle();
        if (showHideAnchor.html() == "Hide") {
            showHideAnchor.html("Show");
        } else {
            showHideAnchor.html("Hide");
        }
    }
}

var Message = {
    toggleMessages: function(idSuffix) {
        var messages = $("#messages" + idSuffix);
        var showHideLink = $("#showHideMessages" + idSuffix);
        messages.toggle();
        if (showHideLink.html() == "Hide") {
            showHideLink.html("Show");
        } else {
            showHideLink.html("Hide");
        }
    },
  
    toogle_header: function() {
        $(".message .header").click(function() {   
            $(this).siblings(".content").toggle();
            return false;
        });
    }
    ,
    reply: function() {
        $(".action .reply").click(function() {      
            var form = $(this).parents(".message-list");        
            var message = $(this).parents(".message");
            var field_message = form.find("textarea");
            form.children(".form-wrapper").show();
            var sender = message.find(".header").find(".sender").text();
            var msg = "<br/>"+ sender +" wrote:<br/>> " + message.find(".content").find(".body").html();
            tinyMCE.get(field_message.attr("id")).setContent(msg);
            return false;
        });  
    },
    toogle_new: function() {
        $(".new a").click(function() {            
            tinyMCE.get('message_body').focus(); 
            $(this).parent(".new").siblings(".form-wrapper").toggle();                        
            return false;
        });    
    }
    ,
    clear_discussion_client: function() {               
        if (tinyMCE.getInstanceById('client_message_body') !=null) {
            tinyMCE.getInstanceById('client_message_body').setContent('');
        }
        return false;    
    }
    ,    
    clear_discussion_dev: function() {    
        if (tinyMCE.getInstanceById('message_body') !=null) {
        tinyMCE.getInstanceById('message_body').setContent('');
        }
        return false;
    }     
    ,
    load: function() {
        Message.toogle_header();
        Message.reply();
        Message.toogle_new();             
    }
    ,
    success_dev: function() {
       Message.load();      
    }    
    ,
    success_client: function() {        
     Message.load();              
    }
    ,
    client_message_error: function() {                        
        $("#newClientMessageError").show();
    }    
    , 
    client_after_save: function() {                        
        $("#newClientMessageError").hide();
        Message.clear_discussion_client();
        $("#client-discussion-link").trigger('click');
    }    
    ,
    dev_message_error: function() {                
        $("#newDevMessageError").show();
    }    
    , 
    dev_after_save: function() {        
        Message.clear_discussion_dev();
        $("#newDevMessageError").hide();
        $("#dev-discussion-link").trigger('click');
    }    
}

var TechnicalNote = {
    toggleNotes: function(element){
        $("#notes").toggle();
        if ($(element).html() == "Hide") {
            $(element).html("Show");
        } else {
            $(element).html("Hide");
        }
    },
    toggleNewNoteForm: function(){
        $("#newNote").toggle();
    }
}

var TinyMce = {
    reset: function() {
        var tinymce_editor_id = tinymce.editors[0].id
        tinymce.get(tinymce_editor_id).setContent('');
    }
}

