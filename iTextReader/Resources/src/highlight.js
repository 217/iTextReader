/*
document.addEventListener("touchend", touchend, false);

function touchend(){
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    
    if(range && !selection.isCollapsed){
        if(selection.anchorNode.parentNode == selection.focusNode.parentNode){
            if(selection.focusNode.parentNode.tagName === 'SPAN' &&
               selection.focusNode.parentNode.className === 'highlight-yellow'){
                return;
            }
            var span = document.createElement('span');
            span.className = "highlight-yellow";
            range.surroundContents(span);
        }
    }
}
 */

function highlight(color){
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    
    if(
       range//&& !selection.isCollapsed
       ){
        if(selection.anchorNode.parentNode == selection.focusNode.parentNode){
            if(selection.focusNode.parentNode.tagName === 'SPAN' &&
               selection.focusNode.parentNode.className === 'highlight-yellow'){
                return;
            }
            var span = document.createElement('span');
            span.className = "highlight-"+color;
            range.surroundContents(span);
        }
    }
}