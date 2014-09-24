//
//  ePubTest.m
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/11.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "ePub.h"

@interface ePubTest : GHTestCase

@end

@implementation ePubTest

- (void)testUnzip{
    ePub *epub = [[ePub alloc] initWithFilename: @"sample-1.epub"];
    GHAssertTrue([epub unzip], nil);
}

- (void)testParse{
    ePub *epub = [[ePub alloc] initWithFilename: @"sample-1.epub"];
    GHAssertTrue([epub unzip], nil);
    GHAssertTrue([epub parse], nil);
}

- (void)testXhtmlPath{
    ePub *epub = [[ePub alloc] initWithFilename: @"sample-1.epub"];
    GHAssertTrue([epub unzip], nil);
    GHAssertTrue([epub parse], nil);
    GHAssertNotEqualStrings([epub xhtmlPath:0], @"(null)", nil);
}

-(void) testXhtmlPaths{
    ePub *epub = [[ePub alloc] initWithFilename: @"sample-1.epub"];
    GHAssertTrue([epub unzip], nil);
    GHAssertTrue([epub parse], nil);
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for(int i=0;i<[epub xhtmlCount];i++){
        [paths addObject: [epub xhtmlPath:i]];
    }
    GHAssertEqualObjects([epub xhtmlPaths], paths, nil);
}

-(void) testXhtmlCount{
    ePub *epub = [[ePub alloc] initWithFilename: @"sample-1.epub"];
    GHAssertTrue([epub unzip], nil);
    GHAssertTrue([epub parse], nil);
    GHAssertEquals([epub xhtmlCount], 20, nil);
}

@end