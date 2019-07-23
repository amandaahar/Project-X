//
//  Message.h
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import "User.h"
#import "../Models/FirebaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

#pragma mark - Message Attributes
@property(strong, nonatomic) NSString *text;
@property(strong, nonatomic) NSDate *timeSent;
@property(strong, nonatomic) NSString *nameOfSender;
@property(strong, nonatomic) NSString *userID;

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)messagesWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
