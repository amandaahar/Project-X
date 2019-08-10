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
#import "../Models/User.h"
#import "../Helpers/Reachability.h"
#import "DetailHomeViewController.h"
#import "EventsAroundIntent.h"

#import "ProjectX-Swift.h"
#import "../Helpers/AppColors.h"

#import <AVFoundation/AVAudioPlayer.h>
@import CoreLocation;
@interface EventsFeedViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventCategories;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *eventsFiltered;
@property (strong, nonatomic) NSMutableArray *topEvents;
@property (strong, nonatomic) NSArray *categories;
@property (assign, nonatomic) CGFloat currentOffset;
@property (nonatomic, strong) EventAPI *eventSelected;
@property (nonatomic, strong) User *currentUser;
@property (strong, nonatomic) UINotificationFeedbackGenerator *feedbackGenerator;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
@property (strong, nonatomic) UIView * spinnerView;
@end

@implementation EventsFeedViewController

CLLocationManager *locationManager;
NSDateFormatter *dateFormat;



- (void)viewDidLoad {
    [super viewDidLoad];
    [LoadHelper startCovering:self.view];
    // convert to date
    self.spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.spinnerView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 180);
    self.spinnerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.spinnerView.clipsToBounds = YES;
    self.spinnerView.layer.cornerRadius = 10;
    [self.tableViewEventCategories addSubview:self.spinnerView];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.spinner.center = self.spinnerView.center;
    [self.spinner setHidesWhenStopped:YES];
    [self.tableViewEventCategories addSubview:self.spinner];
    [self.spinner startAnimating];
    
    dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    self.searchBar.delegate = self;
    self.tableViewEventCategories.delegate = self;
    self.tableViewEventCategories.dataSource = self;
    self.eventsFiltered = [NSMutableArray new];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:36 longitude:-122];
    self.events = [NSMutableArray new];
    self.categories = [NSArray new];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-variable"
    NSString *dateString = [format stringFromDate:now];
    #pragma clang diagnostic pop
    
    if ([self isConnectionAvailable]) {
        
    [self currentLocationIdentifier];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Check your internet connection" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:accept];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailView:) name:@"selectedEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"newEvent" object:nil];
    
    
    [self desiredInteraction];
}

- (void)showDetailView:(NSNotification *)notification
{
    self.eventSelected = notification.object;
    [self performSegueWithIdentifier:@"details" sender:self];
    UIImpactFeedbackGenerator *myGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
    [myGen impactOccurred];
    myGen = NULL;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.gradient.frame = self.navigationController.navigationBar.bounds;

}

- (void)showAlert:(NSNotification *)notification
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
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error == nil){
            self.currentUser = user;
            [self fetchArrayCategories];
        }
    }];
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
         [self.navigationItem.rightBarButtonItem setTitle:Area];
     }];
}


/// This method shows the cancel button
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

/// This method makes the search bar first responder
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

///This method filters all the trends using my array and creating a new one that is used to populate the cells
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSMutableArray* filteredArray = [NSMutableArray new];
        
        for(NSArray * arrayEvents in self.events)
        {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(EventAPI *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject.name containsString:searchText];
            }];
            NSArray *filtered = [arrayEvents filteredArrayUsingPredicate:predicate];
            if(filtered.count > 0){
            [filteredArray addObject: filtered];
            }
        }
        self.eventsFiltered = filteredArray;
    }
    else {
        self.eventsFiltered = self.events;
    }
    
    [self.tableViewEventCategories reloadData];
    
}


#pragma mark - get Information by the API Manager

- (void)fetchArrayCategories
{
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        if(error == nil)
        {
            NSMutableArray * categoriesFiltered = [NSMutableArray new];
            if(self.currentUser.preferences != nil && self.currentUser.preferences.count >= 2){
                for(NSDictionary *dic in self.currentUser.preferences){
                    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                        return [dic[@"id"] isEqualToString: evaluatedObject[@"id"]];
                    }];
                    
                    [categoriesFiltered addObjectsFromArray:[categories filteredArrayUsingPredicate:predicate]];
                }
            } else{
                categoriesFiltered = [categories copy];
            }
          
            self.categories = categoriesFiltered;
            [self getEventsFromCategories];
        }
    }];
}

- (void)getEventsFromCategories
{
    for(int i = 0; i < self.categories.count; i++)
    {
 
        NSString *idCategoryString = [NSString stringWithFormat:@"%@",self.categories[i][@"id"] ];
        [[APIEventsManager sharedManager] getEventsByLocation:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude]
                                                    longitude:[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude]
                                                     category:idCategoryString
                                                    shortName:self.categories[i][@"short_name"]
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
                                                                   category:self.categories[i][@"short_name"]
                                                                   subtitle:self.categories[i][@"short_name"]
                                                                        api:@"Ticketmaster"
                                                                   location:CLLocationCoordinate2DMake([ticketmasterDic[@"_embedded"][@"venues"][0][@"location"][@"latitude"] doubleValue],[ticketmasterDic[@"_embedded"][@"venues"][0][@"location"][@"longitude"] doubleValue])]];
                    

                }
                
                    for(NSDictionary * eventbriteDic in eventsEventbrite)
                    {
                        NSDictionary *stringURL =   eventbriteDic[@"logo"];
                        NSDate *dte = [dateFormat dateFromString:eventbriteDic[@"start"][@"local"]];
                        @try {
                        
                        NSString * url = stringURL[@"url"];
                      
                        [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
                                                                        summary:eventbriteDic[@"summary"]
                                                                        idEvent:eventbriteDic[@"id"]
                                                                           date:dte
                                                                            url:url
                                                                       category:self.categories[i][@"short_name"]
                                                                       subtitle:self.categories[i][@"short_name"]
                                                                            api:@"Eventbrite"
                                                                       location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];

                        } @catch (NSException *exception) {
                            [arrayCategory addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"]
                                                                            summary:eventbriteDic[@"summary"]
                                                                            idEvent:eventbriteDic[@"id"]
                                                                               date:eventbriteDic[@"start"][@"local"]
                                                                                url:@"https://www.daviespaints.com.ph/wp-content/uploads/img/color-ideas/1008-colors/2036P.png"
                                                                           category:self.categories[i][@"short_name"]
                                                                           subtitle:self.categories[i][@"short_name"]
                                                                                api:@"Eventbrite"
                                                                           location:CLLocationCoordinate2DMake([eventbriteDic[@"venue"][@"latitude"] doubleValue], [eventbriteDic[@"venue"][@"longitude"] doubleValue])]];
                        }
                    }
                [self.events addObject:arrayCategory];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.eventsFiltered = self.events;
                    [self.tableViewEventCategories reloadData];
                });
            }else{
               // NSLog(@"%@", error.localizedRecoveryOptions);
            }
            }
        ];
        
        }
        double delayInSeconds = 8.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.activityView setHidden:YES];
            [self.activityView stopAnimating];
       [LoadHelper stopCovering:self.view];
            [self.spinnerView setHidden:YES];
            [self.spinner stopAnimating];
        });
}


- (BOOL)isConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}
#pragma mark - Design Methods
- (UIView *)setTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    int navigationBarHeight = 60;
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
    [titleLabel setTextColor:[[AppColors sharedManager] getBlueLabels]];
    [titleLabel setFont:titleFont];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    
    UILabel * subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y_Subtitle, 0, 0)];
    [subTitleLabel setBackgroundColor:UIColor.clearColor];
    [subTitleLabel setTextColor:[[AppColors sharedManager] getDarkBlue]];
    [subTitleLabel setFont:subTitleFont];
    [subTitleLabel setText:subtitle];
    [subTitleLabel sizeToFit];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navigationBarWidth
                                                                  , navigationBarHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.cornerRadius = 10;
    titleView.clipsToBounds = YES;
    titleView.layer.shadowRadius  = 3;
    
    titleView.layer.shadowOffset = CGSizeMake(0,0);
    titleView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    titleView.layer.shadowOpacity = 0.5;
    titleView.layer.masksToBounds = NO;
    titleView.layer.shadowPath = [UIBezierPath bezierPathWithRect:titleView.bounds].CGPath;

    
    [titleView addSubview:titleLabel];
    [titleView addSubview:subTitleLabel];
    return titleView;
    
}


- (void)desiredInteraction {
    EventsAroundIntent *intent = [EventsAroundIntent new];
    [intent setSuggestedInvocationPhrase:@"Look for events around me with Plan It"];
    INInteraction *interaction = [[INInteraction alloc] initWithIntent:intent response:nil];
    
    [interaction donateInteractionWithCompletion:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"%@",error.localizedDescription);
        }
    }];
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
    cell.groupedEvents = self.eventsFiltered[indexPath.section];
    [cell.collectionViewGroupsEvents reloadData];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.eventsFiltered.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.eventsFiltered[section][@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EventAPI * event = self.eventsFiltered[section][0];
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


- (IBAction)changeLocation:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Location" message:@"Insert the new location" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        [self getCoordinates:textField.text completionHandler:^(CLLocation *coordinates, NSError *error) {
            if(error == nil){
                 [self.navigationItem.rightBarButtonItem setTitle:textField.text];
                 [locationManager stopUpdatingLocation];
                [self.events removeAllObjects];
                self.currentLocation = coordinates;
                [self fetchArrayCategories];
            }
        }];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:accept];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Place";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



- (void)getCoordinates:(NSString *)addressString completionHandler:(void(^)(CLLocation* coordinates, NSError *error))completion
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error != nil){
            completion(nil, error);
        }
        CLPlacemark *placemark = placemarks[0];
        if(placemark == nil){
            NSError *error = [[NSError alloc] init];
            
            completion(nil,error);
        }
        CLLocation *location = placemark.location;
        completion(location, nil);
    }];
    
}


@end
