//
//  EventsFeedViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "../Models/APIEventsManager.h"
#import "../Models/EventAPI.h"

#import "../Cells/GroupEventsTableViewCell.h"
@import CoreLocation;
@interface EventsFeedViewController () <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventCategories;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *topEvents;
@property (strong, nonatomic) NSMutableArray *categories;
@end

@implementation EventsFeedViewController

CLLocationManager *locationManager;
CLLocation *currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    self.tableViewEventCategories.delegate = self;
    self.tableViewEventCategories.dataSource = self;
    self.events = [NSMutableArray new];
    self.categories = [NSMutableArray new];
    self.navigationItem.titleView = [self setTitle:@"Explore" subtitle:@"FRIDAY 6 NOVEMBER"];
    [self currentLocationIdentifier]; // call this method
//    [[APIEventsManager sharedManager] getEventsByLocation:@"" longitude:@"" completion:^(NSArray * _Nonnull eventsEventbrite, NSArray * _Nonnull eventsTicketmaster, NSError * _Nonnull error) {
//
//        //[self.tableViewEventCategories reloadData];
//
//
//    }];
    
    
   
    
   
    // Do any additional setup after loading the view.
}

-(void) fetchArrayEvents
{
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        if(error == nil)
        {
     
            int numCategories = 0;
            for(NSDictionary *category in categories)
            {
                numCategories++;
                
                NSLog(@"%@",category);
            
                if(numCategories < 6)
                {
                    [self.categories addObject:category];
                }else if(numCategories == 7)
                {
                    [self getEventsFromCategories];
                }
                
                
                
            }
        }
    }];
    
    
}
     
-(void)currentLocationIdentifier
{

    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self fetchArrayEvents];
    [locationManager startUpdatingLocation];
    

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
     }];
}

-(void) getEventsFromCategories
{
    for(NSDictionary *category in self.categories)
    {
       
        [[APIEventsManager sharedManager] getEventsByLocation:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude]  longitude:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] category:category[@"id"] shortName:category[@"short_name"] completion:^(NSArray * _Nonnull eventsEventbrite, NSArray * _Nonnull eventsTicketmaster, NSError * _Nonnull error) {
            if(error == nil)
            {
                
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                NSLog(@"%@",eventsTicketmaster);
                
            
                    NSMutableArray *arrayCategory = [NSMutableArray new];
                    for(NSDictionary * eventbriteDic in eventsEventbrite)
                    {
                        
                        NSDictionary *stringURL =   eventbriteDic[@"logo"];
                        
                        
                        @try {
                            NSString * url = stringURL[@"url"];
                            [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"] :eventbriteDic[@"summary"] :eventbriteDic[@"id"] :eventbriteDic[@"start"][@"local"] : url]];
                        } @catch (NSException *exception) {
                            [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"] :eventbriteDic[@"summary"] :eventbriteDic[@"id"] :eventbriteDic[@"start"][@"local"] : @"https://www.daviespaints.com.ph/wp-content/uploads/img/color-ideas/1008-colors/2036P.png"]];
                        } 
                        
                
                        
                        
                    }
                    for(NSDictionary * ticketmasterDic in eventsTicketmaster)
                    {
                        [arrayCategory addObject:[[EventAPI alloc] initWithInfo:ticketmasterDic[@"name"] :ticketmasterDic[@"name"] :ticketmasterDic[@"id"] :ticketmasterDic[@"dates"][@"start"][@"dateTime"] :ticketmasterDic[@"images"][0][@"url"]]];
                    }
                
                [self.events addObject:arrayCategory];
                [self.tableViewEventCategories reloadData];
            }
            }
        ];

    }
    

}



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
                y_Title = 46;
                y_Subtitle = 36;
                
                break;
            case 1334:
            case 1920:
            case 2208:
            case 2436:
                y_Title = 48;
                y_Subtitle = 38;
                break;
            default:
                y_Title = 46;
                y_Subtitle = 36;
                break;
        }
    }
    UIFont * titleFont = [UIFont systemFontOfSize:33 weight:(UIFontWeightBold)];
    UIFont * subTitleFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightSemibold)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.5, y_Title, 0, 0)];
    [titleLabel setBackgroundColor:UIColor.clearColor];
    [titleLabel setTextColor:UIColor.blackColor];
    [titleLabel setFont:titleFont];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    
    UILabel * subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.5, y_Subtitle, 0, 0)];
    [subTitleLabel setBackgroundColor:UIColor.clearColor];
    [subTitleLabel setTextColor:UIColor.blackColor];
    [subTitleLabel setFont:subTitleFont];
    [subTitleLabel setText:subtitle];
    [subTitleLabel sizeToFit];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBarWidth, navigationBarHeight)];
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
    if(indexPath.section == 0)
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
    return self.categories.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categories[section][@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull HomeFeedTableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    //[cell setMyEvent: self.events[indexPath.row]];
//
//}

     

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
