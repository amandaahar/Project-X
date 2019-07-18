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
- (void) getCategories:(void(^)(NSArray *categories, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"categories/"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             NSLog(@"Success: %@", responseObject);
             completion(responseObject[@"categories"],nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}

- (void) getEventByCategory: (NSString *) categoryID completion:(void(^)(NSArray *events, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"events/search/"
      parameters:@{@"high_affinity_categories" : categoryID, @"location.address" : @"london", @"location.within" : @"10km"}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             NSLog(@"Success: %@", responseObject);

             completion(responseObject[@"events"],nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}

-(void) getEventsByLocation : (NSString *) latitude  longitude:(NSString *) longitude  completion:(void(^)(NSArray *categories, NSError *error))completion{
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager POST:@"events/search"
       parameters:@{@"location.longitude":@"-123.11236500000001",@"location.latitude":@"49.279974"}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             NSLog(@"Success: %@", responseObject);
             completion(responseObject[@"categories"],nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}


@end
