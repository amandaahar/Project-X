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
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"name",@"",@"description",0,@"attendees",@[], @"pictures",@"", @"location", [NSDate new], @"date",0,@"categories",@"",@"userFriendlyLocation", nil];
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
        self.usersInEvent = dictionary[@"swipeUsers"];
        self.date = dictionary[@"eventDate"];
        self.eventID = eventID;
        self.categories = dictionary[@"categoryIndex"];
        self.userFriendlyLocation = dictionary[@"userFriendlyLocation"];
    }
    return self;
}



//- (instancetype)initWithDictionary:(NSDictionary *)dictionary eventID:(NSString *)eventID
//{
//    self = [super init];
//    if (self)
//    {
////        self.name = dictionary[@"name"];
////        self.descriptionEvent = dictionary[@"description"];
////        self.attendees = dictionary[@"numAttendees"];
////        // self.location = [[GeoFire alloc] init];
////        self.pictures = dictionary[@"pictures"];
////        self.location = dictionary[@"location"];
////        self.date = dictionary[@"eventDate"];
////        self.eventID = eventID;
//        [self addDetails:dictionary eventId:eventID];
//    }
//    return self;
//}
//
// Takes in an empty event and all the info needed to "make" the event
// Adds all the info to the event, doesn't return anything
- (void)addDetails:(NSDictionary *)details eventId:(NSString *)eventID {
    self.name = details[@"name"];
    self.descriptionEvent = details[@"description"];
    self.attendees = details[@"numAttendees"];
    // self.location = [[GeoFire alloc] init];
    self.pictures = details[@"pictures"];
    self.location = details[@"location"];
    self.date = details[@"eventDate"];
    self.eventID = eventID;
    self.categories = details[@"categoryIndex"];
}

//+ (NSMutableArray *)eventsWithArray:(NSArray *)dictionaries{
//    NSMutableArray *events = [NSMutableArray array];
//    for (NSDictionary *dictionary in dictionaries) {
//        Event *event = [[Event alloc] initWithDictionary:dictionary];
//        [events addObject:event];
//    }
//    return event;
//}


- (instancetype)initWithFIRDocuemtReference:(FIRDocumentReference *)eventDoc {
   self = [super init];
    // self.path = chatCollection.path;
    if (self) {
        [eventDoc getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
            [self addDetails:snapshot.data eventId:eventDoc.documentID];
        }];
    }
    return self;
}


+ (NSMutableArray *)eventsWithSnapshot:(NSArray *)references{
    NSMutableArray *events = [NSMutableArray array];
    // Either initWithFIRDoc waits to return until the document has been fetched
    for (FIRDocumentReference *ref in references) {
        Event *event = [[Event alloc] initWithFIRDocuemtReference:ref];
        [events addObject:event];
    }
    return events;
}





@end
