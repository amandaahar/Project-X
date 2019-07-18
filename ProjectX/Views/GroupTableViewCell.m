//
//  GroupTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "Chat.h"

@interface GroupTableViewCell()
@property (nonatomic, strong) Chat *chat;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *nameOfChat;
@property (weak, nonatomic) IBOutlet UILabel *previewOfLatestMessage;


@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
