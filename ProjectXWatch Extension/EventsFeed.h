//
//  EventsFeed.h
//  ProjectXWatch Extension
//
//  Created by alexhl09 on 8/12/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventsFeed : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;

@end

NS_ASSUME_NONNULL_END
