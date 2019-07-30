//
//  HomeFeedTableViewCell.h
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/EventAPI.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleEvent;
@property (weak, nonatomic) IBOutlet UIImageView *imageEvent;
@property (weak, nonatomic) IBOutlet UILabel *descriptionEvent;
@property (strong, nonatomic) EventAPI *event;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *api;
@property (weak, nonatomic) IBOutlet UIButton *addCalendarButton;
-(void) setMyEvent:(EventAPI *)event;
@end

NS_ASSUME_NONNULL_END
