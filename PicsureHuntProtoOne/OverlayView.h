//
//  OverlayView.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/17.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h"

@interface OverlayView : UIView
@property (nonatomic, strong) UILabel *locationInfo;
- (void)setCurrPath:(Path *)currPath;
@end
