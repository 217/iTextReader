//
//  ContentViewController.m
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/13.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import "ContentViewController.h"
#import "DZWebBrowser.h"

@interface ContentViewController (){
    UIImageView *shadow;
    BOOL is_last;
    NSURL *URL;
}

@end

@implementation ContentViewController

#pragma mark initWith~
- (id)initWithXhtmlpath:(NSString *)aFilepath page:(NSUInteger) aPagenum{
    if (self = [super init]){
        UIMenuItem *maker_btn = [[UIMenuItem alloc] initWithTitle:@"マーカー" action:@selector(highlight:)];
        UIMenuItem *underline_btn = [[UIMenuItem alloc] initWithTitle:@"アンダーライン" action:@selector(underline:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:maker_btn, underline_btn, nil]];
        
        _xhtmlpath = aFilepath;
        _pageNum = aPagenum;
        is_last = false;
        
        shadow = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"shadow.png"]];
        
        _wv = [[UIWebView alloc] init];
        _wv.delegate = self;
        _wv.scrollView.bounces = NO;
        _wv.scrollView.scrollEnabled = NO;
        [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: _xhtmlpath]]];
        
        while(!_pageLoadFinish){
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.07]];
        }
    }
    return self;
}

- (id)initWithXhtmlpathPageLast:(NSString *)aFilepath{
    if (self = [super init]){
        UIMenuItem *maker_btn = [[UIMenuItem alloc] initWithTitle:@"マーカー" action:@selector(highlight:)];
        UIMenuItem *underline_btn = [[UIMenuItem alloc] initWithTitle:@"アンダーライン" action:@selector(underline:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:maker_btn, underline_btn, nil]];
        
        _xhtmlpath = aFilepath;
        is_last = true;
        
        shadow = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"shadow.png"]];
        
        _wv = [[UIWebView alloc] init];
        _wv.delegate = self;
        _wv.scrollView.bounces = NO;
        _wv.scrollView.scrollEnabled = NO;
        [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: _xhtmlpath]]];
        
        while(!_pageLoadFinish){
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow:0.07]];
        }
        //        shadow = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"shadow-1.png"]];
    }
    return self;
}

#pragma mark Maker And UnderLine
-(void)highlight:(UIMenuController*)sender {
//    //isShowingSubmenu = YES;
//    if([settingsViewController.makerColor isEqual: @"red"]){
//        [wv stringByEvaluatingJavaScriptFromString: @"highlight('red');"];
//    }else if([settingsViewController.makerColor isEqual: @"yellow"]){
//        [wv stringByEvaluatingJavaScriptFromString: @"highlight('yellow');"];
//    }else if([settingsViewController.makerColor isEqual: @"orange"]){
//        [wv stringByEvaluatingJavaScriptFromString: @"highlight('orange');"];
//    }
    [_wv stringByEvaluatingJavaScriptFromString: @"highlight('yellow');"];
}

-(void)underline:(UIMenuController*)sender {
    [_wv stringByEvaluatingJavaScriptFromString: @"underline('yellow');"];
}

#pragma mark XHTML ReSize
- (NSString*) loadCSS: (NSString*) filename{
    NSString* path = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] bundlePath], filename];
    NSString* css = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: NULL];
    
    // EOFエラーの原因である\nを削除
    css = [css stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return css;
}

- (void)webViewDidFinishLoad: (UIWebView *) theWebView{
//    CGSize screen_size = [[UIScreen mainScreen] applicationFrame].size;
    NSMutableString *css = [[NSMutableString alloc] init];
    
    [css appendString: [NSString stringWithFormat: @"html{ padding: 0px; width: %fpx; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx; } ", floor(kWebviewWidthRatio*self.view.frame.size.width), ceil(kWebviewHeightRatio*self.view.frame.size.height), floor(kWebviewWidthRatio*self.view.frame.size.width)]];
    [css appendString: @"p{ text-align: justify; } "];
    [css appendString: [NSString stringWithFormat: @"img{ max-height: %fpx; max-width: %fpx; } ", kWebviewHeightRatio*self.view.frame.size.height-50, kWebviewWidthRatio*self.view.frame.size.width-50]];
    
    // JavaScriptのinit
    NSString *init_js = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"init" ofType:@"js"] encoding:NSUTF8StringEncoding error: NULL];
	[_wv stringByEvaluatingJavaScriptFromString: init_js];
    NSString *highlight_js = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"highlight" ofType: @"js"] encoding: NSUTF8StringEncoding error: NULL];
    [_wv stringByEvaluatingJavaScriptFromString: highlight_js];
    NSString *underline_js = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"underline" ofType: @"js"] encoding: NSUTF8StringEncoding error: NULL];
    [_wv stringByEvaluatingJavaScriptFromString: underline_js];
    
    // init.cssの適用
    [_wv stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"applyCSS('%@');", css]];
    // highlight.cssの適用
    [_wv stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"applyCSS('%@');", [self loadCSS: @"highlight.css"]]];
    // underline.cssの適用
    [_wv stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"applyCSS('%@');", [self loadCSS: @"underline.css"]]];
    
    _total_width = [[_wv stringByEvaluatingJavaScriptFromString: @"document.documentElement.scrollWidth;"] doubleValue];
    _pageCount = _total_width/floor(_wv.bounds.size.width);
    
    // pageをスクロールさせる
    [_wv stringByEvaluatingJavaScriptFromString: @"function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
    NSString *scroll_js = [[NSString alloc] init];
    if(is_last){
        _pageNum = _pageCount-1;
        scroll_js = [NSString stringWithFormat: @"pageScroll(%f)", floor(_wv.bounds.size.width)*_pageNum];
    }else{
        scroll_js = [NSString stringWithFormat: @"pageScroll(%f)", floor(_wv.bounds.size.width)*_pageNum];
    }
    [_wv stringByEvaluatingJavaScriptFromString: scroll_js];
    
    // 各種変数の初期化
    _now_width = floor(_wv.bounds.size.width)*_pageNum;
    
    //selectした範囲の座標を返却する関数
    [_wv stringByEvaluatingJavaScriptFromString: @"function getRectForSelectedText() {"
     "var selection = window.getSelection();"
     "var range = selection.getRangeAt(0);"
     "var rect = range.getBoundingClientRect();"
     "return \"{{\" + rect.left + \",\" + rect.top + \"}, {\" + rect.width + \",\" + rect.height + \"}}\";"
     "}"];

    //    NSLog(@"%@: %f/%f = %d", [_xhtmlpath lastPathComponent], _total_width, screen_size.width, _pageCount);
    [css release];
    _pageLoadFinish = true;
}

- (UIWebView *) page:(NSUInteger)pageNum{
    CGSize screen_size = [[UIScreen mainScreen] applicationFrame].size;
    
    NSString *js = [NSString stringWithFormat: @"pageScroll(%f)", screen_size.width*pageNum];
    [_wv stringByEvaluatingJavaScriptFromString: js];
    return _wv;
}

#pragma mark Request get
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* nextUrl= [[NSString alloc] initWithString: [[request URL] absoluteString]];
    
    // ハイパーリンクの処理
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        if([nextUrl hasPrefix: @"file://"]){
            // 通知してページジャンプする
            _jumpFilePath = nextUrl;
            return NO;
        }else if ([nextUrl hasPrefix: @"http://"] || [nextUrl hasPrefix: @"https://"]){
            URL = [[NSURL alloc] initWithString: nextUrl];
                
            DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:URL];
            webBrowser.showProgress = NO;
            webBrowser.allowSharing = NO;
//            webBrowser.resourceBundleName = @"custom-controls";
            
            UINavigationController *webBrowserNC = [[UINavigationController alloc] initWithRootViewController:webBrowser];
            [self presentViewController:webBrowserNC animated:YES completion:NULL];
            
            return NO;  
        }
    }
    
    // 上記以外のリクエストは、そのまま発信する。
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shadow.frame = CGRectMake(kShadowXRatio*self.view.frame.size.width, kShadowYRatio*self.view.frame.size.height, kShadowWidthRatio*self.view.frame.size.width, kShadowHeightRratio*self.view.frame.size.height);
    _wv.frame = CGRectMake(kWebviewXRatio*self.view.frame.size.width, kWebviewYRatio*self.view.frame.size.height, kWebviewWidthRatio*self.view.frame.size.width, kWebviewHeightRatio*self.view.frame.size.height);
    
	// Do any additional setup after loading the view.
    [self.view addSubview: _wv];
    [self.view addSubview: shadow];
}

- (void)dealloc{
    [_wv release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
