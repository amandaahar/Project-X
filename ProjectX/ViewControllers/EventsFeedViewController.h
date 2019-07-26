//
//  EventsFeedViewController.h
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/EventAPI.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EventDidSelectedDelegate
-(void) didSelected : (EventAPI *) eventSelected;


@end

@interface EventsFeedViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
