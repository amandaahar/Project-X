//
//  EditProfileViewController.h
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "InterestsCollectionViewCell.h"
#import "APIEventsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController

- (void)doneCategoryPicker: (UIButton *)button;
- (void)setUpCurrentProperties;


@end

NS_ASSUME_NONNULL_END
