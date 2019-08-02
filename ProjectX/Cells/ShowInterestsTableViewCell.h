//
//  ShowInterestsTableViewCell.h
//  ProjectX
//
//  Created by amandahar on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowInterestsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (strong, nonatomic) NSMutableArray *interestsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@end

NS_ASSUME_NONNULL_END
