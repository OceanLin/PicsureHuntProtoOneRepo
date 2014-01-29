//
//  RecordMapVC.h
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/18.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "POI+Annotation.h"

@interface RecordMapVC : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) POI *selectedPOI;

@end
