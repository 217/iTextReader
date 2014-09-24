//
//  AppDelegate.h
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/11.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewController.h"
#import "Demo1ViewController.h"
#import "CHDraggingCoordinator.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CHDraggingCoordinatorDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BookViewController *viewController;
//@property (strong, nonatomic) Demo1ViewController *viewController;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;

@end
