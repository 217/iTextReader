//
//  ContentViewController.h
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/13.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController<UIWebViewDelegate>

@property (readonly) UIWebView *wv;

// xhtml status
@property (readonly) double now_width;
@property (readonly) double total_width;
@property (readonly) NSUInteger pageNum;
@property (readonly) NSUInteger pageCount;
@property (readonly) BOOL pageLoadFinish;

@property (nonatomic, retain) NSString *epubpath;
@property (nonatomic, retain) NSString *savedir;
@property (nonatomic, retain) NSString *xhtmlpath;

@property (readonly) NSString *jumpFilePath;

- (id)initWithXhtmlpath:(NSString *)aFilepath page:(NSUInteger) aPagenum;
- (id)initWithXhtmlpathPageLast:(NSString *)aFilepath;

@end