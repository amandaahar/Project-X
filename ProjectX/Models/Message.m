//
//  Message.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Message.h"

@implementation Message

#pragma mark - Message Initializer
-(instancetype) init {
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"text",[NSDate new],@"timeSent",@"",@"userID", @"en", @"lan",nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        FIRTimestamp *timeSent = dictionary[@"timeSent"];
        [self setText:dictionary[@"text"]];
        [self setTimeSent:timeSent.dateValue];
        [self setNameOfSender:dictionary[@"nameOfSender"]];
        [self setUserID:dictionary[@"userID"]];
        if(dictionary[@"lan"])
        {
        [self setLanguage:dictionary[@"lan"]];
        }else
        {
            [self setLanguage:@"en"];
        }
    }
    return self;
}

+ (NSMutableArray *)messagesWithArray:(NSArray *)dictionaries{
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Message *message = [[Message alloc] initWithDictionary:dictionary];
        [messages addObject:message];
    }
    return messages;
}

@end
