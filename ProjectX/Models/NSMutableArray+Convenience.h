//
//  NSMutableArray+Convenience.h
//  ProjectX
//
//  Created by alexhl09 on 7/21/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
NS_ASSUME_NONNULL_END
