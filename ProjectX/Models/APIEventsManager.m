//
//  APIEventsManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "APIEventsManager.h"
#import "Event.h"
@import AFNetworking;
@import CoreLocation;

static NSString * const baseURLString = @"https://www.eventbriteapi.com/v3/";
static NSString * const publicToken = @"T4HEDOIZWIOORGLUB4U6";
static NSString * const clientSecret = @"XFZKXUDPWBPQANV7EWD237QVMMH35G4H47CHB3HE7CSJQA2PIT";
static NSString * const baseURLStringTicketMaster = @"https://app.ticketmaster.com/";
static NSString * const publicTokenTicketMaster = @"OgabuZXqzqkv0GJtbvl5hKlbAFZLxncm";

@implementation APIEventsManager
#pragma mark Singleton Methods
+ (id)sharedManager {
    static APIEventsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
       
    }
    return self;
}

- (void)dealloc {
    
}


#pragma mark Get methods

/**
 Gets the categories available by the API
 

 @note This is going to return in a completion block if there was an error or a NSArray with all the dictionaries with the categories
 */
- (void) getCategories:(void(^)(NSArray *categories, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"categories/"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             completion(responseObject[@"categories"],nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}


/**
 This method gets the events depending on the category passed as paremter
 
 @param categoryID  This is the categoryID that the method is going to use in the POST request in the API
 @note This is going to return in a completion block if there was an error or a NSArray with all the events of that category

 
 */
- (void) getEventByCategory: (NSString *) categoryID completion:(void(^)(NSArray *events, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"events/search/"
      parameters:@{@"location.address" : @"london", @"location.within" : @"10km"}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {

             completion(responseObject[@"events"],nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}


/**
 This method going to get the events depending on the location of the user and on the category and keyword of the event
 
 @param latitude    This is the latitude of the current user
 @param longitude   This is the longitude of the current user
 @param category    This is the category chosen by the user
 @param shortname   This is a keyword used to look for relationated events
 @note This is going to return in a completion block if there was an error or a NSArray with all the events of that category
 
 
 */
-(void) getEventsByLocation : (NSString *) latitude
                    longitude:(NSString *) longitude
                    category:(NSString *) category
                    shortName : (NSString *) shortname
                    completion:(void(^)(NSArray *eventsEventbrite,NSArray * eventsTicketmaster, NSError *error))completion{
    
    
    __block NSDictionary *eventbriteDic;
    __block NSDictionary *ticketmasterDic;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        // block1
      
        AFHTTPSessionManager *manager =
        [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
        [manager GET:@"events/search/"
          parameters:@{@"location.longitude" : longitude,@"location.latitude":latitude, @"high_affinity_categories": category, @"expand" : @"venue"}
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable dictionaryEventbrite) {
                 eventbriteDic = dictionaryEventbrite;
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"Failure: %@", error);
                 completion(nil,nil,nil);
             }];
        NSLog(@"Block1");
        [NSThread sleepForTimeInterval:5.0];
        NSLog(@"Block1 End");
    });
    
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        AFHTTPSessionManager *manager2 =
        [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLStringTicketMaster]];
        [manager2 GET:@"discovery/v2/events.json" parameters:@{@"apikey" : @"OgabuZXqzqkv0GJtbvl5hKlbAFZLxncm",@"geoPoint":[NSString stringWithFormat:@"%@,%@",latitude, longitude], @"radius" : @"150",@"unit" : @"km",@"keyword": shortname}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable dictionaryTicketmaster) {
                  ticketmasterDic = dictionaryTicketmaster;
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Failure: %@", error);
                 
              }];

        NSLog(@"Block2");
        [NSThread sleepForTimeInterval:8.0];
        NSLog(@"Block2 End");
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        // block3
        if (eventbriteDic && ticketmasterDic) {
            completion(eventbriteDic[@"events"],ticketmasterDic[@"_embedded"][@"events"], nil);
            NSLog(@"Block3");
        }
    });
        
    
    
}


-(void) fetchEventsByLocation : (NSString *) latitude  longitude:(NSString *) longitude  category:(NSString *) category shortName : (NSString *) shortname completion:(void(^)(NSArray *eventsEventbrite,NSArray * eventsTicketmaster, NSError *error))completion{
   
        AFHTTPSessionManager *manager =
        [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
        [manager GET:@"events/search/"
          parameters:@{@"location.longitude" : longitude,@"location.latitude":latitude, @"high_affinity_categories": category}
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable dictionaryEventbrite) {
                 AFHTTPSessionManager *manager2 =
                 [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLStringTicketMaster]];
                 [manager2 GET:@"discovery/v2/events.json" parameters:@{@"apikey" : publicTokenTicketMaster,@"geoPoint":[NSString stringWithFormat:@"%@,%@",latitude, longitude], @"radius" : @"150",@"unit" : @"km",@"keyword": shortname}
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable dictionaryTicketmaster) {
                           completion(dictionaryEventbrite[@"events"],dictionaryTicketmaster[@"_embedded"][@"events"], nil);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           NSLog(@"Failure: %@", error);
                           completion(dictionaryEventbrite[@"events"],nil, error);
                       }];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 AFHTTPSessionManager *manager2 =
                 [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLStringTicketMaster]];
                 [manager2 GET:@"discovery/v2/events.json" parameters:@{@"apikey" : publicTokenTicketMaster,@"geoPoint":[NSString stringWithFormat:@"%@,%@",latitude, longitude], @"radius" : @"150",@"unit" : @"km",@"keyword": shortname}
                      progress:nil
                       success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable dictionaryTicketmaster) {
                           completion(nil,dictionaryTicketmaster[@"_embedded"][@"events"], error);

                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           NSLog(@"Failure: %@", error);
                           completion(nil,nil, error);
                       }];
             }];
   
}





@end


