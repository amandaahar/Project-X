//
//  Chat.h
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/FirebaseManager.h"
#import "Event.h"
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat : NSObject

#pragma mark - Chat Attributes

@property (strong, nonatomic) NSMutableArray *messages;
@property(strong, nonatomic) NSString *event;
@property(strong, nonatomic) NSString *path;

#pragma mark - Chat Initializer
// -(instancetype) initWithDictionary : (NSDictionary *) dictionary;
-(instancetype) initWithFIRCollectionReference:(FIRCollectionReference *)chatCollection;
- (void)getEventForChat:(void(^)(Event *event, NSError *error))completion;
//-(BOOL) isExpired;

@end

NS_ASSUME_NONNULL_END
