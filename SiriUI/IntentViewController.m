//
//  IntentViewController.m
//  SiriUI
//
//  Created by alexhl09 on 8/5/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "IntentViewController.h"
#import "EventsAroundIntent.h"
#import "../ProjectX/Helpers/Reachability.h"
#import "../ProjectX/Models/EventAPI.h"
#import "../ProjectX/Cells/HomeFeedTableViewCell.h"
@import AFNetworking;
// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

@interface IntentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *events;
@end

static NSString * const baseURLString = @"https://www.eventbriteapi.com/v3/";
static NSString * const publicToken = @"T4HEDOIZWIOORGLUB4U6";

@implementation IntentViewController
NSDateFormatter *dateFormat;
NSDateFormatter *dateFormat2;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.events = [NSMutableArray new];
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MM/dd/YY"];
    [self getEventsByLocation:@"San Francisco"];
    // Do any additiona;l setup after loading the view.
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureViewForParameters:(NSSet <INParameter *> *)parameters ofInteraction:(INInteraction *)interaction interactiveBehavior:(INUIInteractiveBehavior)interactiveBehavior context:(INUIHostedViewContext)context completion:(void (^)(BOOL success, NSSet <INParameter *> *configuredParameters, CGSize desiredSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    
    if (completion) {
        completion(YES, parameters, [self desiredSize]);
    }
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

-(BOOL)isConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
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
    [cell.addCalendarButton setTintColor:[UIColor blackColor]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
