//
//  SEArchivableDatabase.h
//  SEArchivable
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SEArchivable;

@interface SEArchivableDatabase : NSObject

+ (NSMutableArray *)loadSerializables:(NSString *)fileExtension;
+ (void)loadSerializablesSerially:(NSString *)fileExtension block:(void (^)(id<SEArchivable>))block;
+ (NSString *)nextPath:(NSString *)fileExtension;
+ (NSString *)getPrivateDocsDir;

@end
