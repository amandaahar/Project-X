//
//  EventAPI.h
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventAPI : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *idEvent;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSURL *logo;

-(instancetype) initWithInfo : (NSString *) name  : (NSString *) summary : (NSString *) idEvent : (NSDate *) date : (NSURL *) url;
@end

NS_ASSUME_NONNULL_END
