//
//  ePub.h
//  SchoolBook
//
//  Created by Tetsunari Niina on 2013/07/01.
//  Copyright (c) 2013年 Neil Smyth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ePub : NSObject{
    NSString *epubname;
    NSString *epubpath;
    NSString *savedir;
    NSDictionary *pagedata;
    NSArray *xhtmls;
}

- (id)initWithFilename:(NSString *)filename;
- (BOOL)unzip;
- (BOOL)parse;
- (NSString *)xhtmlPath:(int)xhtmlnum;
- (NSArray *)xhtmlPaths;
- (int)xhtmlCount;
- (NSString *)filename;
- (NSString *)savedir;
- (NSString *)epubpath;

@end
