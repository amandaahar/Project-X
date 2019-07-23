//
//  MessageBubble.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessageBubble.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation MessageBubble

- (void)awakeFromNib {
    [super awakeFromNib];
    [self ahowOutgoingMessage:@"HEY"];
    // Initialization code
}

-(void) ahowOutgoingMessage : (NSString *) text
{
    UILabel * label = [[UILabel alloc] init];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setTextColor:[UIColor blackColor]];
    [label setText: text];
    CGSize constraintRect = CGSizeMake(0.66 * self.frame.size.width, CGFLOAT_MAX);
    CGRect boundingBox = [text boundingRectWithSize:constraintRect options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : label.font } context:nil];
    label.frame = boundingBox;
    CGSize bubbleSize = CGSizeMake(label.frame.size.width + 28, label.frame.size.height + 20);
    CGFloat width = bubbleSize.width;
    CGFloat height = bubbleSize.height;
    
    UIBezierPath * bezierPath = [UIBezierPath new];
    [bezierPath moveToPoint:CGPointMake(width - 22, height)];
    [bezierPath addLineToPoint:CGPointMake(17, height)];
    [bezierPath addCurveToPoint:CGPointMake(0, height - 17) controlPoint1:CGPointMake(0, 7.61) controlPoint2:CGPointMake(7.61, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, 17)];
    [bezierPath addCurveToPoint:CGPointMake(17, 0) controlPoint1:CGPointMake(0, 7.61) controlPoint2:CGPointMake(7.61, 0)];
    [bezierPath addLineToPoint:CGPointMake(width - 21, 0)];
    [bezierPath addCurveToPoint:CGPointMake(width - 4, 17) controlPoint1:CGPointMake(width - 11.61, 0) controlPoint2:CGPointMake(width, height)];
    [bezierPath addLineToPoint:CGPointMake(width - 4, height - 11)];
    [bezierPath addCurveToPoint:CGPointMake(width, height) controlPoint1:CGPointMake(width - 4, height - 1) controlPoint2:CGPointMake(width, height)];
    [bezierPath addLineToPoint:CGPointMake(width + 0.05, height - 0.01)];
    [bezierPath addCurveToPoint:CGPointMake(width - 11.04, height - 4.04) controlPoint1:CGPointMake(width - 4.07, height + 0.43) controlPoint2:CGPointMake(width - 8.16, height - 1.06)];
    [bezierPath addCurveToPoint:CGPointMake(width - 22, height) controlPoint1:CGPointMake(width - 16, height) controlPoint2:CGPointMake(width - 19, height)];
    [bezierPath closePath];
    
    CAShapeLayer * outgoingMessageLayer = [[CAShapeLayer alloc] init];
    [outgoingMessageLayer setPath:bezierPath.CGPath];
    [outgoingMessageLayer setFrame:CGRectMake(self.frame.size.width/2 - width/2, self.frame.size.height/2 - height/2, width, height)];
    [outgoingMessageLayer setFillColor:[[UIColor colorWithRed:0.09 green:0.54 blue:1 alpha:1] CGColor]];
    [self.layer addSublayer:outgoingMessageLayer];
    label.center = self.center;
    [self addSubview:label];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
