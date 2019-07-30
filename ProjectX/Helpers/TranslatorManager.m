//
//  TranslatorManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/26/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "TranslatorManager.h"
@import AFNetworking;

@implementation TranslatorManager


static NSString * const baseURLString = @"https://translation.googleapis.com/language/translate/v2";
static NSString * const publicToken = @"AIzaSyABntoESCxzEqLShs-KQV9pRwdIesmnQDI";


#pragma mark Singleton Methods
+ (id)sharedManager {
    static TranslatorManager *sharedMyManager = nil;
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

- (void) translateTextInLanguage:(NSString *) sourceLanguage : (NSString *) targetLanguage : (NSString *) text completion
                                :(void(^)(NSString *translated, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@""
      parameters:@{@"key" : publicToken, @"format" : @"text", @"source": sourceLanguage, @"target" : targetLanguage, @"q" : text}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             completion(responseObject[@"data"][@"translations"][0][@"translatedText"], nil);
 NSLog(@": %@", responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // NSLog(@"Failure: %@", error);
             NSLog(@"Failure: %@", error);
             completion(nil, error);
         }];
}

- (void) detectLanguage:(NSString *) text completion
                                :(void(^)(NSString *language, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", publicToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"detect"
      parameters:@{@"key" : publicToken, @"q" : text}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             NSDictionary * language = responseObject[@"data"][@"detections"][0][0];
             completion(language[@"language"], nil);
             //NSLog(@": %@", responseObject[@"data"][@"detections"][0][@"language"]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // NSLog(@"Failure: %@", error);
             NSLog(@"Failure: %@", error);
             completion(nil, error);
         }];
}
- (void) getLanguages:(NSString * ) previousLanguage completion:(void(^)(NSArray *language, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    [manager POST:@"languages"
      parameters:@{@"key" : publicToken, @"target" : previousLanguage}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
             completion(responseObject[@"data"][@"languages"], nil);
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // NSLog(@"Failure: %@", error);
             NSLog(@"Failure: %@", error);
             completion(nil, error);
         }];
}
@end
