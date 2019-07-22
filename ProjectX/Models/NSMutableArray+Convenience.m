//
//  NSMutableArray+Convenience.m
//  ProjectX
//
//  Created by alexhl09 on 7/21/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "NSMutableArray+Convenience.h"

@implementation NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex < toIndex) {
        toIndex--; 
    }
    
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end
