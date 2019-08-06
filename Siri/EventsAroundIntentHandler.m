//
//  EventsAroundIntentHandler.m
//  Siri
//
//  Created by alexhl09 on 8/5/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventsAroundIntentHandler.h"
#import "EventsAroundIntent.h"
#import "../ProjectX/Models/EventAPI.h"
#import "../ProjectX/Helpers/Reachability.h"
@import AFNetworking;

static NSString * const baseURLString = @"https://www.eventbriteapi.com/v3/";
static NSString * const publicToken = @"T4HEDOIZWIOORGLUB4U6";
@implementation EventsAroundIntentHandler
NSDateFormatter *dateFormat;
-(void) confirmEventsAround:(EventsAroundIntent *)intent completion:(void (^)(EventsAroundIntentResponse * _Nonnull))completion
{
    if([self isConnectionAvailable]){
        EventsAroundIntentResponse *ready = [[EventsAroundIntentResponse alloc] initWithCode:(EventsAroundIntentResponseCodeReady) userActivity:nil];
        completion(ready);
    }else{
        EventsAroundIntentResponse *fail = [[EventsAroundIntentResponse alloc] initWithCode:(EventsAroundIntentResponseCodeFailure) userActivity:nil];
        
        completion(fail);
    }
}
-(void) handleEventsAround:(EventsAroundIntent *)intent completion:(void (^)(EventsAroundIntentResponse * _Nonnull))completion{
       if([self isConnectionAvailable]){
           EventsAroundIntentResponse *success = [[EventsAroundIntentResponse alloc] initWithCode:(EventsAroundIntentResponseCodeSuccess) userActivity:nil];
           completion(success);
       }else{
           EventsAroundIntentResponse *fail = [[EventsAroundIntentResponse alloc] initWithCode:(EventsAroundIntentResponseCodeFailure) userActivity:nil];

           completion(fail);
       }
}-(BOOL)isConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}
-(void) getEventsByLocation: (NSString *) location{
    self.events = [NSMutableArray new];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"events/search/"
      parameters:@{@"location.address" : @"San Francisco", @"location.within" : @"50km"}
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
             
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Failure: %@", error);
         }];
}

@end
