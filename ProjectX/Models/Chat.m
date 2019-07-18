//
//  Chat.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Chat.h"

@implementation Chat

#pragma mark - Chat Initializer
-(instancetype) init {
    NSDictionary *defaultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"createdAt",@"",@"endAt",@"",@"name", @"", @"users",nil];
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
        
    }
    return self;
}
@end
