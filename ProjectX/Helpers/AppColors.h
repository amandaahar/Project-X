//
//  AppColors.h
//  ProjectX
//
//  Created by alexhl09 on 8/6/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface AppColors : NSObject
@property (nonatomic, strong) UIColor *lightBlue;
+ (id)sharedManager;
- (id)init;
-(UIColor *) getLightBlue;
-(UIColor *)getMediumBlue;
-(UIColor *) getDarkBlue;
-(UIColor *) getWhite;
-(UIColor *) getAlpha15;
-(UIColor *) getAlpha30;
-(UIColor *) getDarkPurple;
-(UIColor *) getDarkBlueBackground;
-(UIColor *) getDarkBuble2;
-(UIColor *) getBlueBackground;

-(CAGradientLayer *) getGradientExp :(UIView *)view;
-(UIColor *) getOrange;
-(UIColor *) getBlueLabels;
-(CAGradientLayer *) getGradientPurple :(UIView *)view;
-(CAGradientLayer *) getGradientDefault :(UIView *)view;
-(UIColor *) getRed;
@end

NS_ASSUME_NONNULL_END
