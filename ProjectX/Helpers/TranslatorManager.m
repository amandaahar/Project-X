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


#pragma mark - Singleton Methods
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

/**
 Translate Tezt In Language
 This methos receives a source Language, a target language and a text to be translated and its going to return a completion block with the text translated in the requested language.
 
 Parameters:
 -sourceLangauge:
 -tagetLanguage:
 -text
 
 Returns:
 Completion Block with the text translated or a NSError.
 */

- (void) translateTextInLanguage:(NSString *) sourceLanguage
                                :(NSString *) targetLanguage
                                :(NSString *) text
completion :(void(^)(NSString *translated, NSError *error)) completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
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


/**
 DetectLanguage
 This method is going to detect the language of a text.
 
 Parameters:
 -Text
 
 Return:
 -Completion block with a NSDictionary with the result or a NSError.
 
 */
- (void) detectLanguage:(NSString *) text completion
                                :(void(^)(NSString *language, NSError *error))completion
{
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
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


/**
 getLanguages
 This methos looks for the available languages in the API, the result is going to be in the preovious language.
 
 Parameters:
 -previousLanguage:
 
 Return:
 Completion block with a NSArray with all the available languages or a NSError
 
 */
- (void) getLanguages:(NSString * ) previousLanguage completion
                     :(void(^)(NSArray *language, NSError *error))completion
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
             NSLog(@"Failure: %@", error);
             completion(nil, error);
         }];
}
@end
