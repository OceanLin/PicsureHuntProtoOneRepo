//
//  POI+Annotation.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/20.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "POI+Annotation.h"
#import "CoreLocation/CoreLocation.h"

@implementation POI (Annotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = ((CLLocation *)self.pinLocation).coordinate.latitude;
    coordinate.longitude = ((CLLocation *)self.pinLocation).coordinate.longitude;
    
    return coordinate;
}

@end
