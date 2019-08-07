//
//  InterestCollectionViewCell.m
//  ProjectX
//
//  Created by amandahar on 8/1/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "InterestCollectionViewCell.h"

@implementation InterestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"interestDeleted" object:nil];
}

- (void)shake {
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    self.layer.shouldRasterize = YES;
    [self.layer addAnimation:anim forKey:@"interestShake"];
    
}

- (void)stopShaking {
    [self.layer removeAllAnimations];
}
@end
