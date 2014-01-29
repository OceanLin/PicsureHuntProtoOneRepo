//
//  MyRecordCDTVC.m
//  PicsureHuntProtoOne
//
//  Created by Lin Ocean on 2014/1/14.
//  Copyright (c) 2014年 Lin Ocean. All rights reserved.
//

#import "MyRecordCDTVC.h"
#import "InternalNotificationHelper.h"
#import "CoreLocation/CoreLocation.h"
#import "LocationHelper.h"
#import "OverlayView.h"
#import "StorageHelper.h"
#import "POI.h"
#import "Path+Content.h"
#import "RecordMapVC.h"
#import "AddPOIVC.h"

@interface MyRecordCDTVC () <UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) OverlayView *overlayView;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation MyRecordCDTVC

#pragma mark - Initialization

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ContextReadyNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.context = note.userInfo[POIManagedObjectContext];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.debug = YES;
    
    self.overlayView = [[OverlayView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.view.bounds.size.width,
                                                                     self.view.bounds.size.height)];
    [self.navigationController.view addSubview:self.overlayView];
    
    [[LocationHelper sharedInstance].locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        CLLocation *location = note.userInfo[CurrentLocation];
        NSString *locationInfo = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
        self.overlayView.locationInfo.backgroundColor = [UIColor colorWithRed:0.67 green:0.95 blue:0.49 alpha:0.8];
        self.overlayView.locationInfo.text = locationInfo;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:POIUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        POI *newPOI = note.userInfo[NewPOI];
        [self.overlayView setCurrPath:newPOI.whichPath];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AddingPOI object:nil queue:nil usingBlock:^(NSNotification *note) {
        CLLocation *location = note.userInfo[NewPOILocation];
        NSDate *date = note.userInfo[NewPOIDate];
        NSString *pathID = note.userInfo[CurrPathID];
        [self startAddPOIwithLocation:location withDate:date withPathID:pathID];
    }];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"whichPath.title" cacheName:nil];
}

#pragma mark - Exception handler

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"POI Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Configure the cell...
    POI *poi = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = poi.title;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    imageVIew.image = [UIImage imageNamed:@"map_btn"];
    cell.accessoryView  = imageVIew;
    //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_btn"]];
    cell.detailTextLabel.text = poi.subtitle;
    if (poi.pinImage) {
        cell.imageView.image = [UIImage imageWithData:poi.pinImage];
    }

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        POI *selectedPOI = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        RecordMapVC *mapVC = (RecordMapVC *)segue.destinationViewController;
        mapVC.selectedPOI = selectedPOI;
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        RecordMapVC *mapVC = (RecordMapVC *)segue.destinationViewController;
        mapVC.context = self.context;
    }
}

- (IBAction)AddedPOI:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[AddPOIVC class]]) {
        //Unwind segue from AddPOIVC
        AddPOIVC *poiVC = unwindSegue.sourceViewController;
    }
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The cell Section: %d, Row: %d accessary button is clicked.", indexPath.section, indexPath.row);
}

#pragma mark - Functions

- (void)startAddPOIwithLocation:(CLLocation *)location withDate:(NSDate *)date withPathID:(NSString *)pathID
{
    UIStoryboard *addPOIStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    AddPOIVC *poiVC = [addPOIStoryboard instantiateViewControllerWithIdentifier:@"AddPOIVCStoryboard"];
    poiVC.transitioningDelegate = self;
    poiVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [poiVC preSetDataWithLocation:location withDate:date withPathID:pathID];
    [self presentViewController:poiVC animated:YES completion:nil];
}

@end
