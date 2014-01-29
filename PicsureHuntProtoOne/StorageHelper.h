//
//  StorageHelper.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageHelper : NSObject

@property (nonatomic, strong)NSManagedObjectContext *context;
+ (StorageHelper *)sharedInstance;

@end
