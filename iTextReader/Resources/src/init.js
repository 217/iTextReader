function applyCSS(css){
    var style = document.createElement('style');
    style.type = 'text/css';
    css = css.replace(/\n/g, "\\\n");
    console.log(css);
    var cssContent = document.createTextNode(css);
    style.appendChild(cssContent);
    document.body.appendChild(style);
}

/*
var mySheet = document.styleSheets[0];

function addCSSRule(selector, newRule) {
if (mySheet.addRule) {
mySheet.addRule(selector, newRule); 							// For Internet Explorer
} else {
ruleIndex = mySheet.cssRules.length;
mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);   // For Firefox, Chrome, etc.
}
}
*/