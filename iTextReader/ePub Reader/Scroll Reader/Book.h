//
//  Book.h
//  iTextReader
//
//  Created by Tetsunari Niina on 2013/09/21.
//  Copyright (c) 2013年 Tetsunari Niina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ePub.h"

@interface Book : NSObject

@property (readonly) ePub *epub;

- (id) initWithFilename:(NSString *)filename;

@end
