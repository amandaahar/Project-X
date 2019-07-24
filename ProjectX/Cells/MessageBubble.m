//
//  MessageBubble.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessageBubble.h"
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
    [self.bubbleLabel setText:message.text];
    
    self.bubbleView.isIncoming = YES;
    self.bubbleView.incomingColor = [UIColor colorWithWhite:0.6 alpha:1];
   [self.bubbleLabel setTextAlignment:(NSTextAlignmentLeft)];
    
    [self.bubbleLabel sizeToFit];
    [self.bubbleView setNeedsDisplay];
    [self sizeToFit];
}


- (void)showOutgoingMessage:(Message *)message
{
    self.message = message;
    self.nameLabel.text = message.nameOfSender;
    [self.bubbleLabel setText:message.text];
    [self.bubbleLabel sizeToFit];
    for (NSLayoutConstraint * constraint in self.bubbleLabel.constraints)
    {
        NSLog(@"%@",constraint.identifier);
        if([constraint.identifier isEqualToString:@"right"])
        {
            [self removeConstraint:constraint];
        }
    }
    NSLayoutConstraint *rightButtonXConstraint = [NSLayoutConstraint
                                                 constraintWithItem:self.bubbleLabel attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:
                                                 NSLayoutAttributeLeft multiplier:1.0 constant:30];
    
    [self addConstraints:@[rightButtonXConstraint]];
    
    [self.bubbleLabel setTextAlignment:(NSTextAlignmentRight)];
    self.bubbleView.isIncoming = NO;
     self.bubbleView.outgoingColor = [UIColor colorWithRed:0.09 green:0.54 blue:1 alpha:1];
    [self.bubbleView setNeedsDisplay];

   [self sizeToFit];
    //[self.bubbleView drawRect:self.bubbleView.frame];
   
//    UILabel * label = [[UILabel alloc] init];
//    [label setNumberOfLines:0];
//    [label setFont:[UIFont systemFontOfSize:14]];
//    [label setTextColor:[UIColor blackColor]];
//    [label setText: text];
//
//    [label setTextColor:[UIColor whiteColor]];
//
//    CGSize constraintRect = CGSizeMake(0.66 * self.frame.size.width, CGFLOAT_MAX);
//    CGRect boundingBox = [text boundingRectWithSize:constraintRect options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : label.font } context:nil];
//    label.frame = boundingBox;
//    CGSize bubbleSize = CGSizeMake(label.frame.size.width + 28, label.frame.size.height + 20);
//
//    BubbleView * bubbleView = [BubbleView new];
//    bubbleView.frame = CGRectMake(bubbleView.frame.origin.x, bubbleView.frame.origin.y, label.frame.size.width + 28, label.frame.size.height + 20);
//    bubbleView.backgroundColor = [UIColor clearColor];
//
//    bubbleView.center = CGPointMake(self.frame.size.width - bubbleView.frame.size.width / 2 - 90, self.center.y);
//    [self addSubview:bubbleView];
//
//    label.center = bubbleView.center;
//    [self addSubview:label];
//
//
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
