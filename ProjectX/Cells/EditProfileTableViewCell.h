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

//@protocol changeInfoDelegate <NSObject>
//
//- (void)firstNameChanged: (NSString *) firstName;
//- (void)lastNameChanged: (NSString *) lastName;
//- (void)bioChanged: (NSString *) bio;
//
//@end
@interface EditProfileTableViewCell : UITableViewCell <UITextFieldDelegate>

+ (NSNumber *)recommendedHeight;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet MFTextField *firstName;
@property (weak, nonatomic) IBOutlet MFTextField *lastName;
@property (weak, nonatomic) IBOutlet MFTextField *bio;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) NSString *profileViewImageString;


@end

NS_ASSUME_NONNULL_END
