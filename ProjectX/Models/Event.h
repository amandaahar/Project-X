//
//  Event.h
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@import Firebase;
@import GeoFire;
@import AFNetworking;
@interface Event : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionEvent;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) FIRGeoPoint *location;
@property (strong, nonatomic) NSArray *pictures;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *attendees;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) FIRDocumentReference *eventIDRef;

typedef void (^EventFetcher)(Event *_Nullable event, NSError *_Nullable error);

- (instancetype) initWithDictionary : (NSDictionary *) dictionary eventID: (NSString *)eventID;
// Given the event Doc, and an empty tray, return a block
- (instancetype)initWithFIRDocuemtReference:(FIRDocumentReference *)eventDoc;
- (void)addDetails:(NSDictionary *)details eventId:(NSString *)eventID;
+ (NSMutableArray *)eventsWithSnapshot:(NSArray *)references;

@end

NS_ASSUME_NONNULL_END
