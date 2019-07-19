//
//  GroupEventsTableViewCell.m
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "GroupEventsTableViewCell.h"
#import "CategoriesCollectionViewCell.h"
@implementation GroupEventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.groupedEvents = [NSArray new];
    self.collectionViewGroupsEvents.delegate = self;
    self.collectionViewGroupsEvents.dataSource = self;

    [self.collectionViewGroupsEvents reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    NSString * identifier = @"categoryCell";
    CategoriesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell)
    {
        
        [collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    NSMutableArray * groupEventsOfThree = [NSMutableArray new];
    for(size_t i = indexPath.row * 3; i < self.groupedEvents.count - 1 && i
        < (indexPath.row + 1) * 3; i++)
    {
        [groupEventsOfThree addObject:self.groupedEvents[i]];
    }
    cell.threeEvents = groupEventsOfThree;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int numberOfItems = ceil(self.groupedEvents.count / 3);
    return numberOfItems;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
}


@end

