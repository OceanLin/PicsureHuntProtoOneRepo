//
//  LocationHelper.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/14.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface LocationHelper : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *latestLocation;
+ (LocationHelper *)sharedInstance;

@end
