//
//  EventsFeedViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "../Models/APIEventsManager.h"
#import "../Models/NSMutableArray+Convenience.h"
#import "../Cells/GroupEventsTableViewCell.h"
#import "DetailHomeViewController.h"
@import CoreLocation;
@interface EventsFeedViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventCategories;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *topEvents;
@property (strong, nonatomic) NSArray *categories;
@property (assign, nonatomic) CGFloat currentOffset;
@property (nonatomic, strong) EventAPI *eventSelected;
@end

@implementation EventsFeedViewController

CLLocationManager *locationManager;
CLLocation *currentLocation;
NSDateFormatter *dateFormat;

- (void)viewDidAppear:(BOOL)animated
{
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // convert to date
    dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    self.tableViewEventCategories.delegate = self;
    self.tableViewEventCategories.dataSource = self;
    currentLocation = [[CLLocation alloc] initWithLatitude:36 longitude:-122];
    self.events = [NSMutableArray new];
    self.categories = [NSArray new];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-variable"
    NSString *dateString = [format stringFromDate:now];
    #pragma clang diagnostic pop
    [self currentLocationIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailView:) name:@"selectedEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"newEvent" object:nil];
}

- (void)showDetailView:(NSNotification *) notification
{
    self.eventSelected = notification.object;
    [self performSegueWithIdentifier:@"details" sender:self];
    NSLog(@"Notification");
}

- (void)showAlert:(NSNotification *) notification
{
    NSString *name = notification.object;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New event"
                                                                   message:[name stringByAppendingString: @" has been added to your calendar"]
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Location methods
     
- (void)currentLocationIdentifier
{
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self fetchArrayCategories];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *Area = [[NSString alloc]initWithString:placemark.locality];
         [self.navigationItem.rightBarButtonItem setTitle:Area];
     }];
}




#pragma mark - get Information by the API Manager

- (void)fetchArrayCategories
{
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        if(error == nil)
        {
            self.categories = categories;
            [self getEventsFromCategories];
        }
    }];
}

- (void)getEventsFromCategories
{
    for(NSDictionary * category in self.categories)
    {
   
        [[APIEventsManager sharedManager] getEventsByLocation:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude]
                                                    longitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude]
                                                     category:category[@"id"]
                                                    shortName:category[@"short_name"]
                                                   completion:^(NSArray * _Nonnull eventsEventbrite, NSArray * _Nonnull eventsTicketmaster, NSError * _Nonnull error) {
            if(error == nil)
            {
                NSMutableArray *arrayCategory = [NSMutableArray new];
               
                for(NSDictionary * ticketmasterDic in eventsTicketmaster)
                {
                    
                    NSDate *dte = [dateFormat dateFromString:ticketmasterDic[@"dates"][@"start"][@"dateTime"]];
                    
                    [arrayCategory addObject:[[EventAPI alloc] initWithInfo:ticketmasterDic[@"name"]
                                                                    summary:ticketmasterDic[@"name"]
                                                                    idEvent:ticketmasterDic[@"id"]
                                                                       date:dte
                                                                        url:ticketmasterDic[@"images"][0][@"url"]
                                                                   category:category[@"name"]
                                                                   subtitle:category[@"short_name"]
                                                                        api:@"Ticketmaster"
                                                                   location:CLLocationCoordinate2DMake([ticketmasterDic[@"_embedded"][@"venues"][0][@"location"][@"latitude"] doubleValue],[ticketmasterDic[@"_embedded"][@"venues"][0][@"location"][@"longitude"] doubleValue])]];
                    

                }
                
                    for(NSDictionary * eventbriteDic in eventsEventbrite)
                    {
                        NSDictionary *stringURL =   eventbriteDic[@"logo"];
                        NSDate *dte = [dateFormat dateFromString:eventbriteDic[@"start"][@"local"]];
//                        @try {
                        
                        NSString * url = stringURL[@"url"];
                        if (!url) {
                            url = @"https://www.daviespaints.com.ph/wp-content/uploads/img/color-ideas/1008-colors/2036P.png";
                        }
                        [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
                                                                        summary:eventbriteDic[@"summary"]
                                                                        idEvent:eventbriteDic[@"id"]
                                                                           date:dte
                                                                            url:url
                                                                       category:category[@"name"]
                                                                       subtitle:category[@"short_name"]
                                                                            api:@"Eventbrite"
                                                                       location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];
//
//                        } @catch (NSException *exception) {
//                            [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
//                                                                            summary:eventbriteDic[@"summary"]
//                                                                            idEvent:eventbriteDic[@"id"]
//                                                                               date:eventbriteDic[@"start"][@"local"]
//                                                                                url:@"https://www.daviespaints.com.ph/wp-content/uploads/img/color-ideas/1008-colors/2036P.png"
//                                                                           category:category[@"name"]
//                                                                           subtitle:category[@"short_name"]
//                                                                                api:@"Eventbrite"
//                                                                           location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];
//                        }
                    }
                [self.events addObject:arrayCategory];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableViewEventCategories reloadData];
                });
            }
            }
        ];
        
        }
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.activityView setHidden:YES];
            [self.activityView stopAnimating];
        });
}

#pragma mark - Design Methods
/**
    setTitle
    This method is going to set a title and subtitle like in the App store.We are using it in the header section of the table view.

 -Parameters:
 -title: Title that we want to display
 -Subtile: Subtitle that we want to display
 
 -Return:
    A UIVIew that can be set in the eader of each section of the table view.
 */
-(UIView *) setTitle: (NSString *) title subtitle:(NSString *) subtitle
{
    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    int navigationBarWidth = self.navigationController.navigationBar.frame.size.width;
    
    double y_Title = 0.0;
    double y_Subtitle = 0.0;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        switch ((int)UIScreen.mainScreen.nativeBounds.size.height) {
            case 1136:
                y_Title = 22;
                y_Subtitle = 12;
                break;
            case 1334:
            case 1920:
            case 2208:
            case 2436:
                y_Title = 24;
                y_Subtitle = 14;
                break;
            default:
                y_Title = 22;
                y_Subtitle = 12;
                break;
        }
    }
    UIFont * titleFont = [UIFont systemFontOfSize:25 weight:(UIFontWeightBold)];
    UIFont * subTitleFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightSemibold)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y_Title, 0, 0)];
    [titleLabel setBackgroundColor:UIColor.clearColor];
    [titleLabel setTextColor:UIColor.blackColor];
    [titleLabel setFont:titleFont];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    
    UILabel * subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y_Subtitle, 0, 0)];
    [subTitleLabel setBackgroundColor:UIColor.clearColor];
    [subTitleLabel setTextColor:UIColor.blackColor];
    [subTitleLabel setFont:subTitleFont];
    [subTitleLabel setText:subtitle];
    [subTitleLabel sizeToFit];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBarWidth, navigationBarHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    [titleView addSubview:subTitleLabel];
    return titleView;
    
}



#pragma mark - Protocol functions

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"cellGrouped";
   
    GroupEventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GroupEventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellGrouped"];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    // Why?? What is happening with fullview?
    if(indexPath.section % 2 == 0)
    {
        cell.fullView = YES;
    }else{
        cell.fullView = NO;
    }
    cell.groupedEvents = self.events[indexPath.section];
    [cell.collectionViewGroupsEvents reloadData];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.events.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.events[section][@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EventAPI * event = self.events[section][0];
    return  [self setTitle:event.category subtitle:event.subtitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

     


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"details"])
    {
        DetailHomeViewController * detailView = [segue destinationViewController];
        [detailView setEvent:self.eventSelected];
    }
}





@end
