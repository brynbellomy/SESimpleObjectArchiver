//
//  SEArchivable.h
//  SEArchivable
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol SEArchivable <NSCoding, NSObject>

+ (NSString *)getFileExtension;
- (NSString *)docPath;
- (void)setDocPath:(NSString *)docPath;

@end

@interface SESimpleObjectArchiver : NSObject

+ (BOOL) createDataPath:(id<SEArchivable>)forObject;
+ (id<SEArchivable>) loadFromFile:(NSString *)docPath;
+ (void) saveToFile:(id<SEArchivable>)forObject;
+ (void) deleteFile:(id<SEArchivable>)forObject;

@end
