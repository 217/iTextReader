//
//  Book.m
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/21.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id) initWithFilename:(NSString *)filename{
    if([super init]){
        _epub = [[ePub alloc] initWithFilename: filename];
        
    }
    return self;
}

@end
