//
//  SEArchivableDatabase.h
//  SEArchivable
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEArchivableDatabase : NSObject

+ (NSMutableArray *)loadSerializables:(NSString *)fileExtension;
+ (NSString *)nextPath:(NSString *)fileExtension;
+ (NSString *)getPrivateDocsDir;

@end
