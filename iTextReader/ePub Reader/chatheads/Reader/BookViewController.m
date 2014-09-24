//
//  BookViewController.m
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/13.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController (){
    UIImageView *pageThickness_;
    
    ContentViewController *backPage_;
    ContentViewController *nextPage_;
    
    BOOL isBackPaging_;
    NSInteger backPageChpNum_;
    NSInteger nextPageChpNum_;
    // 前のページのxhtml内のページ番号
    NSInteger backPageXhtmlPageNum_;
    NSInteger nextPageXhtmlPageNum_;
}

@end

@implementation BookViewController

@synthesize backPage = backPage_,
            nextPage = nextPage_,
            backPageChpNum = backPageChpNum_,
            nextPageChpNum = nextPageChpNum_,
            backPageXhtmlPageNum = backPageXhtmlPageNum_,
            nextPageXhtmlPageNum = nextPageXhtmlPageNum_;

- (id)initWithFilepath:(NSString *)filepath{
    if(self = [super init]){
        CGSize screen_size = [[UIScreen mainScreen] applicationFrame].size;
        
        _epub = [[ePub alloc] initWithFilename: filepath];
        [_epub unzip];
        [_epub parse];
        
        pageThickness_ = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"page-thickness.png"]];
        pageThickness_.frame = CGRectMake(kPageThicknessXRatio*screen_size.width, kPageThicknessYRatio*screen_size.height, kPageThicknessWidthRatio*screen_size.width, kPageThicknessHeightRatio*screen_size.height);
        
        _cvc = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: 0] page: 0];
        _cvc.view.frame = CGRectMake(kLeftGapRatio*screen_size.width, kUpGapRatio*screen_size.height, screen_size.width*(1-kLeftGapRatio-kRightGapRatio), screen_size.height*(1-kUpGapRatio-kDownGapRatio));
        _cvc.epubpath = [_epub epubpath];
        _cvc.savedir = [_epub savedir];
        
        _pvc = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options: nil];
        _pvc.view.frame = CGRectMake(kLeftGapRatio*screen_size.width, kUpGapRatio*screen_size.height, screen_size.width*(1-kLeftGapRatio-kRightGapRatio), screen_size.height*(1-kUpGapRatio-kDownGapRatio));
        _pvc.delegate = self;
        _pvc.dataSource = self;
        [_pvc setViewControllers: @[_cvc] direction: UIPageViewControllerNavigationDirectionForward animated: NO completion: nil];
        
        _now_chapter_num = 0;
        _nowXhtmlPageNum = 0;
        backPageChpNum_ = -1;
        backPageXhtmlPageNum_ = -1;
        nextPageChpNum_ = -1;
        nextPageXhtmlPageNum_ = -1;
        
        [_cvc.jumpFilePath addObserver: self
                            forKeyPath: @"jumpFilePath"
                               options: (NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                               context: NULL];
        [self pageLoad];
    }
    return self;
}

#pragma mark Key-Value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if([keyPath isEqual: @"jumpFileParh"]){

    }
}

#pragma mark Page Jump
-(void)pageJump:(NSNotification *)center{
    NSArray *xhtmlPaths = [_epub xhtmlPaths];
    NSString *xhtmlPath = [[center userInfo] objectForKey: @"path"];
    _cvc = [[ContentViewController alloc] initWithXhtmlpath: xhtmlPath page: 0];
    _nowXhtmlPageNum = (NSUInteger)[xhtmlPaths valueForKey: xhtmlPath];
    _nowXhtmlPageNum = 0;
    
    [self pageLoad];
}

#pragma mark ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"wood.png"]];
    
    [_pvc addChildViewController: _cvc];
    [_pvc.view addSubview: _cvc.view];
    [_cvc didMoveToParentViewController: _pvc];
    [self.view addSubview: _pvc.view];
    [self.view addSubview: pageThickness_];
}

#pragma mark Page Load backPage And nextPage
- (void)pageLoad{
    // ページを戻れない場合
    if(_now_chapter_num == 0 && _nowXhtmlPageNum == 0){
        backPageChpNum_ = -1;
        backPageXhtmlPageNum_ = -1;
        backPage_ = nil;
    // xhtml内でページを戻れる場合
    }else if(_nowXhtmlPageNum != 0){
        backPageChpNum_ = _now_chapter_num;
        backPageXhtmlPageNum_ = _nowXhtmlPageNum-1;
        backPage_ = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: backPageChpNum_] page: backPageXhtmlPageNum_];
    // チャプターを戻る場合
    }else{
        backPageChpNum_ = _now_chapter_num-1;
        backPage_ = [[ContentViewController alloc] initWithXhtmlpathPageLast: [_epub xhtmlPath: backPageChpNum_]];
        backPageXhtmlPageNum_ = backPage_.pageCount-1;
    }
//    NSLog(@"Back - %@: %d Page: %d PageCnt: %d", [backPage_.xhtmlpath lastPathComponent], backPageChpNum_, backPageXhtmlPageNum_, backPage_.pageCount);
    
    // ページを進められない場合
    if(_now_chapter_num == [_epub xhtmlCount]-1 && _nowXhtmlPageNum == _cvc.pageCount-1){
        nextPageChpNum_ = -1;
        nextPageXhtmlPageNum_ = -1;
        nextPage_ = nil;
        // xhtml内でページを進めれる場合
    }else if(_nowXhtmlPageNum != _cvc.pageCount-1){
        nextPageChpNum_ = _now_chapter_num;
        nextPageXhtmlPageNum_ = _nowXhtmlPageNum+1;
        nextPage_ = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: nextPageChpNum_] page: nextPageXhtmlPageNum_];
    }else{
        nextPageChpNum_ = _now_chapter_num+1;
        nextPageXhtmlPageNum_ = 0;
        nextPage_ = [[ContentViewController alloc] initWithXhtmlpath: [_epub xhtmlPath: nextPageChpNum_] page: nextPageXhtmlPageNum_];
    }
//    NSLog(@"Next - %@: %d Page: %d PageCnt: %d", [nextPage_.xhtmlpath lastPathComponent],nextPageChpNum_, nextPageXhtmlPageNum_, nextPage_.pageCount);
//    NSLog(@"Now - PageCnt: %d", _cvc.pageCount);
}

#pragma mark UIPageViewController - delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    _pageIsAnimating = YES;
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerBeforeViewController: (UIViewController *)viewController
{
    if(_pageIsAnimating)
        return nil;
    
    isBackPaging_ = true;
    return backPage_;
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerAfterViewController: (UIViewController *)viewController{
    if(_pageIsAnimating)
        return nil;

    isBackPaging_ = false;
    return nextPage_;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    // ページのスクロールが終わった場合
    if (completed){
        // ページを戻った場合
        if(isBackPaging_){
            [_cvc release];
            _cvc = backPage_;
            _now_chapter_num = backPageChpNum_;
            _nowXhtmlPageNum = backPageXhtmlPageNum_;
        // ページを進んだ場合
        }else{
            [_cvc release];
            _cvc = nextPage_;
            _now_chapter_num = nextPageChpNum_;
            _nowXhtmlPageNum = nextPageXhtmlPageNum_;
        }
        
        backPage_ = nil;
        nextPage_ = nil;
        nextPageChpNum_ = -1;
        nextPageXhtmlPageNum_ = -1;
        backPageChpNum_ = -1;
        backPageXhtmlPageNum_ = -1;
        
        [self pageLoad];
        _pageIsAnimating = NO;
        // ページのスクロールがキャンセルされた場合
    }else if (finished){
        // Nothing
        _pageIsAnimating = NO;
    }
}

- (void)dealloc{
    // ページジャンプの通知を削除
    [[NSNotificationCenter defaultCenter] removeObserver:self name: @"ページジャンプする" object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
