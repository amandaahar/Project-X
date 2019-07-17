//
//  APIEventsManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "APIEventsManager.h"
@import AFNetworking;

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
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"Success: %@", responseObject);
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}

@end
