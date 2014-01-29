//
//  Region+Content.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "Region+Content.h"

@implementation Region (Content)

+ (Region *)regionWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Fetch data from Region entity fail : error [Reason : %@][Description : %@]", error.localizedFailureReason, error.localizedDescription);
    } else if ([matches count]) {
        region = [matches firstObject];
    } else {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.name = name;
    }
    
    return region;
}

@end
