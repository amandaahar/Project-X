//
//  CategoriesCollectionViewCell.h
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoriesCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewEvents;
@property (strong, nonatomic) NSArray *threeEvents;
@end

NS_ASSUME_NONNULL_END
