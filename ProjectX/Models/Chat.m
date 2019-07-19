//
//  Chat.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Chat.h"
#import "Event.h"

@implementation Chat

#pragma mark - Chat Initializer
-(instancetype) init {
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"createdAt",@"",@"endAt",@"",@"name", @"", @"users",@"", @"event",nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        [self setCreatedAt:dictionary[@"createdAt"]];
        [self setEndAt:dictionary[@"endAt"]];
        [self setName:dictionary[@"name"]];
        [self setUsers:dictionary[@"users"]];
        [self setEvent:dictionary[@"event"]];
        
    }
    return self;
}

- (void)getEventForChat:(void(^)(Event *event, NSError *error))completion {
    
    FIRFirestore *db = [FIRFirestore firestore];
    
//    FIRDocumentReference *docRef =
//    [[db collectionWithPath:@"Users"] documentWithPath:@"DAhDAxEMoJNpOcjkaWe1cyevl9v2"];
//    // [[database collectionWithPath:@"Users"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
//    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
//        if (snapshot.exists) {
//            User * newUser = [[User alloc] initWithDictionary:snapshot.data];
//            completion(nil, nil);
//        } else {
//            completion(nil, error);
//        }
//    }];
//}
//
    FIRDocumentReference *eventRef = [[db collectionWithPath:@"Event"] documentWithPath:self.event];

    [eventRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            NSLog(@"Document data: %@", snapshot.data);
            Event *event = [[Event alloc] initWithDictionary:snapshot.data];
            completion(event, nil);
            // [cell setImage:event.pictures[0]];


        } else {
            NSLog(@"Document does not exist");
            completion(nil, error);
        }
    }];

    
}
    
    

@end
