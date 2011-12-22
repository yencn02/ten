
function getPageScroll()
{
  var yScroll;
  if (self.pageYOffset)
  {
    yScroll = self.pageYOffset;
  } 
  else if (document.documentElement && document.documentElement.scrollTop)
  {	 // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
  }
  else if (document.body) 
  {// all other Explorers
    yScroll = document.body.scrollTop;
  }

  arrayPageScroll = new Array('',yScroll) 
  return arrayPageScroll;
}

//
// getPageSize()
// Returns array with page width, height and window width, height
// Core code from - quirksmode.org
// Edit for Firefox by pHaez
//
function getPageSize(){
  var xScroll, yScroll;

  if (window.innerHeight && window.scrollMaxY)
  {	
	xScroll = document.body.scrollWidth;
    yScroll = window.innerHeight + window.scrollMaxY;
  }
  else if (document.body.scrollHeight > document.body.offsetHeight)
  { // all but Explorer Mac
    xScroll = document.body.scrollWidth;
    yScroll = document.body.scrollHeight;
  }
  else
  { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
	xScroll = document.body.offsetWidth;
	yScroll = document.body.offsetHeight;
  }

  var windowWidth, windowHeight;
  if (self.innerHeight) {	// all except Explorer
    windowWidth = self.innerWidth;
    windowHeight = self.innerHeight;
  } 
  else if (document.documentElement && document.documentElement.clientHeight)
  { // Explorer 6 Strict Mode
    windowWidth = document.documentElement.clientWidth;
    windowHeight = document.documentElement.clientHeight;
  } 
  else if (document.body)
  { // other Explorers
    windowWidth = document.body.clientWidth;
    windowHeight = document.body.clientHeight;
  }	

  // for small pages with total height less then height of the viewport
  if(yScroll < windowHeight)
  {
 	pageHeight = windowHeight;
  }
  else
  { 
    pageHeight = yScroll;
  }
  // for small pages with total width less then width of the viewport
  if(xScroll < windowWidth)
  {	
    pageWidth = windowWidth;
  }
  else
  {
	pageWidth = xScroll;
  }
  arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight) 
  return arrayPageSize;
}

function showFloatingDialog()
{
  var pageSize = getPageSize();
  var pageScroll = getPageScroll();

  var overlay = $("overlay");
  overlay.setStyle({"height": (pageSize[1] + "px")});
  overlay.setStyle({"display": "block"});
  var dialog = $("floating_dialog");
  dialog.setStyle({"top": ((pageScroll[1] + 200) + "px")});
  dialog.setStyle({"left": (((pageSize[0] - 400) / 2) + "px")});
  dialog.setStyle({"display": "block"});
}

function showFloatingDialogDiscussion()
{
  var pageSize = getPageSize();
  var pageScroll = getPageScroll();

  var overlay = $("overlay");
  overlay.setStyle({"height": (pageSize[1] + "px")});
  overlay.setStyle({"display": "block"});

  var dialog = $("floating_dialog");
  dialog.setStyle({"top": ((pageScroll[1] + 200) + "px")});
  dialog.setStyle({"left": (((pageSize[0] - 900) / 2) + "px")});
  dialog.setStyle({"display": "block"});
}

function hideFloatingDialog()
{
  $("overlay").setStyle({"display": "none"});
  $("floating_dialog").setStyle({"display": "none"});
}


//--------------------------------- Begin dialog -------------------------
var update_text = "";
var new_update_text = "";
var NEWLINE = "<br/>";	
var isUpdated = false;

function getSelectedText()
{
  var text="";
  /*if (window.getSelection) {
	text = window.getSelection();
  } else if (document.getSelection) {
	text = document.getSelection();
  } else if (document.selection) {
	text = document.selection.createRange().text;
  }
  return text;
  */
  if (document.selection && document.selection.createRange) {
    //text = document.selection.createRange();       
	text=document.selection.createRange();		       
  }
  else if (window.getSelection)
  {
    text = window.getSelection();                          
  } 
  return text;
}
	
function stripHTML(oldString)
{       
  var newString = "";
  var re= /<\S[^><]*>/g;

  newString = oldString.replace(re, "");

  return newString;
}

function trim(str)
{
  var	str = str.replace(/^\s\s*/, ""),
				ws = /\s/,
  i = str.length;
  while (ws.test(str.charAt(--i)));		
  return str.slice(0, i + 1);
}
    
function needNewLine(str){
  var newString = trim(str);
        
  if (newString.indexOf("<br") == 0 || stripHTML(newString) == "")
  {
    return false;
  }
  return true;
}

function populateFloatingDialog()
{
  var selection = getSelectedText();		
  var content = $("floating_dialog_content");
  content.update("");
  var range;
  var target;
  var fullText;
  var isWindowOS = false;
  if(selection.rangeCount == 1 && selection.anchorNode == selection.focusNode 
	&& !selection.isCollapsed) 
  {// FireFox
    selectionStr = selection.toString();
    range = selection.getRangeAt(0);
    target = range.commonAncestorContainer.parentNode;
    fullText = target.innerHTML;
  }else
  {
    selectionStr = selection.text;
    range = selection;
    //target = range.parentElement().Id;
    target = range.endContainer;
    fullText = selection.htmlText;
    isWindowOS = true;
  }

  /*if (selection.rangeCount == 1 && selection.anchorNode == selection.focusNode 
	&& !selection.isCollapsed && !selection.toString().match(/^\s{0,}$/)) { */ 
  if (!selectionStr.match(/^\s{0,}$/))
  {
		
	//var selectionStr = selection.toString();
   /* var range = selection.getRangeAt(0);
	var target = range.commonAncestorContainer.parentNode;
	var fullText = target.innerHTML;
	*/
	selectionStr = selectionStr.replace(/</g,"&lt;").replace(/>/g,"&gt;");

	if (new_update_text == "" && update_text.indexOf(selectionStr) >= 0)
	{
      content.update("Cannot reply to yourself.")
	    new Insertion.Bottom(content, "<p><input type=\"button\" name=\"dlg_cancel_btn\" value=\"Close\" onclick=\"hideFloatingDialog();\"/></p>");

	}
	else
    {
      isUpdated = false;
      new Insertion.Bottom(content, "<p><strong>Add a reply text for:</strong></p>");
      new Insertion.Bottom(content, "<p>\""+ selectionStr +"\"</p>");
	  
	  new Insertion.Bottom(content, "<p><textarea name=\"reply_text\" id=\"reply_text\" cols=\"40\" rows=\"5\"></textarea></p>");
      
	  new Insertion.Bottom(content, "<p><input type=\"button\" name=\"add_reply_text\" value=\"Add Reply Text\" id=\"add_reply_text\" /> <input type=\"button\" name=\"dlg_close_btn\" value=\"Finish\" id=\"dlg_close_btn\"/></p>");

	  $('add_reply_text').onclick = function () {
        // to get original start and end, stripTags() and then find index
        var start = fullText.indexOf(selectionStr);
        var end = start + selectionStr.length;

        var beforeStr = fullText.substring(0, start);
        var afterStr = fullText.substring(end, fullText.length);

        var value = $('reply_text').value.replace(/</g,"&lt;").replace(/>/g,"&gt;");

        var highlighted;
			
        if (new_update_text.indexOf(selectionStr) >= 0)
        {
		  highlighted = "<span style='background:#CCCCFF; padding: 3px 0px;'>" + value + "</span>";
		}
		else
		{
		  highlighted = NEWLINE + "<span style='background:#CCCCFF; padding: 3px 0px;'>" + value + "</span>" + (needNewLine(afterStr)  ? NEWLINE : "");
		}

		isUpdated = true;
		if(isWindowOS == false)
		{
		  target.update(beforeStr + selectionStr + highlighted + afterStr);

		  addEntityTag(target.id, value, start, end);
		}
		else
		{
		  //selection.htmlText = beforeStr + selectionStr + highlighted + afterStr;
		  //target = beforeStr + selectionStr + highlighted + afterStr;
		  //addEntityTag(target, value, start, end);
		  addEntityTag(range.startContainer, value, start, end);				
		}
	    hideFloatingDialog();
      } 

	  $("dlg_close_btn").onclick = function ()
	  { 	    
		var value = $('reply_text').value.replace(/</g,"&lt;").replace(/>/g,"&gt;");
		var isInlined = false;

		if (isUpdated && trim(value) != "")
		{

		  var msgContent = $("msg_body").value;
		  
		  var start = msgContent.indexOf(selectionStr);
		  var end = start + selectionStr.length;
		  var beforeStr = msgContent.substring(0, start);
		  var afterStr  = msgContent.substring(end, msgContent.length);

		  var update_point = NEWLINE +  "<user>" + value + "</user>" + (needNewLine(afterStr) ? NEWLINE : "")  ;
			  
		  if (new_update_text.indexOf(selectionStr) >= 0) {
		    isInlined = true;
		    update_point = value;
		  }
		  else
		  {
		    update_point = NEWLINE +  "<user>" + value + "</user>" + (needNewLine(afterStr) ? NEWLINE : "")  ;
		  }

		  $("msg_body").value = beforeStr + selectionStr + update_point + afterStr;
			  
		  // Process the new modified text
		  if (isInlined)
		  {
		    start = new_update_text.indexOf(selectionStr);
		    end = start + selectionStr.length;
		    beforeStr = new_update_text.substring(0, start);
		    afterStr  = new_update_text.substring(end, new_update_text.length);
				  
		    new_update_text = beforeStr + selectionStr + update_point + afterStr;

		  }
		  else
		  {
		    new_update_text = new_update_text + value;
		  }
			  
		  $("added").value = new_update_text;

			  $("done_btn").disabled = false;
		  }

		  hideFloatingDialog();
		} 
	  } 
    } 
    else
    {
	  content.update("Please select text containing characters from one valid element.")
	  new Insertion.Bottom(content, "<p><input type=\"button\" name=\"dlg_cancel_btn\" value=\"Close\" onclick=\"hideFloatingDialog();\"/></p>");
    }
	
  }

function populateFloatingDialogDicussion()
{

  var selection = getSelectedText();		
  var content = $("floating_dialog_content");
  content.update("");
		
  if (selection.rangeCount == 1 && selection.anchorNode == selection.focusNode && !selection.isCollapsed && !selection.toString().match(/^\s{0,}$/))
  {
    var selectionStr = selection.toString();
    var range = selection.getRangeAt(0);
	var target = range.commonAncestorContainer.parentNode;
    var fullText = target.innerHTML;
            
	selectionStr = selectionStr.replace(/</g,"&lt;").replace(/>/g,"&gt;");

    if (new_update_text == "" && update_text.indexOf(selectionStr) >= 0)
    {
	  content.update("Cannot reply to yourself.")
	    new Insertion.Bottom(content, "<p><input type=\"button\" name=\"dlg_cancel_btn\" value=\"Close\" onclick=\"hideFloatingDialog();\"/></p>");

    }
	else
	{

      isUpdated = false;

	  new Insertion.Bottom(content, "<p><strong>Add a reply text for:</strong></p>");
	  new Insertion.Bottom(content, "<p>\""+ selectionStr +"\"</p>");

	  new Insertion.Bottom(content, "<p><textarea name=\"reply_text\" id=\"reply_text\" cols=\"40\" rows=\"5\"></textarea></p>");

	  new Insertion.Bottom(content, "<p><input type=\"button\" name=\"add_reply_text\" value=\"Add Reply Text\" id=\"add_reply_text\" /> <input type=\"button\" name=\"dlg_close_btn\" value=\"Finish\" id=\"dlg_close_btn\"/></p>");

	  $('add_reply_text').onclick = function () {

	    // to get original start and end, stripTags() and then find index
		var start = fullText.indexOf(selectionStr);
		var end = start + selectionStr.length;

		var beforeStr = fullText.substring(0, start);
		var afterStr = fullText.substring(end, fullText.length);

		var value = $('reply_text').value.replace(/</g,"&lt;").replace(/>/g,"&gt;");

		var highlighted;
					
		if (new_update_text.indexOf(selectionStr) >= 0)
		{
		  // highlighted = "<span style='background:#CCCCFF; padding: 3px 0px;'>" + value + "</span>";
		  highlighted = NEWLINE + "<span style='background:#CCCCFF; padding: 3px 0px;'>" + value + "</span>";
		}
		else
		{
		  highlighted = NEWLINE + "<span style='background:#CCCCFF; padding: 3px 0px;'>" + value + "</span>" + (needNewLine(afterStr)  ? NEWLINE : "");
		}

		isUpdated = true;

		target.update(beforeStr + selectionStr + highlighted + afterStr);

		addEntityTag(target.id, value, start, end);

	    hideFloatingDialog();
	  } 

	  $("dlg_close_btn").onclick = function () {

	    var value = $('reply_text').value.replace(/</g,"&lt;").replace(/>/g,"&gt;");
        var isInlined = false;

        if (isUpdated && trim(value) != "")
        {

 	      var msgContent = $("msg_body").value;
                   
		  var start = msgContent.indexOf(selectionStr);
		  var end = start + selectionStr.length;
		  var beforeStr = msgContent.substring(0, start);
		  var afterStr  = msgContent.substring(end, msgContent.length);

		  var update_point = NEWLINE +  "<user>" + value + "</user>" + (needNewLine(afterStr) ? NEWLINE : "")  ;
                      
		  if (new_update_text.indexOf(selectionStr) >= 0) {
		    isInlined = true;
 		    update_point = value;
		  }
		  else
		  {
		    update_point = NEWLINE +  "<user>" + value + "</user>" + (needNewLine(afterStr) ? NEWLINE : "")  ;
		  }

		  $("msg_body").value = beforeStr + selectionStr + update_point + afterStr;
                      
					  // Process the new modified text
		  if (isInlined)
		  {
		    start = new_update_text.indexOf(selectionStr);
            end = start + selectionStr.length;
            beforeStr = new_update_text.substring(0, start);
            afterStr  = new_update_text.substring(end, new_update_text.length);
                          
			new_update_text = beforeStr + selectionStr + update_point + afterStr;

		  }
		  else
		  {
		    new_update_text = new_update_text + value;
		  }
					  
		  $("added").value = new_update_text;
		  $("create_reply_btn").disabled = false;

        } 

        hideFloatingDialog();
	  } 
	} 
  }
  else
  {
	content.update("Please select text containing characters from one valid element.")
  	  new Insertion.Bottom(content, "<p><input type=\"button\" name=\"dlg_cancel_btn\" value=\"Close\" onclick=\"hideFloatingDialog();\"/></p>");
  }
			
}


function addEntityTag(id, tag, start, end)
{
  new Insertion.Bottom($("entity_tag_form"), "<input type=\"hidden\" name=\""+id+"\" value=\""+tag+":"+start+","+end+"\"");
}

