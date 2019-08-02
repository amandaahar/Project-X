//
//  Bubble.m
//  ProjectX
//
//  Created by alexhl09 on 7/27/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.index = dic[@"id"];
        NSString *firstWord = [[dic[@"short_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
        self.name = firstWord;
        self.preference = dic;  
    }
    return self;
}

- (NSString *)bubbleText
{
    return [NSString stringWithFormat:@"%@",self.name];
}

+ (NSMutableArray *)bubblesWithArray:(NSArray *)dictionaries{
    NSMutableArray *bubbles = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Bubble *bubble = [[Bubble alloc] initWithDic:dictionary];
        [bubbles addObject:bubble];
    }
    return bubbles;
}

@synthesize bubbleState = _bubbleState;
@end
