//
//  MessageTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setUserLabelText:(NSString *)userLabelText {
    self.userLabel.text = userLabelText;
    
}


-(void)setMessageText:(NSString *)messageText {
    NSLog(@"message text%@", messageText);
    self.messageTextLabel.text = messageText;
    NSLog(@"message of text after%@", self.messageTextLabel.text);
    
}

/*
-(void) setMessageTextLabel:(NSString *)messageTextLabel {
    self.messageTextLabel.text = messageTextLabel;
}
 */

@end
