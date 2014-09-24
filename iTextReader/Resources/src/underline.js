function underline(color){
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    
    if(
       range//&& !selection.isCollapsed
       ){
        if(selection.anchorNode.parentNode == selection.focusNode.parentNode){
            if(selection.focusNode.parentNode.tagName === 'SPAN' &&
               selection.focusNode.parentNode.className === 'underline-yellow'){
                return;
            }
            var span = document.createElement('span');
            span.className = "underline-"+color;
            range.surroundContents(span);
        }
    }
}