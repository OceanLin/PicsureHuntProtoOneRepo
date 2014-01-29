//
//  POI.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/23.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Path;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSString * pinCategory;
@property (nonatomic, retain) NSString * pinID;
@property (nonatomic, retain) NSData * pinImage;
@property (nonatomic, retain) id pinLocation;
@property (nonatomic, retain) NSNumber * pinLock;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) Path *whichPath;

@end
