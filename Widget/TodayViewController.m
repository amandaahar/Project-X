//
//  TodayViewController.m
//  Widget
//
//  Created by alexhl09 on 8/4/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "../ProjectX/Cells/HomeFeedTableViewCell.h"
@import Firebase;
@import AFNetworking;
@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) CLLocation *currentLocation;
@end
static NSString * const baseURLString = @"https://www.eventbriteapi.com/v3/";
static NSString * const publicToken = @"T4HEDOIZWIOORGLUB4U6";
@implementation TodayViewController
NSDateFormatter *dateFormat2;

NSDateFormatter *dateFormat;
CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.events = [NSMutableArray new];
    dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MM/dd/YY"];
    dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.currentLocation = [[CLLocation alloc] initWithLatitude:36 longitude:-122];

    [self.extensionContext setWidgetLargestAvailableDisplayMode:(NCWidgetDisplayModeExpanded)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"newEvent" object:nil];
    [self currentLocationIdentifier];
    // Do any additional setup after loading the view.
}

- (void)showAlert:(NSNotification *) notification
{
   

}


- (void)currentLocationIdentifier
{
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *Area = [[NSString alloc]initWithString:placemark.locality];
         [self getEventsByLocation:Area];
     }];
}



- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if(activeDisplayMode == NCWidgetDisplayModeCompact){
        self.preferredContentSize = CGSizeMake(0, 250);
    }else{
        self.preferredContentSize = CGSizeMake(0, 500);
    }
}

-(void) getEventsByLocation: (NSString *) location{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"events/search/"
      parameters:@{@"location.address" : location, @"location.within" : @"50km"}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             
             NSArray *eventbriteArray = responseObject[@"events"];
             for (NSDictionary * eventbriteDic in eventbriteArray){
                 NSDictionary *stringURL =   eventbriteDic[@"logo"];
                 NSDate *dte = [dateFormat dateFromString:eventbriteDic[@"start"][@"local"]];
                 @try {
                     
                     NSString * url = stringURL[@"url"];
                     
                     [self.events addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
                                                                   summary:eventbriteDic[@"summary"]
                                                                   idEvent:eventbriteDic[@"id"]
                                                                      date:dte
                                                                       url:url
                                                                  category:@""
                                                                  subtitle:@""
                                                                       api:@"Eventbrite"
                                                                  location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];
                     
                 } @catch (NSException *exception) {
                     [self.events addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
                                                                   summary:eventbriteDic[@"summary"]
                                                                   idEvent:eventbriteDic[@"id"]
                                                                      date:eventbriteDic[@"start"][@"local"]
                                                                       url:@"https://www.daviespaints.com.ph/wp-content/uploads/img/color-ideas/1008-colors/2036P.png"
                                                                  category:@""
                                                                  subtitle:@""
                                                                       api:@"Eventbrite"
                                                                  location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];
                 }
             }
             [self.tableView reloadData];
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"feedCell";
    HomeFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"HomeFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"feedCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    [cell setMyEvent:self.events[indexPath.row]];
    NSString *dateString = [dateFormat2 stringFromDate:[self.events[indexPath.row] date]];
    [cell.api setText:dateString];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

