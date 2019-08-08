//
//  EditProfileTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EditProfileTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EditProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.bio.delegate = self;
    
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2;
    self.profileView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(profilePhotoChanged:) name:@"photoChangeNotification" object:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapGestureForKeyboard:(id)sender {
    [self endEditing:YES];
}

+ (NSNumber *)recommendedHeight {
    return [NSNumber numberWithInt:280];
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.firstName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstNameNotification"
                                                            object:nil
                                                          userInfo:@{@"firstName": self.firstName.text}];

    } else if ([textField isEqual:self.lastName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lastNameNotification"
                                                            object:nil
                                                          userInfo:@{@"lastName": self.lastName.text}];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bioNotification"
                                                        object:nil
                                                      userInfo:@{@"bio": self.bio.text}];
}

- (void)profilePhotoChanged:(NSNotification *)notification {
    self.profileView.image = notification.userInfo[@"newPhoto"];
    
}

@end
