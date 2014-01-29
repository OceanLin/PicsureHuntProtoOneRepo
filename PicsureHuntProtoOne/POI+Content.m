//
//  POI+Content.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "POI+Content.h"
#import "Path+Content.h"

@implementation POI (Content)

+ (POI *)poiWithDetailInfo:(NSDictionary *)detailDictionary withPathName:(NSString *)pathName inManagedContext:(NSManagedObjectContext *)context
{
    POI *poi;
    
    NSString *identifier = detailDictionary[@"pinID"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
    request.predicate = [NSPredicate predicateWithFormat:@"pinID = %@", identifier];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Fetch data from POI entity fail : error [Reason : %@][Description : %@]", error.localizedFailureReason, error.localizedDescription);
    } else if ([matches count]) {
        poi = [matches firstObject];
    } else {
        poi = [NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:context];
        poi.pinID = detailDictionary[@"id"];
        poi.title = detailDictionary[@"title"];
        poi.subtitle = detailDictionary[@"description"];
        poi.pinCategory = detailDictionary[@"category"];
        if (detailDictionary[@"image"] != nil) {
            poi.pinImage = detailDictionary[@"image"];
        }
        if (detailDictionary[@"location"] != nil) {
            poi.pinLocation = detailDictionary[@"location"];
        }
        poi.pinLock = detailDictionary[@"lock"];
        poi.createTime = detailDictionary[@"date"];
        Path *path  = [Path pathWithName:pathName inManagedObjectContext:context];
        poi.whichPath = path;
    }
    
    return poi;
}

+ (POI *)poiWithDetailInfo:(NSDictionary *)detailDictionary withPathID:(NSString *)pathID inManagedContext:(NSManagedObjectContext *)context
{
    POI *poi;
    
    NSString *identifier = detailDictionary[@"pinID"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
    request.predicate = [NSPredicate predicateWithFormat:@"pinID = %@", identifier];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Fetch data from POI entity fail : error [Reason : %@][Description : %@]", error.localizedFailureReason, error.localizedDescription);
    } else if ([matches count]) {
        poi = [matches firstObject];
    } else {
        poi = [NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:context];
        poi.pinID = detailDictionary[@"id"];
        poi.title = detailDictionary[@"title"];
        poi.subtitle = detailDictionary[@"description"];
        poi.pinCategory = detailDictionary[@"category"];
        if (detailDictionary[@"image"] != nil) {
            poi.pinImage = detailDictionary[@"image"];
        }
        if (detailDictionary[@"location"] != nil) {
            poi.pinLocation = detailDictionary[@"location"];
        }
        poi.pinLock = detailDictionary[@"lock"];
        poi.createTime = detailDictionary[@"date"];
        Path *path  = [Path pathWithID:pathID inManagedObjectContext:context];
        poi.whichPath = path;
    }
    
    return poi;
}

@end
