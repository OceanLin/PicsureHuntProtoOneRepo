//
//  OverlayView.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "OverlayView.h"
#import "StorageHelper.h"
#import "POI+Content.h"
#import "Path+Content.h"
#import "LocationHelper.h"
#import "InternalNotificationHelper.h"

@interface OverlayView ()
@property (nonatomic, strong) UIButton *pinButton;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) Path *currentPath;
@end

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addLabel];
        [self addBTN];
        [[NSNotificationCenter defaultCenter] addObserverForName:CancelAddPOI object:nil queue:nil usingBlock:^(NSNotification *note) {
            self.startButton.hidden = NO;
            self.stopButton.hidden = YES;
            self.pinButton.hidden = YES;
        }];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self hitButton:self.pinButton byPoint:point withEvent:event] ||
        [self hitButton:self.startButton byPoint:point withEvent:event] ||
        [self hitButton:self.stopButton byPoint:point withEvent:event]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Functions

- (BOOL)hitButton:(UIButton *)button byPoint:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint convertedPoint = [button convertPoint:point fromView:self];
    if ([button hitTest:convertedPoint withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)setCurrPath:(Path *)currPath
{
    self.currentPath = currPath;
}

#pragma mark - Buttons

#define PINBUTTON_WIDTHHEIGHT 60.0

- (void)addBTN
{
    //Add pin button
    self.pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pinButton.frame = CGRectMake((self.frame.size.width)/2 + 10, self.frame.size.height - PINBUTTON_WIDTHHEIGHT - 20, PINBUTTON_WIDTHHEIGHT, PINBUTTON_WIDTHHEIGHT);
    self.pinButton.backgroundColor = [UIColor clearColor];
    [self.pinButton setImage:[UIImage imageNamed:@"pinBTN_n"] forState:UIControlStateNormal];
    [self.pinButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.pinButton addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.pinButton addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    self.pinButton.adjustsImageWhenHighlighted = NO;
    [self insertSubview:self.pinButton aboveSubview:self];
    self.pinButton.hidden = YES;
    
    //Add start button
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.frame = CGRectMake((self.frame.size.width-PINBUTTON_WIDTHHEIGHT)/2, self.frame.size.height - PINBUTTON_WIDTHHEIGHT - 20, PINBUTTON_WIDTHHEIGHT, PINBUTTON_WIDTHHEIGHT);
    self.startButton.backgroundColor = [UIColor clearColor];
    [self.startButton setImage:[UIImage imageNamed:@"start_btn_n"] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.startButton addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    self.startButton.adjustsImageWhenHighlighted = NO;
    [self insertSubview:self.startButton aboveSubview:self];
    
    //Add stop button
    self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stopButton.frame = CGRectMake(self.frame.size.width / 2 - PINBUTTON_WIDTHHEIGHT - 10, self.frame.size.height - PINBUTTON_WIDTHHEIGHT - 20, PINBUTTON_WIDTHHEIGHT, PINBUTTON_WIDTHHEIGHT);
    self.stopButton.backgroundColor = [UIColor clearColor];
    [self.stopButton setImage:[UIImage imageNamed:@"stop_btn_n"] forState:UIControlStateNormal];
    [self.stopButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.stopButton addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    self.stopButton.adjustsImageWhenHighlighted = NO;
    [self insertSubview:self.stopButton aboveSubview:self];
    self.stopButton.hidden = YES;
}

- (void)btnPressed:(UIButton *)sender
{
//    NSLog(@"Pin Button is pressed!!");
    if (sender == self.pinButton) {
        [self.pinButton setImage:[UIImage imageNamed:@"pinBTN_p"] forState:UIControlStateNormal];
    } else if (sender == self.startButton) {
        [self.startButton setImage:[UIImage imageNamed:@"start_btn_p"] forState:UIControlStateNormal];
    } else if (sender == self.stopButton) {
        [self.stopButton setImage:[UIImage imageNamed:@"stop_btn_p"] forState:UIControlStateNormal];
    }
    
}

- (void)btnReleased:(UIButton *)sender
{
//    NSLog(@"Pin Button is released!!");
    if (sender == self.pinButton) {
        [self.pinButton setImage:[UIImage imageNamed:@"pinBTN_n"] forState:UIControlStateNormal];
        
        //Prepare the data to trigger add POI view controller
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            CLLocation *location = [LocationHelper sharedInstance].latestLocation;;
            if (location) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AddingPOI object:self userInfo:@{NewPOIDate : [NSDate date], NewPOILocation : location, CurrPathID : self.currentPath.pathID}];
            } else {
                self.locationInfo.text = @"Retrieve location informatil fail.";
                NSLog(@"Retrieve location informatil fail.");
            }
        } else {
            self.locationInfo.text = @"Can not use CLLocationManager.";
            NSLog(@"Can not use CLLocationManager.");
        }

        
//        //Add POI information into database
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
//            NSManagedObjectContext *context = [StorageHelper sharedInstance].context;
//            if (context) {
//                [context performBlock:^{
//                    CLLocation *location = [LocationHelper sharedInstance].latestLocation;
//                    if (location) {
//                        NSDictionary *pinContent;
//                        NSDate *date = [NSDate date];
//                        pinContent = @{@"id" : [[NSUUID UUID] UUIDString], @"title": [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle], @"description": [NSString stringWithFormat:@"(%f, %f)", location.coordinate.latitude, location.coordinate.longitude], @"category": @"fun", @"location": location, @"lock" : @YES, @"date" : date};
//                        [POI poiWithDetailInfo:pinContent withPathID:self.currentPath.pathID inManagedContext:context];
//                        
//                        NSError *saveError;
//                        [context save:&saveError];
//                        if (saveError) {
//                            NSLog(@"Save context fail : error [Reason : %@] [Description : %@]", saveError.localizedFailureReason, saveError.localizedDescription);
//                        } else {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:POIUpdateNotification object:self userInfo:@{NewPOI: pinContent}];
//                        }
//                    } else {
//                        self.locationInfo.text = @"Retrieve location informatil fail.";
//                        NSLog(@"Retrieve location informatil fail.");
//                    }
//                }];
//                
//            } else {
//                NSLog(@"Context is not ready for adding new POI.");
//            }
//        } else {
//            self.locationInfo.text = @"Can not use CLLocationManager.";
//            NSLog(@"Can not use CLLocationManager.");
//        }
    } else if (sender == self.startButton) {
        [self.startButton setImage:[UIImage imageNamed:@"start_btn_n"] forState:UIControlStateNormal];
        
        //Prepare the data to trigger add POI view controller
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            CLLocation *location = [LocationHelper sharedInstance].latestLocation;;
            if (location) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AddingPOI object:self userInfo:@{NewPOIDate : [NSDate date], NewPOILocation : location, CurrPathID : @""}];
                self.startButton.hidden = YES;
                self.stopButton.hidden = NO;
                self.pinButton.hidden = NO;
            } else {
                self.locationInfo.text = @"Retrieve location informatil fail.";
                NSLog(@"Retrieve location informatil fail.");
            }
        } else {
            self.locationInfo.text = @"Can not use CLLocationManager.";
            NSLog(@"Can not use CLLocationManager.");
        }
        
//        //Add POI information into database
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
//            NSManagedObjectContext *context = [StorageHelper sharedInstance].context;
//            if (context) {
//                [context performBlock:^{
//                    //Setup new path
//                    Path *newPath = [Path pathWithID:[[NSUUID UUID] UUIDString] inManagedObjectContext:context];
//                    NSDate *date = [NSDate date];
//                    newPath.title = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
//                    newPath.createTime = date;
//                    self.currentPath = newPath;
//                    
//                    //Setup the start location of the new path
//                    CLLocation *location = [LocationHelper sharedInstance].latestLocation;
//                    if (location) {
//                        NSDictionary *pinContent;
//                        pinContent = @{@"id" : [[NSUUID UUID] UUIDString], @"title": [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle], @"description": [NSString stringWithFormat:@"(%f, %f)", location.coordinate.latitude, location.coordinate.longitude], @"category": @"fun", @"location": location, @"lock" : @YES, @"date" : date};
//                        [POI poiWithDetailInfo:pinContent withPathID:self.currentPath.pathID inManagedContext:context];
//                        
//                        NSError *saveError;
//                        [context save:&saveError];
//                        if (saveError) {
//                            NSLog(@"Save context fail : error [Reason : %@] [Description : %@]", saveError.localizedFailureReason, saveError.localizedDescription);
//                        } else {
//                            //Success to save the data.
//                            self.startButton.hidden = YES;
//                            self.stopButton.hidden = NO;
//                            self.pinButton.hidden = NO;
//                            [[NSNotificationCenter defaultCenter] postNotificationName:POIUpdateNotification object:self userInfo:@{NewPOI: pinContent}];
//                        }
//                    } else {
//                        self.locationInfo.text = @"Retrieve location informatil fail.";
//                        NSLog(@"Retrieve location informatil fail.");
//                    }
//                }];
//            } else {
//                NSLog(@"Context is not ready for adding new Path.");
//            }
//        } else {
//            self.locationInfo.text = @"Can not use CLLocationManager.";
//            NSLog(@"Can not use CLLocationManager.");
//        }
    } else if (sender == self.stopButton) {
        self.startButton.hidden = NO;
        self.stopButton.hidden = YES;
        self.pinButton.hidden = YES;
//        [[LocationHelper sharedInstance].locationManager stopUpdatingLocation];
//        self.locationInfo.backgroundColor = [UIColor colorWithRed:0.95 green:0.41 blue:0.31 alpha:0.8];
        self.currentPath = nil;
    }
}

- (void)btnCancelled:(UIButton *)sender
{
//    NSLog(@"Pin Button is cancelled!!");
    if (sender == self.pinButton) {
        [self.pinButton setImage:[UIImage imageNamed:@"pinBTN_n"] forState:UIControlStateNormal];
    } else if (sender == self.startButton) {
        [self.startButton setImage:[UIImage imageNamed:@"start_btn_n"] forState:UIControlStateNormal];
    } else if (sender == self.stopButton) {
        [self.stopButton setImage:[UIImage imageNamed:@"stop_btn_n"] forState:UIControlStateNormal];
    }
}

#pragma mark - Labels

- (void)addLabel
{
    self.locationInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    self.locationInfo.textAlignment = NSTextAlignmentCenter;
    self.locationInfo.backgroundColor = [UIColor colorWithRed:0.95 green:0.41 blue:0.31 alpha:0.8];
    [self insertSubview:self.locationInfo aboveSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
