//
//  FirebaseManager.m
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "FirebaseManager.h"

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
    [[database collectionWithPath:@"Users"] documentWithPath:@"DAhDAxEMoJNpOcjkaWe1cyevl9v2"];
    // [[database collectionWithPath:@"Users"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            User * newUser = [[User alloc] initWithDictionary:snapshot.data];
            completion(newUser, nil);
        } else {
            completion(nil, error);
        }
    }];

}

- (void)getEvent:(void(^)(NSArray *events, NSError *error))completion {
    [[database collectionWithPath:@"Event"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             completion(nil,error);
         } else {
             NSMutableArray *events = [NSMutableArray new];
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 NSLog(@"%@ => %@", document.documentID, document.data);
                 Event * myEvent = [[Event alloc] initWithDictionary:document.data];
                 [events addObject:myEvent];
//                 Events = [NSArray arrayWithObjects: @"name", @"description", @"numAttendees", @"location", @"eventDate", nil];
             }
             completion(events, nil);
         }
     }];
}

//- (void)getEventForChatId:(void(^)(Event *event, NSError *error))completion forChatID:(NSString *)chatID {
//    FIRCollectionReference *eventsRef = [database collectionWithPath:@"Events"];
//    FIRQuery *eventForChatQuery = [eventsRef queryWhereField:@"chats" arrayContains:chatID];
//    [eventForChatQuery getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
//        Event *theEvent;
//        for (FIRDocumentSnapshot *document in snapshot.documents) {
//            theEvent = [[Event alloc] initWithDictionary:document.data];
//        }
//        completion(theEvent, nil);
//    }];
//}
//
//
//
//-(Event *)getEventForChatId: (NSString *)chatID {
//    FIRCollectionReference *eventsRef = [database collectionWithPath:@"Events"];
//    FIRQuery *eventForChatQuery = [eventsRef queryWhereField:@"chats" arrayContains:chatID];
//    Event * event = [[Event alloc] initWithDictionary:eventForChatQuery];
//
//}
//



#pragma mark - Set methods


@end
