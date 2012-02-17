//
//  SESimpleObjectArchiver.h
//  SESimpleObjectArchiver
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//


#import <Foundation/Foundation.h>

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@protocol SEArchivable <NSCoding, NSObject>

+ (NSString *)getFileExtension;
- (NSString *)docPath;
- (void)setDocPath:(NSString *)docPath;

@end

@interface SESimpleObjectArchiver : NSObject

+ (BOOL) createDataPath:(id<SEArchivable>)forObject;
+ (id<SEArchivable>) loadFromFile:(NSString *)docPath __attribute__((ns_returns_autoreleased));
+ (void) saveToFile:(id<SEArchivable>)forObject;
+ (void) deleteFileForObject:(id<SEArchivable>)obj;
+ (void) deleteFile:(NSString *)docPath;

@end
