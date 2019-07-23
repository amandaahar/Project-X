//
//  Chat.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Chat.h"
#import "Event.h"
// #import "User.h"

@implementation Chat

#pragma mark - Chat Initializer


/*
-(instancetype) init {
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new],@"createdAt",[NSDate new],@"endAt",@"",@"name", @[], @"users",@"", @"event",nil];
    
    // how to initialize with empty fircollectionreference
    self = [self initWithDictionary:defaultDictionary];
    return self;
}
 */
 


-(instancetype) initWithFIRCollectionReference:(FIRCollectionReference *)chatCollection {
    self = [super init];
    self.path = chatCollection.path;
    if(self) {
        [chatCollection getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
            if (error != nil) {
                NSLog(@"error getting messages in chat collection");
            } else {
                self.messages = [[NSMutableArray alloc] init];
                
                // NSLog(@"chat path%@", self.path);
                for (FIRDocumentSnapshot *document in snapshot.documents) {
                    Message *message = [[Message alloc] initWithDictionary:document.data];
                    [self.messages addObject:message];
                }
            }
        }];
    }
    return self;
}

-(void) fetchMessages{
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:self.path] getDocumentsWithCompletion: ^(FIRQuerySnapshot *snapshot, NSError *error) {
        if (error != nil) {
            NSLog(@"error getting messages in chat collection");
        } else {
            
        }
    }];
     
        
    
}







- (void)getEventForChat:(void(^)(Event *event, NSError *error))completion {
    
    FIRFirestore *db = [FIRFirestore firestore];
    
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




//-(BOOL) isExpired {
//    NSDate *today = [NSDate date];
//    if ([today compare:self.] == NSOrderedDescending) {
//       //  NSLog(@"comparison result %d", [self.createdAt compare:self.endAt] == NSOrderedDescending);
//        
//        return YES;
//    } else {
//        return NO;
//    }
//}

 
    
    

@end
