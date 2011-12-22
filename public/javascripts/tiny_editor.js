tinyMCE.init({
    // General options
    mode : "textareas",
    theme : "advanced",
    editor_deselector : "mceNoEditor",
    plugins : "tabfocus, pagebreak,style,layer,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,template",
    // Theme options
    //theme_advanced_buttons1 : "restoredraft,|,bold,italic,strikethrough,|,bullist,numlist,|,outdent,indent,blockquote,|,link,unlink,image,media,|,pastetext,cleanup,code,|,fullscreen,preview",
    theme_advanced_buttons1 : "restoredraft,|,bold,italic,underline,strikethrough,|,bullist,numlist,|,outdent,indent, undo,redo",
    theme_advanced_buttons2 : "",
    theme_advanced_buttons3 : "",
    theme_advanced_buttons4 : "",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "",
    theme_advanced_resizing : true,
    tabfocus_elements : ':prev,:next',
    force_br_newlines : true,
    force_p_newlines : false,
    width : "60%",
    forced_root_block : '',
    auto_reset_designmode : true,


    // Drop lists for link/image/media/template dialogs
    template_external_list_url : "lists/template_list.js",
    external_link_list_url : "lists/link_list.js",
    external_image_list_url : "lists/image_list.js",
    media_external_list_url : "lists/media_list.js",

    // Style formats
    style_formats : [
    {
        title : 'Bold text',
        inline : 'b'
    },

    {
        title : 'Red text',
        inline : 'span',
        styles : {
            color : '#ff0000'
        }
    },
    {
        title : 'Red header',
        block : 'h1',
        styles : {
            color : '#ff0000'
        }
    },
    {
        title : 'Example 1',
        inline : 'span',
        classes : 'example1'
    },
    {
        title : 'Example 2',
        inline : 'span',
        classes : 'example2'
    },
    {
        title : 'Table styles'
    },
    {
        title : 'Table row 1',
        selector : 'tr',
        classes : 'tablerow1'
    }
    ],

    // Replace values for the template plugin
    template_replace_values : {
        username : "Some User",
        staffid : "991234"
    },
    init_instance_callback : "setTabIndex"
});

function setTabIndex()
{
    $(".mceToolbar *").attr("tabIndex", "-1");
}