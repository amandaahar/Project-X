//
//  GroupEventsTableViewCell.m
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "GroupEventsTableViewCell.h"
#import "CategoriesCollectionViewCell.h"
#import "../Models/EventAPI.h"
#import "../Helpers/AppColors.h"
#import "topCollectionViewCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation GroupEventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.groupedEvents = [NSArray new];
    self.collectionViewGroupsEvents.delegate = self;
    self.collectionViewGroupsEvents.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
   



    [self.collectionViewGroupsEvents reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    NSString * identifier = @"categoryCell";
    if(self.fullView)
    {
        NSString * newIdentifier = @"topCell";

        topCollectionViewCell *cellCollection = nil;
        if(!cellCollection)
        {
           
            [collectionView registerNib:[UINib nibWithNibName:@"topCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"topCell"];
            cellCollection = [collectionView dequeueReusableCellWithReuseIdentifier:newIdentifier forIndexPath:indexPath];
            
        }
       
        [cellCollection setMyEvent:self.groupedEvents[indexPath.row]];
        
        return cellCollection;
    }
    CategoriesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell)
    {
        
        [collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    NSMutableArray * groupEventsOfThree = [NSMutableArray new];
    for(size_t i = indexPath.row * 3; i < self.groupedEvents.count - 1 && i
        < ((indexPath.row + 1) * 3); i++)
    {
        EventAPI * myEvent = self.groupedEvents[i];
       
        [groupEventsOfThree addObject:myEvent];
    }
    NSLog(@"%@",groupEventsOfThree);
    cell.threeEvents = groupEventsOfThree;

    [cell.tableViewEvents reloadData];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.fullView)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedEvent" object:self.groupedEvents[indexPath.row]];
    }
}

/**
 In the collectionView I am sending the total number of events divided by 3, because I want to have 3 elements in each cell of the collection view that are going to be displayed by the table view inside the collection view.
 */

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.fullView)
    {
        return self.groupedEvents.count;
    }else
    {
    int numberOfItems = floor(self.groupedEvents.count / 3) - 1;
        
    return numberOfItems;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
}



@end

