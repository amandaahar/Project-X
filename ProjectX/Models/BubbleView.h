//
//  BubbleView.h
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BubbleView : UIView

@property (assign, nonatomic) BOOL isIncoming;
@property (nonatomic, strong) UIColor * incomingColor;
@property (nonatomic, strong) UIColor * outgoingColor;
@end

NS_ASSUME_NONNULL_END
