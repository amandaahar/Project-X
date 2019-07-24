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
    // [[database collectionWithPath:@"Users"] documentWithPath:@"DAhDAxEMoJNpOcjkaWe1cyevl9v2"];
    [[database collectionWithPath:@"Users"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
    [docRef addSnapshotListener:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            User * newUser = [[User alloc] initWithDictionary:snapshot.data];
            completion(newUser, nil);
        } else {
            completion(nil, error);
        }
    }];
}

- (void)getEvents:(void(^)(NSArray *events, NSError *error))completion {
    [[database collectionWithPath:@"Event"]
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
    [[[[[database collectionWithPath:@"Event"] documentWithPath:eventID] collectionWithPath:@"Chat"] queryOrderedByField:@"timeSent" descending:YES] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            NSMutableArray * messages = [Message messagesWithArray:snapshot.documents];
            NSLog(@" messages %@", messages);
            completion(messages, nil);
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


@end
