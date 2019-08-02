//
//  FirebaseManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "FirebaseManager.h"
#import "User.h"

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

- (void)getEvents:(void(^)(NSArray *events, NSError *error))completion {
     
     
    [[[database collectionWithPath:@"Event"] queryWhereField:@"eventDate" isGreaterThanOrEqualTo:[FIRTimestamp timestampWithDate:[[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*6]]]
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

- (void)getEventsNotSwiped:(void(^)(NSArray *events, NSError *error))completion {
    
    
    [[[database collectionWithPath:@"Event"] queryWhereField:@"eventDate" isGreaterThanOrEqualTo:[FIRTimestamp timestampWithDate:[[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*6]]]
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
                 if(![myEvent.usersInEvent containsObject:FIRAuth.auth.currentUser.uid])
                 {
                     [events addObject:myEvent];
                 }
                 
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
//
//}




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
            [docReference updateData:@{@"name": event.name, @"description": event.summary, @"location": geoPoint, @"eventDate": dateEvent, @"numAttendees": [NSNumber numberWithInt:1], @"categoryIndex": [NSNumber numberWithInt:5], @"userFriendlyLocation": placemark.name, @"pictures" : @[event.logo], @"swipeUsers" :@[FIRAuth.auth.currentUser.uid]}];
            [[[self->database collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] updateData:@{ @"events": [FIRFieldValue fieldValueForArrayUnion:@[docReference]] }];
            completion(nil);
        }else
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

-(void) addFCMDeviceToUSer: (NSString *) token{
    [[[database collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] updateData:@{@"fcm": token}];
}
-(void) removeFCMDeviceToUser:(NSString *) idUser{
    [[[database collectionWithPath:@"Users"] documentWithPath:idUser] updateData:@{@"fcm": @""}];
}

-(void) sendNotificationUsers : (NSString *) idEvent withText:(NSString *) text nameUser:(NSString *) nameUser
{
    __weak FirebaseManager *weakSelf = self;
    [[[database collectionWithPath:@"Event"] documentWithPath:idEvent] getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(error == nil){
            FirebaseManager *strongSelf = weakSelf;
            for (NSString *idUser in snapshot.data[@"swipeUsers"]){
                if(![idUser isEqualToString: FIRAuth.auth.currentUser.uid]){
                    [[[strongSelf->database collectionWithPath:@"Users"] documentWithPath:idUser] getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
                        if(error == nil && snapshot[@"fcm"]){
                            NSString *urlString = @"https://fcm.googleapis.com/fcm/send";
                            NSURL *url = [NSURL URLWithString:urlString];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            NSDictionary *parameters = @{ @"notification": @{ @"title": nameUser, @"text": text },
                                                          @"priority": @"high",
                                                          @"to": snapshot[@"fcm"]};
                            
                            NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
                            [request setHTTPBody:postData];
                            
                            
                            
                            [request setHTTPMethod:@"POST"];
                            
                            [request setURL:url];
                            
                            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request addValue:@"key=AAAA7kl8B54:APA91bF9EBHatpiUabNJEy6MSD7eUhuPnEzmcKn1WwwbAEbZP9vM3syVmtCTsoWverO5yZF5o_dRWFGWqeHIQxnyvAst2CyJkElKdn-PGPlPXNEmCnY9f9vg2fSi7aVqZw9YLmu_ac9T" forHTTPHeaderField:@"Authorization"];
                            
                            
                            [request setHTTPBody:postData];
                            
                            NSURLSession *session = [NSURLSession sharedSession];
                            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                if(httpResponse.statusCode == 200)
                                {
                                    NSError *parseError = nil;
                                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                    NSLog(@"The response is - %@",responseDictionary);
                                    NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
                                    if(success == 1)
                                    {
                                        NSLog(@"Login SUCCESS");
                                    }
                                    else
                                    {
                                        NSLog(@"Login FAILURE");
                                    }
                                }
                                else
                                {
                                    NSLog(@"Error");
                                }
                            }];
                            [dataTask resume];
                        }
                    }];
                }
                
                
            }
        }
    }];
}

@end
