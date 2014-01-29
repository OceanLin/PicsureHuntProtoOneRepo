//
//  Path+Content.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/23.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "Path+Content.h"

@implementation Path (Content)

+ (Path *)pathWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Path *path;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Path"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Fetch data from Path entity fail : error [Reason : %@][Description : %@]", error.localizedFailureReason, error.localizedDescription);
    } else if ([matches count]) {
        path = [matches firstObject];
    } else {
        path = [NSEntityDescription insertNewObjectForEntityForName:@"Path" inManagedObjectContext:context];
        path.title = name;
    }
    
    return path;
}

+ (Path *)pathWithID:(NSString *)pathID inManagedObjectContext:(NSManagedObjectContext *)context
{
    Path *path;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Path"];
    request.predicate = [NSPredicate predicateWithFormat:@"pathID = %@", pathID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Fetch data from Path entity fail : error [Reason : %@][Description : %@]", error.localizedFailureReason, error.localizedDescription);
    } else if ([matches count]) {
        path = [matches firstObject];
    } else {
        path = [NSEntityDescription insertNewObjectForEntityForName:@"Path" inManagedObjectContext:context];
        path.pathID = pathID;
    }
    
    return path;
}

@end
