//
//  RecordMapVC.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/18.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "RecordMapVC.h"
#import "MapKit/MapKit.h"
#import "CoreData/CoreData.h"
#import "POI+Annotation.h"

@interface RecordMapVC () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *recordMapView;
@property (strong, nonatomic) NSArray *POIs;
@end

@implementation RecordMapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (NSArray *)POIsFromRegionName:(NSString *)regionName
//{
//    NSFetchRequest *request;
//    if (regionName == nil) { //means fetch all POIs
//        request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
//        request.predicate = nil;
//    } else {
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
//        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionName];
//    }
//    
//    
//}

- (void)setRecordMapView:(MKMapView *)recordMapView
{
    _recordMapView = recordMapView;
    self.recordMapView.delegate = self;
    [self updateMapViewAnnotation];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    self.POIs = nil;
    [self updateMapViewAnnotation];
}

- (void)setSelectedPOI:(POI *)selectedPOI
{
    _selectedPOI = selectedPOI;
    self.context = self.selectedPOI.managedObjectContext;
    [self updateMapViewAnnotation];
}

#pragma mark - Functions

- (void)updateMapViewAnnotation
{
    [self.recordMapView removeAnnotations:self.recordMapView.annotations];
    [self.recordMapView addAnnotations:[self allPOIs]];
    [self.recordMapView showAnnotations:[self allPOIs] animated:YES];
    if (self.selectedPOI) {
        [self.recordMapView selectAnnotation:self.selectedPOI animated:YES];
    }
}

- (NSArray *)allPOIs
{
    if (self.context && !self.POIs) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
        request.predicate = nil;
        NSError *error;
        self.POIs = [self.context executeFetchRequest:request error:&error];
        if (error || !self.POIs) {
            NSLog(@"Fetch POIs in RecordMapVC fail. Error : [Reasion - %@][Description - %@]", error.localizedFailureReason, error.localizedDescription);
        }
    }
    
    return self.POIs;
}

- (void)updateLeftCalloutAccessaryViewInAnnotationView:(MKAnnotationView *)annotationView
{
    UIImageView *imageView = nil;
    if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    }
    
    if (imageView) {
        POI *poi = nil;
        if ([annotationView.annotation isKindOfClass:[POI class]]) {
            poi = annotationView.annotation;
        }
        
        if (poi) {
            //If the image is from server side, we can download the thumbnail here.
            if (poi.pinImage) {
                imageView.image = [UIImage imageWithData:poi.pinImage];
            } else {
                imageView.image = [UIImage imageNamed:@"locationQ"];
            }
        }
    }
}

#pragma mark - Delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
    //[self performSegueWithIdentifier: sender:]
    //Then, we need to add prepareSegue for navigation.
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self updateLeftCalloutAccessaryViewInAnnotationView:view];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reusedId = @"POIPinMapVC";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reusedId];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedId];
        view.canShowCallout = YES;
        view.image = [UIImage imageNamed:@"pin"];
        
        //Insert the left callout accessory view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        view.leftCalloutAccessoryView = imageView;
        
        //Insert the right callout accessory view
        UIButton *disclosureButton = [[UIButton alloc] init];
        [disclosureButton setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [disclosureButton sizeToFit];
        view.rightCalloutAccessoryView = disclosureButton;
    }
    
    view.annotation = annotation;
    
    return view;
}

@end
