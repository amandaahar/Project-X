//
//  Bubble.h
//  ProjectX
//
//  Created by alexhl09 on 7/27/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import BLBubbleFilters;
NS_ASSUME_NONNULL_BEGIN

@interface Bubble : NSObject <BLBubbleModel>

- (instancetype)initWithDic:(NSDictionary *)dic;

@property (nonatomic, assign) NSNumber *index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *preference;

+ (NSMutableArray *)bubblesWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
