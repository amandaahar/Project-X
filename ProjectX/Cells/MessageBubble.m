//
//  MessageBubble.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessageBubble.h"
#import "../Helpers/TranslatorManager.h"
#import "../Helpers/AppColors.h"
#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>
@implementation MessageBubble

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;

    self.reactionView.layer.shadowRadius  = 15;
    self.reactionView.layer.cornerRadius = 15;
    self.reactionView.clipsToBounds = YES;
    self.reactionView.layer.shadowOffset = CGSizeMake(0,0);
    self.reactionView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.reactionView.layer.shadowOpacity = 0.5;
    self.reactionView.layer.masksToBounds = NO;
    self.reactionView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.reactionView.bounds].CGPath;


    
    // Initialization code
}

-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint myPoint = [self convertPoint:point toView:self.bubbleView];
    CGFloat pointOriginXReactionView = self.bubbleView.frame.size.width - 26;
    CGFloat pointOriginYReactionView = self.bubbleView.frame.size.height - 15;
    
    if(myPoint.x > pointOriginXReactionView && myPoint.x < pointOriginXReactionView + 46 && myPoint.y > pointOriginYReactionView && myPoint.y < pointOriginYReactionView + 31){
        return self.reactionButton;
    }
    return [super hitTest:point withEvent:event];
    
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
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
    [self layoutIfNeeded];
    [self.bubbleLabel layoutIfNeeded];
    
     //[self.reactionView setHidden:NO];
    [self.reactionView setNeedsDisplay];
    [self.reactionView layoutIfNeeded];
    [self changeImageReaction:self.message.liked];


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
                
               // [self sizeToFit];
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
    [self layoutIfNeeded];
    [self.bubbleLabel layoutIfNeeded];
     [self changeImageReaction:self.message.liked];
   //  [self.reactionView setHidden:YES];
    
    self.bubbleView.isIncoming = NO;
    self.bubbleView.outgoingColor = [[AppColors sharedManager] getOrange];
    [self.bubbleView setNeedsDisplay];
    [self.bubbleLabel setTextAlignment:(NSTextAlignmentRight)];
   [self sizeToFit];
}

- (void)prepareForReuse{
 
}


-(void) changeImageReaction : (BOOL) liked
{
    if(liked){
        [self.reactionImage setImage:[UIImage imageNamed:@"happy"]];
        
    }else{
        [self.reactionImage setImage:[UIImage imageNamed:@"emojiPlaceholder"]];
    }
}

- (IBAction)reacts:(UIButton *)sender {
    NSLog(@"didReact😉");
    if(!self.message.liked){
        [self.message setLiked:YES];
         [self changeImageReaction:self.message.liked];
        [[FirebaseManager sharedManager] addReactionInEvent:self.idEvent andMessage:self.message.idMessage];
    }else{
        [self.message setLiked:NO];
         [self changeImageReaction:self.message.liked];
        [[FirebaseManager sharedManager] removeReactionInEvent:self.idEvent andMessage:self.message.idMessage];
    }
    
}

@end
