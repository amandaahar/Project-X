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
-(UIColor *) getWhite{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.05];
}
-(UIColor *) getAlpha15{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.15];
}

-(UIColor *) getAlpha30{
    return [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.15];
}

-(UIColor *) getDarkPurple{
    return [UIColor colorWithRed: 0.482352 green: 0.3921568 blue:0.7529411 alpha:1];
}
@end
