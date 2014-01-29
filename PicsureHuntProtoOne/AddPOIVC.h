//
//  AddPOIVC.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/24.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "CoreLocation/CoreLocation.h"

@interface AddPOIVC : UIViewController

@property (strong, nonatomic) POI *newPOI;
- (void)preSetDataWithLocation:(CLLocation *)location withDate:(NSDate *)date withPathID:(NSString *)pathID;

@end
