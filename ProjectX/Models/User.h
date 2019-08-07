//
//  User.h
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chat.h"
#import <CoreLocation/CoreLocation.h>
@import FirebaseAuth;
@import UIKit;
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN
@interface User : NSObject

#pragma mark - User Attributes
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *profileImage;
@property (strong, nonatomic) NSArray *preferences;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *fcm;

#pragma mark - User Initializer
- (instancetype) initWithDictionary : (NSDictionary *) dictionary;
- (void) composeMessage:(NSString *)text chat: (NSString *)event;
- (void) joinEvent: (NSString *)eventID;

@end

NS_ASSUME_NONNULL_END
