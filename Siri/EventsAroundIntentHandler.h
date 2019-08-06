//
//  EventsAroundIntentHandler.h
//  Siri
//
//  Created by alexhl09 on 8/5/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventsAroundIntent.h"
NS_ASSUME_NONNULL_BEGIN

@interface EventsAroundIntentHandler : NSObject <EventsAroundIntentHandling>
@property (strong, nonatomic) NSMutableArray *events;
@end

NS_ASSUME_NONNULL_END
