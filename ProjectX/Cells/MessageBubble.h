//
//  MessageBubble.h
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Message.h"
#import "../Models/BubbleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageBubble : UITableViewCell
@property (nonatomic, strong) Message * message;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet BubbleView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *bubbleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) NSString *userLanguage;
@property (weak, nonatomic) IBOutlet UIView *reactionView;
@property (strong, nonatomic) NSString *idEvent;
@property (weak, nonatomic) IBOutlet UIImageView *reactionImage;
-(void) showIncomingMessage : (Message *) message;
- (void)showOutgoingMessage:(Message *)message;

@end

NS_ASSUME_NONNULL_END
