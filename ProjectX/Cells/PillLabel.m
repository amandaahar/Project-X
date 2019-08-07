//
//  PillLabel.m
//  ProjectX
//
//  Created by amandahar on 7/25/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "PillLabel.h"

@interface PillLabel()


@end

@implementation PillLabel

-(void) setup {
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"smallBlueGradient.png"]];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

-(void) prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setup];
    
}

- (float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize expectedLabelSize = [[self text] sizeWithAttributes:@{NSFontAttributeName:self.font}];
    
    return expectedLabelSize.width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
