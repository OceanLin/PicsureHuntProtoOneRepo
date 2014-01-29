//
//  POI+Content.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "POI.h"

@interface POI (Content)

+ (POI *)poiWithDetailInfo:(NSDictionary *)detailDictionary withPathName:(NSString *)pathName inManagedContext:(NSManagedObjectContext *)context;

+ (POI *)poiWithDetailInfo:(NSDictionary *)detailDictionary withPathID:(NSString *)pathID inManagedContext:(NSManagedObjectContext *)context;

@end
