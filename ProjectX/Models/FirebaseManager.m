//
//  FirebaseManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "FirebaseManager.h"
#import "User.h"
CLLocation *greaterGeopoint;

@implementation FirebaseManager

#pragma mark - Singleton Methods

+ (id)sharedManager {
    static FirebaseManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        database = [FIRFirestore firestore];
    }
    return self;
}


- (void)dealloc {
    
}


#pragma mark - Get methods

- (void)getCurrentUser:(void(^)(User *user, NSError *error))completion
{
    FIRDocumentReference *docRef =
    //[[database collectionWithPath:@"Users"] documentWithPath:@"IfqQikuCzrZZ8sXK1VhmyVCgyqj2"];
        [[database collectionWithPath:@"Users"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
    [docRef addSnapshotListener:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            NSLog(@"user data%@", snapshot.data);
            User * newUser = [[User alloc] initWithDictionary:snapshot.data];
            
            completion(newUser, nil);
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getEvents:(void(^)(NSArray *events, NSError *error))completion
{
    //self.UserCurrentLocation = [[CLLocation alloc] initWithLatitude:36 longitude:-122];
//    greaterGeopoint = GeoPoint(latitude: 38, longitude: -125);
//    GeoPoint(38,-125);
    
//    int lat = 0.01449;
//    int lon = 0.01818;
//    int lowerLat = latitude - (lat*distance);
    
    [[[database collectionWithPath:@"Event"]
                //queryWhereField:@"location" isLessThanOrEqualTo:[FIRGeoPoint GeoPoint(38)]]
                queryOrderedByField:@"location"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             completion(nil,error);
         } else {
             NSMutableArray *events = [NSMutableArray new];
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 NSLog(@"%@ => %@", document.documentID, document.data);
                 Event * myEvent = [[Event alloc] initWithDictionary:document.data eventID:document.documentID];
                 myEvent.eventIDRef = document.reference;
                 [events addObject:myEvent];
             }
             completion(events, nil);
         }
     }];
}

- (void)getMessagesFromEvent:(NSString *) eventID completion: (void(^)(NSArray *messages, NSError *error))completion {
    [[[[[database collectionWithPath:@"Event"] documentWithPath:eventID] collectionWithPath:@"Chat"] queryOrderedByField:@"timeSent" descending:NO] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            NSMutableArray * messages = [Message messagesWithArray:snapshot.documents];
            NSLog(@" messages %@", messages);
            completion(messages, nil);
            }
        
    }];

}

-(void)getCurrentEvent: (NSString *) detailEventID completion: (void(^)(Event * myEvent, NSError *error))completion {
    
    FIRDocumentReference *docRef =
    [[database collectionWithPath:@"Event"] documentWithPath:detailEventID];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            NSLog(@"Document data: %@", snapshot.data);
            Event * myEvent = [[Event alloc] initWithDictionary:snapshot.data eventID:snapshot.documentID];
            
            completion(myEvent, nil);
        } else {
            completion(nil, error);
        }
    }];
}

//- (void)getEventsFromUser:(NSString *)userID completion:(void(^)(NSArray *events, NSError *error))completion {
//    [[[database collectionWithPath:@"Users"] documentWithPath:userID] addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
////        if (error !=nil) {
////            completion(nil, error);
////        } else  {
////            NSLog(@"the events%@", snapshot.data);
////
//////            NSMutableArray *events = [Event eventsWithSnapshot:snapshot.data[@"events"]];
////            for (FIRDocumentReference *ref in snapshot.data) {
////                [ref getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
////                    // now we have the snapshot.data for the event
////
////                }];
////            }
////            [[[database collectionWithPath:@"Event"] documentWithPath:event] addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error
//            completion(nil, nil);
//        }
//
//}];
//
//
////    [[[database collectionWithPath:@"User"] documentWithPath:userID] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
////        if (error != nil) {
////            completion(nil, error);
////        } else {
////            NSMutableArray * messages = [Message messagesWithArray:snapshot.documents];
////            NSLog(@" messages %@", messages);
////            completion(messages, nil);
////        }
////
////    }];


#pragma mark - Set methods
-(void) setNewLanguage : (NSString *) newLanguage {
    [[[database collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] updateData:@{@"lan": newLanguage}];
}


-(void) setNewPreferences : (NSArray *) preferences
{
    [[[database collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] updateData:@{@"preferences" : preferences}];
}



-(void) setNewAPIEvent : (EventAPI *) event completion: (void(^)( NSError *error))completion
{
    CLGeocoder * geoCoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:event.location.latitude longitude:event.location.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark * placemark = placemarks[0];
            FIRGeoPoint *geoPoint = [[FIRGeoPoint alloc] initWithLatitude:event.location.latitude longitude:event.location.longitude];
            FIRDocumentReference *docReference = [[self->database collectionWithPath:@"Event"] addDocumentWithData:@{}];
            NSDate *dateEvent = [NSDate new];
            if(event.date != nil){
                dateEvent = event.date;
            }
            [docReference updateData:@{@"name": event.name, @"description": event.summary, @"location": geoPoint, @"eventDate": dateEvent, @"numAttendees": [NSNumber numberWithInt:1], @"categoryIndex": [NSNumber numberWithInt:5], @"userFriendlyLocation": placemark.name, @"pictures" : @[event.logo]}];

            [[[self->database collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] updateData:@{ @"events": [FIRFieldValue fieldValueForArrayUnion:@[docReference]] }];
            completion(nil);
        } else
        {
            completion(error);
        }
        
    }];
    
}

-(void) addUserToEvent : (FIRDocumentReference *) eventID
{
   
}

-(void) addReactionInEvent: (NSString *) idEvent andMessage: (NSString *) idMessage
{
    [[[[[database collectionWithPath:@"Event"] documentWithPath:idEvent] collectionWithPath:@"Chat"] documentWithPath: idMessage] updateData:@{@"likes" : [FIRFieldValue fieldValueForArrayUnion:@[FIRAuth.auth.currentUser.uid]]}];
}

-(void) removeReactionInEvent: (NSString *) idEvent andMessage: (NSString *) idMessage
{
    [[[[[database collectionWithPath:@"Event"] documentWithPath:idEvent] collectionWithPath:@"Chat"] documentWithPath: idMessage] updateData:@{@"likes" : [FIRFieldValue fieldValueForArrayRemove:@[FIRAuth.auth.currentUser.uid]]}];
}

-(void) removeMessageFromChat: (NSString *) idEvent andMessage:(NSString *)idMessage completion: (void(^)( NSError *error))completion{
    [[[[[database collectionWithPath:@"Event"] documentWithPath: idEvent] collectionWithPath:@"Chat"] documentWithPath:idMessage] deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        completion(error);
    }];
}

- (void)swipeEventsByLocation:(NSString *) latitude
                    longitude:(NSString *) longitude
                     category:(NSString *) category
                    shortName:(NSString *) shortname
                   completion:(void(^)(NSArray *eventsEventbrite,NSArray * eventsTicketmaster, NSError *error))completion{
    
}

@end
