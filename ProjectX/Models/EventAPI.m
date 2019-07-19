//
//  EventAPI.m
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventAPI.h"

@implementation EventAPI

#pragma mark - Init
-(instancetype) init
{
    self = [self initWithInfo:@"" :@"" :@"" : [[NSDate alloc] init] :@""];
    return self;
}


-(instancetype) initWithInfo : (NSString *) name  : (NSString *) summary : (NSString *) idEvent : (NSDate *) date : (NSString *) url
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.summary = summary;
        self.idEvent = idEvent;
        self.date = date;
        self.logo = url;
    }
    return self;
}
@end
