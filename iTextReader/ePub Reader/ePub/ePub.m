//
//  ePub.m
//  SchoolBook
//
//  Created by Tetsunari Niina on 2013/07/01.
//  Copyright (c) 2013年 Neil Smyth. All rights reserved.
//

#import "ePub.h"
#import "ZipArchive.h"
#import "XMLReader.h"

@implementation ePub

- (id)initWithFilename: (NSString*) filename{
    epubname = filename;
    NSString *rootpath = [[NSBundle mainBundle] bundlePath];
    epubpath = [NSString stringWithFormat:@"%@/%@", rootpath, filename];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    savedir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], filename];
    
    return self;
}

- (BOOL)unzip{
    ZipArchive *za = [[ZipArchive alloc] init];
    [za UnzipOpenFile: epubpath];
    BOOL ret = [za UnzipFileTo: savedir overWrite:YES];
    
    if(ret == NO){
        NSLog(@"Unzip Error");
        return NO;
    }
    
    [za UnzipCloseFile];
    [za release];
    return YES;
}

- (BOOL)parse{
    NSError *error = nil;
    NSString *xml = [NSString stringWithFormat: @"%@/META-INF/container.xml", savedir];

    BOOL xmlexist = [[NSFileManager defaultManager] fileExistsAtPath: xml];
    if(!xmlexist){
        NSLog(@"container.xml not found.");
        NSLog(@"%@", xml);
        return NO;
    }
    
    // containier.xmlを開いてリード
    NSString *xmlstr = [NSString stringWithContentsOfFile: xml encoding:NSUTF8StringEncoding error: &error];
    if(error != nil){
        NSLog(@"%@", error);
    }
    
    // containier.xmlのパース -> 連想配列
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString: xmlstr error: &error];
    if(error != nil){
        NSLog(@"%@", error);
    }
    
    // TODO: もし要素が存在しなかった場合の処理も加える
    NSString *opfFromRootpath = [xmlDictionary valueForKeyPath:@"container.rootfiles.rootfile.full-path"];
    NSString *opfPath = [savedir stringByAppendingPathComponent: opfFromRootpath];
    NSString *opfString = [NSString stringWithContentsOfFile:opfPath encoding:NSUTF8StringEncoding error: &error];
    if(error != nil){
        NSLog(@"%@", error);
        return NO;
    }
    
    NSDictionary *opf = [XMLReader dictionaryForXMLString:opfString error: &error];
    if(error != nil){
        NSLog(@"%@", error);
        return NO;
    }
    
    // <manifest> の <item>をページ
    // Page - ページのデータ - ページIDと場所
    NSArray *ids = [opf valueForKeyPath:@"package.manifest.item.id"];
    NSArray *hrefs = [opf valueForKeyPath:@"package.manifest.item.href"];

    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    for(int i = 0;i<[ids count];i++){
        [data setObject: hrefs[i] forKey: ids[i]];
    }
    
    pagedata = [[NSDictionary alloc] initWithDictionary: data];
    [data release];
    
    // <item> の <manifest> のロード
    // ページの順番にロード
    xhtmls = [[NSArray alloc] initWithArray: [opf valueForKeyPath:@"package.spine.itemref.idref"]];
    
    return YES;
}

-(int) xhtmlCount{
    return [self->xhtmls count];
}

-(NSString*) xhtmlPath: (int)xhtmlnum{
    NSString *path = [pagedata objectForKey: xhtmls[xhtmlnum]];
    NSString *xhtmlpath = [NSString stringWithFormat: @"%@/OEBPS/%@", savedir, path];
    return xhtmlpath;
}

-(NSArray*) xhtmlPaths{
    NSMutableArray *xhtmlpaths = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 0; i < [self xhtmlCount];i++){
        NSString *path = [self->pagedata objectForKey: xhtmls[i]];
        NSString *xhtmlpath = [NSString stringWithFormat: @"%@/OEBPS/%@", savedir, path];
        [xhtmlpaths addObject: xhtmlpath];
    }
    return [[NSArray alloc] initWithArray: xhtmlpaths];
}

- (NSString*) filename{
    return epubname;
}

- (NSString*)savedir{
    return savedir;
}

-(NSString*)epubpath{
    return epubpath;
}

@end