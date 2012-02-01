//
//  SESimpleObjectArchiver.m
//  SESimpleObjectArchiver
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//

#import "SESimpleObjectArchiver.h"
#import "SEArchivableDatabase.h"

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation SESimpleObjectArchiver

+ (BOOL) createDataPath:(id<SEArchivable>)forObject {
  if ([forObject docPath] == nil)
    [forObject setDocPath:[SEArchivableDatabase nextPath:[[forObject class] getFileExtension]]];
  
  NSError *error;
  BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[forObject docPath]
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error];
  if (!success)
    NSLog(@"Error creating data path: %@", [error localizedDescription]);
    
  return success;
}

+ (id<SEArchivable>) loadFromFile:(NSString *)docPath {
  NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
  NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
  if (codedData == nil) return nil;
  
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
  id<SEArchivable> obj = [unarchiver decodeObjectForKey:kDataKey];
  [unarchiver finishDecoding];
  
  [obj setDocPath:docPath];
  
  return obj;
}

+ (void) saveToFile:(id<SEArchivable>)forObject {
  [self createDataPath:forObject];

  NSString *dataPath = [[forObject docPath] stringByAppendingPathComponent:kDataFile];
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [archiver encodeObject:forObject forKey:kDataKey];
  [archiver finishEncoding];
  [data writeToFile:dataPath atomically:YES];
}

+ (void) deleteFile:(id<SEArchivable>)forObject {
  NSError *error;
  BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[forObject docPath] error:&error];
  if (!success)
    NSLog(@"Error removing document path: %@", error.localizedDescription);
}

@end
