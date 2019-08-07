//
//  BubbleView.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "BubbleView.h"
#import "../Helpers/AppColors.h"
@implementation BubbleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.incomingColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.outgoingColor = [[AppColors sharedManager] getDarkBlueBackground];
        self.isIncoming = NO;
        
    }
    return self;
}

/**
 This is where I draw the message bubble that is very similar to the Apple Messeger bubble
 
 */
- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath * bezierPath = [UIBezierPath new];
    if (self.isIncoming) {
        [bezierPath moveToPoint:CGPointMake(22, height)];
        [bezierPath addLineToPoint:CGPointMake(width - 17, height)];
        [bezierPath addCurveToPoint:CGPointMake(width, height - 17) controlPoint1:CGPointMake(width - 7.61, height) controlPoint2:CGPointMake(width, height - 7.61)];
        [bezierPath addLineToPoint:CGPointMake(width, 17)];
        [bezierPath addCurveToPoint:CGPointMake(width - 17, 0) controlPoint1:CGPointMake(width, 7.61) controlPoint2:CGPointMake(width - 7.61, 0)];
        [bezierPath addLineToPoint:CGPointMake(21, 0)];
        [bezierPath addCurveToPoint:CGPointMake(4, 17) controlPoint1:CGPointMake(11.61, 0) controlPoint2:CGPointMake(4, 7.61)];
        [bezierPath addLineToPoint:CGPointMake(4, height - 11)];
        [bezierPath addCurveToPoint:CGPointMake(0, height) controlPoint1:CGPointMake( 4, height - 1) controlPoint2:CGPointMake(0, height)];
        [bezierPath addLineToPoint:CGPointMake(-0.05, height - 0.01)];
        [bezierPath addCurveToPoint:CGPointMake(11.04, height - 4.04) controlPoint1:CGPointMake(4.07, height + 0.43) controlPoint2:CGPointMake(8.16, height - 1.06)];
        [bezierPath addCurveToPoint:CGPointMake(22, height) controlPoint1:CGPointMake(16, height) controlPoint2:CGPointMake(19, height)];
        [self.incomingColor setFill];
        
    }else
    {
        [bezierPath moveToPoint:CGPointMake(width - 22, height)];
        [bezierPath addLineToPoint:CGPointMake(17, height)];
        [bezierPath addCurveToPoint:CGPointMake(0, height - 17) controlPoint1:CGPointMake(7.61, height) controlPoint2:CGPointMake(0, height - 7.61)];
        [bezierPath addLineToPoint:CGPointMake(0, 17)];
        [bezierPath addCurveToPoint:CGPointMake(17, 0) controlPoint1:CGPointMake(0, 7.61) controlPoint2:CGPointMake(7.61, 0)];
        [bezierPath addLineToPoint:CGPointMake(width - 21, 0)];
        [bezierPath addCurveToPoint:CGPointMake(width - 4, 17) controlPoint1:CGPointMake(width - 11.61, 0) controlPoint2:CGPointMake(width - 4, 7.61)];
        [bezierPath addLineToPoint:CGPointMake(width - 4, height - 11)];
        [bezierPath addCurveToPoint:CGPointMake(width, height) controlPoint1:CGPointMake(width - 4, height - 1) controlPoint2:CGPointMake(width, height)];
        [bezierPath addLineToPoint:CGPointMake(width + 0.05, height - 0.01)];
        [bezierPath addCurveToPoint:CGPointMake(width - 11.04, height - 4.04) controlPoint1:CGPointMake(width - 4.07, height + 0.43) controlPoint2:CGPointMake(width - 8.16, height - 1.06)];
        [bezierPath addCurveToPoint:CGPointMake(width - 22, height) controlPoint1:CGPointMake(width - 16, height) controlPoint2:CGPointMake(width - 19, height)];
        [self.outgoingColor setFill];
        
    }
    [bezierPath closePath];
    [bezierPath fill];
   
    // Drawing code
}


@end
