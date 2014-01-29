//
//  Path.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/23.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface Path : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * pathID;
@property (nonatomic, retain) NSSet *poi;
@end

@interface Path (CoreDataGeneratedAccessors)

- (void)addPoiObject:(POI *)value;
- (void)removePoiObject:(POI *)value;
- (void)addPoi:(NSSet *)values;
- (void)removePoi:(NSSet *)values;

@end
