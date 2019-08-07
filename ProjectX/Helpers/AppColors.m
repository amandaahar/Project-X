//
//  AppColors.m
//  ProjectX
//
//  Created by alexhl09 on 8/6/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "AppColors.h"

@implementation AppColors
+ (id)sharedManager {
    static AppColors *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {;
    }
    return self;
}


- (void)dealloc {
    
}

-(UIColor *) getLightBlue{
    return [UIColor colorWithRed: 0.76470588 green:0.988235 blue:0.9960784 alpha:1];
}
-(UIColor *)getMediumBlue{
    return [UIColor colorWithRed: 0.61960784 green:0.886274 blue:0.901960078 alpha:1];
}
-(UIColor *) getDarkBlue{
    return [UIColor colorWithRed: 0.3137235 green:0.70588235 blue:0.70196078 alpha:1];
}
-(UIColor *) getDarkBlueBackground{
    return [UIColor colorWithRed: 0.329411 green:0.45098 blue:0.5960 alpha:1];
}


-(UIColor *) getWhite{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.05];
}
-(UIColor *) getAlpha15{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.15];
}

-(UIColor *) getAlpha30{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.3];
}

-(UIColor *) getDarkPurple{
    return [UIColor colorWithRed: 0.482352 green: 0.3921568 blue:0.7529411 alpha:1];
}

-(UIColor *) getDarkBuble2{
    return [UIColor colorWithRed: 0.458824  green: 0.631373 blue: 0.835294 alpha:1];
}

- (UIColor *)getBlueBackground{
    return [UIColor colorWithRed: 0.45098039  green: 0.694117647 blue: 0.9215686 alpha:1];
}

-(UIColor *) getBlueLabels{
    return [UIColor colorWithRed: 0.2078431373  green: 0.5568627451 blue: 0.8823529412 alpha:1];
}


-(UIColor *) getOrange{
    return [UIColor colorWithRed: 1 green: 0.6 blue: 0.2274509804 alpha:1];
}

-(UIColor *) getPurple{
    return [UIColor colorWithRed: 1 green: 0.6 blue: 0.2274509804 alpha:1];
}



-(CAGradientLayer *) getGradientDefault :(UIView *)view{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[AppColors sharedManager] getDarkPurple].CGColor, (id)[[AppColors sharedManager]  getDarkBlue].CGColor];
    [gradient layoutIfNeeded];
    [gradient setNeedsDisplay];
    return gradient;
}


-(CAGradientLayer *) getGradientPurple :(UIView *)view{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[AppColors sharedManager] getBlueBackground].CGColor, (id)[[AppColors sharedManager]   getDarkBlueBackground ].CGColor];
    [gradient layoutIfNeeded];
    [gradient setNeedsDisplay];
    return gradient;
}

-(CAGradientLayer *) getGradientExp :(UIView *)view{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.type = kCAGradientLayerAxial;
    gradient.geometryFlipped = NO;
    gradient.colors = @[(id)[[AppColors sharedManager] getDarkPurple].CGColor, (id)[[AppColors sharedManager]   getBlueLabels ].CGColor];
    [gradient layoutIfNeeded];
    [gradient setNeedsDisplay];
    return gradient;
}

@end
