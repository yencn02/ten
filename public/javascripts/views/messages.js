//document.observe("dom:loaded", function() {
//    $('checkAll').observe('click', respondToClick);
//})

function respondToClick(event) {
    var element = Event.element(event);
    boxes = document.getElementsByClassName('messageCheckedBox');
    for(i=0; i<boxes.length; i++)
    {
        boxes[i].checked = element.checked;
    }
}