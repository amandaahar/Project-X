//
//  FirebaseManager.h
//  ProjectX
//
//  Created by alexhl09 on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
NS_ASSUME_NONNULL_BEGIN
@import Firebase;
@class User;

@interface FirebaseManager : NSObject {
    FIRFirestore *database;
}

+ (id)sharedManager;
- (void)getCurrentUser:(void(^)(User *user, NSError *error))completion;
- (void)getEvent:(void(^)(NSArray *event, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
