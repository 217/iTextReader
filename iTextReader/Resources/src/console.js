// UIWebViewでJavaScriptのconsole.logができない為作成 8/2
// イベントを起こさないと使えないクソスクリプト
// TODO: コンソール出力
window.log = function(msg) {
    if(typeof msg === 'undefined'){
        msg = 'undefined'
    }
    // まずは通常通りのログ出力を行う。
    console.log(msg);
    
    // UIWebViewを用い手居る場合には、
    // XCODEのコンソールにも出力する仕組みを導入する。
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", "ios-log:#iOS#" + msg);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}
window.onerror = function(errMsg, url, lineNumber) {
    window.log(errMsg + ", file=" + url + ":" + lineNumber);
}