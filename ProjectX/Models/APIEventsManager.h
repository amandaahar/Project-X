//
//  APIEventsManager.h
//  ProjectX
//
//  Created by alexhl09 on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIEventsManager : NSObject

+ (id)sharedManager;
- (void) getCategories:(void(^)(NSArray *categories, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
