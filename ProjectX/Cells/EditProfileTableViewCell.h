//
//  EditProfileTableViewCell.h
//  ProjectX
//
//  Created by amandahar on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileTableViewCell : UITableViewCell

+ (NSNumber *)recommendedHeight;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet MFTextField *firstName;
@property (weak, nonatomic) IBOutlet MFTextField *lastName;
@property (weak, nonatomic) IBOutlet MFTextField *bio;

@end

NS_ASSUME_NONNULL_END
