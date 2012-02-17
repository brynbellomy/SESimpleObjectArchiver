//
//  SEArchivableDatabase.m
//  SEArchivable
//
//  Created by bryn austin bellomy on 2/1/12.
//  Copyright (c) 2012 signalenvelope LLC. All rights reserved.
//

#import "SEArchivableDatabase.h"
#import "SESimpleObjectArchiver.h"

@implementation SEArchivableDatabase

+ (NSString *)getPrivateDocsDir {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
  
  NSError *error;
  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];   
  
  return documentsDirectory;
}

+ (NSMutableArray *)loadSerializables:(NSString *)fileExtension {
  // Get private docs dir
  NSString *documentsDirectory = [SEArchivableDatabase getPrivateDocsDir];
  
  // Get contents of documents directory
  NSError *error;
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
  if (files == nil) {
    NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    return nil;
  }
  
  // Create a SEArchivable for each file
  NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
  for (NSString *file in files) {
    if ([file.pathExtension compare:fileExtension options:NSCaseInsensitiveSearch] == NSOrderedSame) {
      NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
      id<SEArchivable> obj = [SESimpleObjectArchiver loadFromFile:fullPath];
      if (obj != nil)
        [retval addObject:obj];
    }
  }
  
  return retval;
}

+ (void)loadSerializablesSerially:(NSString *)fileExtension block:(void (^)(id<SEArchivable>))block {
  // Get private docs dir
  NSString *documentsDirectory = [SEArchivableDatabase getPrivateDocsDir];
  
  // Get contents of documents directory
  NSError *error;
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
  if (files == nil) {
    NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    return;
  }
  
  // Create a SEArchivable for each file
  @autoreleasepool {
    for (NSString *file in files) {
      if ([file.pathExtension compare:fileExtension options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
        id<SEArchivable> obj = [SESimpleObjectArchiver loadFromFile:fullPath];
        block(obj);
        obj = nil;
      }
    }
  }
}

+ (NSString *)nextPath:(NSString *)fileExtension {
  // Get private docs dir
  NSString *documentsDirectory = [SEArchivableDatabase getPrivateDocsDir];
  
  // Get contents of documents directory
  NSError *error;
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
  if (files == nil) {
    NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    return nil;
  }
  
  // Search for an available name
  int maxNumber = 0;
  for (NSString *file in files) {
    if ([file.pathExtension compare:fileExtension options:NSCaseInsensitiveSearch] == NSOrderedSame) {            
      NSString *fileName = [file stringByDeletingPathExtension];
      maxNumber = MAX(maxNumber, fileName.intValue);
    }
  }
  
  // Get available name
  NSString *availableName = [NSString stringWithFormat:@"%d.%@", maxNumber + 1, fileExtension];
  return [documentsDirectory stringByAppendingPathComponent:availableName];
}

@end
