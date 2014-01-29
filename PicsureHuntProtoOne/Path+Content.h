//
//  Path+Content.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/23.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "Path.h"

@interface Path (Content)

+ (Path *)pathWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Path *)pathWithID:(NSString *)pathID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
