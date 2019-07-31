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
    self = [self initWithInfo:@"" :@"" :@"" : [[NSDate alloc] init] :@"" : @"": @"": @"" : CLLocationCoordinate2DMake(37.77, -122.4)];
    return self;
}


- (instancetype)initWithInfo:(NSString *)name summary:(NSString *)summary idEvent:(NSString *)idEvent date:(NSDate *)date url:(NSString *)url category:(NSString *)category subtitle:(NSString *)subtitle api:(NSString *)api location:(CLLocationCoordinate2D) location
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.summary = summary;
        self.idEvent = idEvent;
        self.date = date;
        self.logo = url;
        self.category = category;
        self.subtitle = subtitle;
        self.api = api;
        self.location = location;
    }
    return self;
}
@end
