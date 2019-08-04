//
//  InterestCollectionViewCell.h
//  ProjectX
//
//  Created by amandahar on 8/1/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PillLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InterestCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PillLabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *deleteView;

- (void)shake;
- (void)stopShaking;

@end

NS_ASSUME_NONNULL_END
