//
//  EditProfileTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EditProfileTableViewCell.h"

@implementation EditProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2;
    self.profileView.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapChangeProfileButton:(id)sender {
    
}

+ (NSNumber *)recommendedHeight {
    return [NSNumber numberWithInt:280];
}

@end
