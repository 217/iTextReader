//
//  BookViewController.h
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/13.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ePub.h"
#import "ContentViewController.h"

@interface BookViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (readonly) ePub *epub;
@property NSUInteger now_chapter_num;
@property (readonly) UIPageViewController *pvc;
@property (readonly) ContentViewController *cvc;
@property (readonly) BOOL pageIsAnimating;
@property NSUInteger nowXhtmlPageNum;

@property (nonatomic, retain, readonly) ContentViewController *backPage;
@property (nonatomic, retain, readonly) ContentViewController *nextPage;
// -1の場合は存在しない場合になる
@property (nonatomic, readonly) NSInteger backPageChpNum;
@property (nonatomic, readonly) NSInteger nextPageChpNum;
@property (nonatomic, readonly) NSInteger backPageXhtmlPageNum;
@property (nonatomic, readonly) NSInteger nextPageXhtmlPageNum;

- (id)initWithFilepath:(NSString *)filepath;

@end
