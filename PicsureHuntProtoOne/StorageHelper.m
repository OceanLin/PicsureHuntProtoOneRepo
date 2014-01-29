//
//  StorageHelper.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "StorageHelper.h"
#import "InternalNotificationHelper.h"

@interface StorageHelper ()

@property UIManagedDocument *document;

@end

@implementation StorageHelper

static StorageHelper *instance = nil;

+ (StorageHelper *)sharedInstance
{
    static dispatch_once_t storageOnceToken;
    dispatch_once(&storageOnceToken, ^{
        instance = [[StorageHelper alloc] init];
        [instance setupStorage];
    });
    
    return instance;
}

- (void)setupStorage
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"PicsureHuntDocument";
    NSURL *documentURL = [documentDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:documentURL];
    if ([fileManager fileExistsAtPath:[documentURL path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self documentReady];
            } else {
                NSLog(@"StorageHelper open the document [%@] fail.", [documentURL path]);
            }
        }];
    } else {
        [self.document saveToURL:documentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [self documentReady];
            } else {
                NSLog(@"StorageHelper create the document [%@] fail.", [documentURL path]);
            }
        }];
    }
}

- (void)documentReady
{
    self.context = self.document.managedObjectContext;
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ContextReadyNotification object:self userInfo:@{POIManagedObjectContext: self.context}];
}

@end
