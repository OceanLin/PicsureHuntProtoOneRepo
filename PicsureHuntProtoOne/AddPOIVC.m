//
//  AddPOIVC.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/24.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "AddPOIVC.h"
#import "StorageHelper.h"
#import "Path+Content.h"
#import "POI+Content.h"
#import "InternalNotificationHelper.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface AddPOIVC () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *okBTN;
@property (weak, nonatomic) IBOutlet UIButton *cancelBTN;
@property (weak, nonatomic) IBOutlet UIButton *cameraBTN;
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *descriptionInput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CLLocation *currLocation;
@property (strong, nonatomic) NSDate *currDate;
@property (strong, nonatomic) NSString *currPathID;

@end

@implementation AddPOIVC

#pragma mark - Initializatoin

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.titleInput.delegate = self;
    self.descriptionInput.delegate = self;
    
    if (self.currDate) {
        self.titleInput.text = [NSDateFormatter localizedStringFromDate:self.currDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    }
    
    if (self.currLocation) {
        self.descriptionInput.text = [NSString stringWithFormat:@"(%f, %f)", self.currLocation.coordinate.latitude, self.currLocation.coordinate.longitude];
    }
    
    [self setupButtons];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (POI *)newPOI
{
    if (!_newPOI) {
        _newPOI = [[POI alloc] init];
    }
    
    return _newPOI;
}

#pragma mark - Delegate handler

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)btnPressed:(UIButton *)sender
{
    if (sender == self.okBTN) {
        [self.okBTN setImage:[UIImage imageNamed:@"ok_btn_p"] forState:UIControlStateNormal];
    } else if (sender == self.cancelBTN) {
        [self.cancelBTN setImage:[UIImage imageNamed:@"cancel_btn_p"] forState:UIControlStateNormal];
    } else if (sender == self.cameraBTN) {
        [self.cameraBTN setImage:[UIImage imageNamed:@"camera_btn_p"] forState:UIControlStateNormal];
    }
}

- (void)btnReleased:(UIButton *)sender
{
    if (sender == self.okBTN) {
        [self.okBTN setImage:[UIImage imageNamed:@"ok_btn_n"] forState:UIControlStateNormal];
        //Add POI information into database
        NSManagedObjectContext *context = [StorageHelper sharedInstance].context;
        if (context) {
            [context performBlock:^{
                Path *newPath = nil;
                if ([self.currPathID length] == 0) {
                    //Setup new path
                    newPath = [Path pathWithID:[[NSUUID UUID] UUIDString] inManagedObjectContext:context];
                    NSDate *date = [NSDate date];
                    newPath.title = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
                    newPath.createTime = date;
                }
                
                NSDictionary *pinContent;
                if (self.image) {
                    pinContent = @{@"id" : [[NSUUID UUID] UUIDString], @"title": [NSDateFormatter localizedStringFromDate:self.currDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle], @"description": [NSString stringWithFormat:@"(%f, %f)", self.currLocation.coordinate.latitude, self.currLocation.coordinate.longitude], @"category": @"fun", @"location": self.currLocation, @"lock" : @YES, @"date" : self.currDate, @"image" : UIImagePNGRepresentation(self.image)};
                } else {
                    pinContent = @{@"id" : [[NSUUID UUID] UUIDString], @"title": [NSDateFormatter localizedStringFromDate:self.currDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle], @"description": [NSString stringWithFormat:@"(%f, %f)", self.currLocation.coordinate.latitude, self.currLocation.coordinate.longitude], @"category": @"fun", @"location": self.currLocation, @"lock" : @YES, @"date" : self.currDate};
                }
                
                if (newPath) {
                    self.newPOI = [POI poiWithDetailInfo:pinContent withPathID:newPath.pathID inManagedContext:context];
                } else {
                    self.newPOI = [POI poiWithDetailInfo:pinContent withPathID:self.currPathID inManagedContext:context];
                }
                
                NSError *saveError;
                [context save:&saveError];
                if (saveError) {
                    NSLog(@"Save context fail : error [Reason : %@] [Description : %@]", saveError.localizedFailureReason, saveError.localizedDescription);
                } else {
                    //Success to save the data.
                    [[NSNotificationCenter defaultCenter] postNotificationName:POIUpdateNotification object:self userInfo:@{NewPOI: self.newPOI}];
                }
            }];
        } else {
            NSLog(@"Context is not ready for adding new Path.");
        }
    } else if (sender == self.cancelBTN) {
        [self.cancelBTN setImage:[UIImage imageNamed:@"cancel_btn_n"] forState:UIControlStateNormal];
        if ([self.currPathID length] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CancelAddPOI object:self];
        }
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (sender == self.cameraBTN) {
        [self.cameraBTN setImage:[UIImage imageNamed:@"camera_btn_n"] forState:UIControlStateNormal];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (void)btnCancelled:(UIButton *)sender
{
    if (sender == self.okBTN) {
        [self.okBTN setImage:[UIImage imageNamed:@"ok_btn_n"] forState:UIControlStateNormal];
    } else if (sender == self.cancelBTN) {
        [self.cancelBTN setImage:[UIImage imageNamed:@"cancel_btn_n"] forState:UIControlStateNormal];
    } else if (sender == self.cameraBTN) {
        [self.cameraBTN setImage:[UIImage imageNamed:@"camera_btn_n"] forState:UIControlStateNormal];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    self.cameraBTN.hidden = YES;
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Functions

- (void)preSetDataWithLocation:(CLLocation *)location withDate:(NSDate *)date withPathID:(NSString *)pathID
{
    self.currLocation = location;
    self.currDate = date;
    self.currPathID = pathID;
}

- (void)setupButtons
{
    [self.okBTN addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.okBTN addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.okBTN addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    
    [self.cancelBTN addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.cancelBTN addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBTN addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    
    [self.cameraBTN addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.cameraBTN addTarget:self action:@selector(btnReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraBTN addTarget:self action:@selector(btnCancelled:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
}

@end
