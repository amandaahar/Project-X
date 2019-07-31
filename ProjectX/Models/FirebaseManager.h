//
//  FirebaseManager.h
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "EventAPI.h"
NS_ASSUME_NONNULL_BEGIN
@import Firebase;

@class User;

@interface FirebaseManager : NSObject {
    FIRFirestore *database;
}

+ (id)sharedManager;
- (void)getCurrentUser:(void(^)(User *user, NSError *error))completion;
- (void)getEvents:(void(^)(NSArray *event, NSError *error))completion;
- (void)getMessagesFromEvent:(NSString *) eventID completion: (void(^)(NSArray *messages, NSError *error))completion;
- (void)getEventsFromUser:(NSString *) userID completion: (void(^)(NSArray *events, NSError *error))completion;
-(void) setNewLanguage : (NSString *) newLanguage;
-(void) setNewPreferences : (NSArray *) preferences;
-(void) setNewAPIEvent : (EventAPI *) event completion: (void(^)( NSError *error))completion;
-(void) addUserToEvent : (FIRDocumentReference *) eventID;
-(void)getCurrentEvent: (NSString *) detailEventID completion: (void(^)(Event * myEvent, NSError *error))completion;
-(void) addReactionInEvent: (NSString *) idEvent andMessage: (NSString *) idMessage;
-(void) removeReactionInEvent: (NSString *) idEvent andMessage: (NSString *) idMessage;
@end

NS_ASSUME_NONNULL_END
