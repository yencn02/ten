function tabselect(tab) {
  var tablist = $('tabcontrol').getElementsByTagName('li');
  var nodes = $A(tablist);
  var lClassType = tab.className.substring(0, tab.className.indexOf('-') );

  nodes.each(function(node){
    if (node.id == tab.id)
      tab.className=lClassType+'-selected';
    else
      node.className=lClassType+'-unselected';
  });
}

function paneselect(pane) {
  var panelist = $('panecontrol').getElementsByTagName('li');
  var nodes = $A(panelist);

  nodes.each(function(node){
    if (node.id == pane.id)
      pane.className='pane-selected';
    else
      node.className='pane-unselected';
  });
}

function loadPane(pane, src) {
  if(pane.innerHTML!='<img alt="Wait" src="/images/spinner.gif" style="vertical-align:-3px" /> Loading...')
    new Ajax.Updater(pane, src, {asynchronous:1, evalScripts:true, onLoading:function(request){pane.innerHTML='<img alt="Wait" src="/images/spinner.gif" style="vertical-align:-3px" /> Loading...'}})
}


function prepareSubmit(){
  var pro = getElementById('project');
  
  
  if(pro){
    if(pro.value == -2){
      alert('Please select a project');
      return false;
    }
    else if(pro.value == 0 || pro.value == -1){
      alert('Send message failed because the project does not have a handler');
      return false;
    }  
    return true;
  }

  var type = document.forms[0].sendTo;

  var elm = getElementById('receiver_list');
  if(elm.length <= 0 && type[0].checked){
    alert('Message should be sent to at least one user');
    return false;
  }
  for(i=0; i< elm.length; i++) {
    elm.options[i].selected = true;
  }

  return true;
}
