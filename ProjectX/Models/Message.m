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
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"text",[NSDate new],@"textDate",[FIRDocumentReference new],@"userID",nil];
    self = [self initWithDictionary:defaultDictionary];
    return self;
}

-(instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        FIRTimestamp *textDate = dictionary[@"textDate"];
        [self setText:dictionary[@"text"]];
        [self setTextDate:textDate.dateValue];
        [self setUserID:dictionary[@"userID"]];
    }
    return self;
}


@end
