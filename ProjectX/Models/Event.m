//
//  Event.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Event.h"

@implementation Event


-(instancetype) init
{
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"name",@"",@"description",0,@"attendees",@[], @"pictures",@"", @"location", [NSDate new], @"date", nil];
    self = [self initWithDictionary:defaultDictionary eventID:@""];
    return self;
}
-(instancetype) initWithDictionary : (NSDictionary *) dictionary eventID: (NSString *)eventID
{
    self = [super init];
    if(self)
    {
        self.name = dictionary[@"name"];
        self.descriptionEvent = dictionary[@"description"];
        self.attendees = dictionary[@"numAttendees"];
        // self.location = [[GeoFire alloc] init];
        self.pictures = dictionary[@"pictures"];
        self.location = dictionary[@"location"];
        self.date = dictionary[@"eventDate"];
        self.eventID = eventID;
    }
    return self;
}




@end
