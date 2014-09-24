//
//  BookViewControllerTest.m
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/13.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "BookViewController.h"

@interface BookViewController(Private)

//@property NSUInteger now_chapter_num;
//@property NSUInteger nowXhtmlPageNum;

- (void)pageLoad;

@end

@interface BookViewControllerTest : GHTestCase{
    BookViewController *bookViewController;
}

@end

@implementation BookViewControllerTest

#pragma mark should Run On Main Thread
- (BOOL)shouldRunOnMainThread {
    return YES;
}

#pragma mark Page Load backPage And nextPage

- (void)testPageLoadInFirstPage{
    bookViewController = [[BookViewController alloc] initWithFilepath: @"sample-1.epub"];
    bookViewController.now_chapter_num = 0;
    bookViewController.nowXhtmlPageNum = 0;
    [bookViewController pageLoad];
    GHAssertNil(bookViewController.backPage, @"最初の章かつ最初のページの場合, nilになる");
    GHAssertNotNil(bookViewController.nextPage, @"次の章は存在");
    GHAssertEquals(bookViewController.backPageChpNum, -1, @"前のページは存在しないのではChapterは-1");
    GHAssertEquals(bookViewController.backPageXhtmlPageNum, -1, @"前のページは存在しないのでxhtmlPageNumは-1");
    GHAssertEquals(bookViewController.nextPageChpNum, 1, @"Chapter1へ");
    GHAssertEquals(bookViewController.nextPageXhtmlPageNum, 0, @"XhtmlPageNumは0");
//
//    // xhtml内でページを戻れる場合
//    }else if(_nowXhtmlPageNum != 0){
//        backPageChpNum = _now_chapter_num;
//        backPageXhtmlPageNum = _nowXhtmlPageNum-1;
//        backPage = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: _now_chapter_num] page: backPageXhtmlPageNum];
//        // チャプターを戻る場合
//    }else{
//        backPageChpNum = _now_chapter_num-1;
//        backPage = [[ContentViewController alloc] initWithXhtmlpathPageLast: [_epub xhtmlPath: _now_chapter_num]];
//        backPageXhtmlPageNum = backPage.pageCount-1;
//    }
//    NSLog(@"Back - Chp: %d Page: %d PageCnt: %d", backPageChpNum, backPageXhtmlPageNum, backPage.pageCount);
//    
//    // ページを進められない場合
//    if(_now_chapter_num == [_epub xhtmlCount]-1 && _nowXhtmlPageNum == _cvc.pageCount-1){
//        nextPage = nil;
//        // xhtml内でページを進めれる場合
//    }else if(_nowXhtmlPageNum != _cvc.pageCount-1){
//        nextPageChpNum = _now_chapter_num;
//        nextPageXhtmlPageNum = _nowXhtmlPageNum+1;
//        nextPage = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: nextPageChpNum] page: nextPageXhtmlPageNum];
//    }else{
//        nextPageChpNum = _now_chapter_num+1;
//        nextPageXhtmlPageNum = 0;
//        nextPage = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: nextPageChpNum] page: nextPageXhtmlPageNum];
//    }
//    NSLog(@"Next - Chp: %d Page: %d PageCnt: %d", nextPageChpNum, nextPageXhtmlPageNum, nextPage.pageCount);
//    NSLog(@"Now - PageCnt: %d", _cvc.pageCount);
}

- (void)testPageLoadInLastPage{
    bookViewController = [[BookViewController alloc] initWithFilepath: @"sample-1.epub"];
    bookViewController.now_chapter_num = 19;
    bookViewController.nowXhtmlPageNum = 0;
    [bookViewController pageLoad];
    GHAssertNotNil(bookViewController.backPage, @"前の章は存在");
    GHAssertNil(bookViewController.nextPage, @"最後の章かつ最後のページの場合, nilになる");;
    GHAssertEquals(bookViewController.backPageChpNum, 18, @"前のページは Chapter18");
    GHAssertEquals(bookViewController.backPageXhtmlPageNum, 8, @"前のページのxhtmlPageNumは8");
    GHAssertEquals(bookViewController.nextPageChpNum, -1, @"最後のページは存在しない為ChapterNumは-1");
    GHAssertEquals(bookViewController.nextPageXhtmlPageNum, -1, @"最後のページは存在しない為xhtmlPageNumは-1");
}

@end
