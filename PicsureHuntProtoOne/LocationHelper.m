//
//  LocationHelper.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/14.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "LocationHelper.h"
#import "InternalNotificationHelper.h"

@interface LocationHelper () <CLLocationManagerDelegate>

@end

@implementation LocationHelper

static LocationHelper *instance;

+ (LocationHelper *)sharedInstance
{
    static dispatch_once_t locationOnceToken;
    dispatch_once(&locationOnceToken, ^{
        instance = [[LocationHelper alloc] init];
    });
    
    return instance;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

#pragma mark - CClocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.latestLocation = [locations lastObject];
    NSDictionary *userinfo = @{CurrentLocation : self.latestLocation};
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:self userInfo:userinfo];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    switch (error.code) {
        case kCLErrorLocationUnknown:
            NSLog(@"Location Manager Helper got error : kCLErrorLocationUnknown");
            break;
        case kCLErrorHeadingFailure:
            NSLog(@"Location Manager Helper got error : kCLErrorHeadingFailure");
            break;
        default:
            NSLog(@"Location Manager Helper got error : Unknown");
            break;
    }
}

//- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
//{
//    
//}
//
//- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
//{
//    
//}
//
//- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
//{
//    
//}

@end
