//
//  ProfileHeaderCollectionReusableView.m
//  ProjectX
//
//  Created by amandahar on 7/30/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ProfileHeaderCollectionReusableView.h"


@interface ProfileHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet PillLabel *followLabel;
@property (weak, nonatomic) IBOutlet PillLabel *messageLabel;


@end

@implementation ProfileHeaderCollectionReusableView

- (void) setProfileImageWithURL:(NSString *)photoURL {
    NSURL *imageURL = [NSURL URLWithString:photoURL];
    [self.profileImage setImageWithURL:imageURL];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.masksToBounds = YES;
}

- (void) setNameText:(NSString *)name {
    self.name.text = name;
}

- (void) setUsernameText:(NSString *)username {
    self.username.text = username;
}

- (void) setBioText:(NSString *)bio {
    self.bio.text = bio;
}

- (PillLabel *)getFollowLabel {
    return self.followLabel;
}

@end
