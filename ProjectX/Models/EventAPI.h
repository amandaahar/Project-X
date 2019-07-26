//
//  EventAPI.h
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
NS_ASSUME_NONNULL_BEGIN

@interface EventAPI : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *idEvent;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *api;
@property (assign, nonatomic) CLLocationCoordinate2D location;


-(instancetype) initWithInfo : (NSString *) name  : (NSString *) summary : (NSString *) idEvent : (NSDate *) date : (NSString *) url : (NSString *) category : (NSString *) subtitle : (NSString *) api : (CLLocationCoordinate2D) location;
@end

NS_ASSUME_NONNULL_END
