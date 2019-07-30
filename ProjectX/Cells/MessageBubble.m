//
//  MessageBubble.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessageBubble.h"
#import "../Helpers/TranslatorManager.h"
#import <UIKit/UIKit.h>
@implementation MessageBubble

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    // Initialization code
}



-(void) showIncomingMessage : (Message *) message
{
    self.message = message;
    self.nameLabel.text = message.nameOfSender;
    //[self.bubbleLabel setText:message.text];
    
    self.bubbleView.isIncoming = YES;
    self.bubbleView.incomingColor = [UIColor colorWithWhite:0.6 alpha:1];
   [self.bubbleLabel setTextAlignment:(NSTextAlignmentLeft)];
    [self.rightConstraint setActive:NO];
    [self.leftConstraint setActive:YES];
   


    if([self.message.language isEqualToString:self.userLanguage])
    {
        [self.bubbleLabel setText:message.text];
        [self.bubbleLabel layoutIfNeeded];
        [self.bubbleLabel sizeToFit];
        [self.bubbleView setNeedsDisplay];
        
        [self sizeToFit];
        
    }else
    {
        [[TranslatorManager sharedManager] translateTextInLanguage:self.message.language :self.userLanguage :message.text completion:^(NSString * _Nonnull translated, NSError * _Nonnull error) {
            if(error == nil)
            {
                [self.bubbleLabel setText:translated];
                [self.bubbleLabel layoutIfNeeded];
                [self.bubbleLabel sizeToFit];
                [self.bubbleView setNeedsDisplay];
                
                [self sizeToFit];
            }
            
        }];
    }
    
}


- (void)showOutgoingMessage:(Message *)message
{
    self.message = message;
  

    self.nameLabel.text = @"";
    [self.bubbleLabel setText:message.text];
    
    [self.bubbleLabel sizeToFit];
    [self.leftConstraint setActive:NO];
    [self.rightConstraint setActive:YES];
    [self.bubbleLabel layoutIfNeeded];
    [self.bubbleLabel setTextAlignment:(NSTextAlignmentRight)];
    self.bubbleView.isIncoming = NO;
     self.bubbleView.outgoingColor = [UIColor colorWithRed:0.09 green:0.54 blue:1 alpha:1];
    [self.bubbleView setNeedsDisplay];
   [self sizeToFit];
}

@end
