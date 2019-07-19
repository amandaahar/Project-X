//
//  topCollectionViewCell.h
//  ProjectX
//
//  Created by alexhl09 on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/EventAPI.h"
NS_ASSUME_NONNULL_BEGIN

@interface topCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageEvent;
@property (weak, nonatomic) IBOutlet UILabel *descriptionEvent;
@property (weak, nonatomic) EventAPI *event;
@property (weak, nonatomic) IBOutlet UILabel *titleEvent;
-(void) setMyEvent:(EventAPI *)event;
@end

NS_ASSUME_NONNULL_END
