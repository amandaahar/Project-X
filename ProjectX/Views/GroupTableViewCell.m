//
//  GroupTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "Chat.h"
#import "UIImageView+AFNetworking.h"

@interface GroupTableViewCell()
@property (nonatomic, strong) Chat *chat;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *nameOfChat;
@property (weak, nonatomic) IBOutlet UILabel *previewOfLatestMessage;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageUser;
@property (weak, nonatomic) IBOutlet UILabel *timeOfLastMessage;

@end

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getNameOfChat {
    return self.nameOfChat.text;
}

- (void)setNameOfChatText:(NSString *)nameOfChat {
    self.nameOfChat.text = nameOfChat;
}

- (void) setImage: (NSString *) photoURL {
    NSURL *imageURL = [NSURL URLWithString:photoURL];
    [self.groupImage setImageWithURL:imageURL];
    
}
@end
