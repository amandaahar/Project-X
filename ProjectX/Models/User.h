//
//  User.h
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@import GeoFire;
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN
@interface User : NSObject

#pragma mark - User Attributes
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) GeoFire *location;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSArray *preferences;

#pragma mark - User Initializer
-(instancetype) initWithDictionary : (NSDictionary *) dictionary;
-(void) getImageFromString : (NSString *) stringURL;
@end

NS_ASSUME_NONNULL_END
