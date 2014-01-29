//
//  PhotoViewerVC.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/27.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "PhotoViewerVC.h"

@interface PhotoViewerVC ()
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setPoi:(POI *)poi
{
    _poi = poi;
    self.photoTitle.text = poi.title;
    self.photoDescription.text = poi.subtitle;
    self.imageView.image = [UIImage imageWithData:poi.pinImage];
}

@end
