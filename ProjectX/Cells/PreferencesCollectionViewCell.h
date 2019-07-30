//
//  PreferencesCollectionViewCell.h
//  ProjectX
//
//  Created by alexhl09 on 7/29/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PillLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreferencesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PillLabel *pillLabel;

@end

NS_ASSUME_NONNULL_END
