//
//  ShowInterestsTableViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ShowInterestsTableViewCell.h"
#import "InterestCollectionViewCell.h"
#import "EditProfileViewController.h"
#import "../Models/FirebaseManager.h"


@interface  ShowInterestsTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) User *currentUser;
@property (strong, nonatomic) EditProfileViewController *editProfileController;


@end

@implementation ShowInterestsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    self.interestsCollectionView.dataSource = self;
    self.interestsCollectionView.delegate = self;
    [self.interestsCollectionView registerNib:[UINib nibWithNibName:@"InterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"interestCollectionViewCell"];
    
    
    
    [self getInterests];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.interestsCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(120, 25);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 10;
    
    //CGFloat height = self.interestsCollectionView.col
    //layout.collectionViewContentSize.height = (self.interestsArray.count + 3 - 1) / 3;
    
//    [self.interestsCollectionView reloadData];
    
    //self.interestsArray = [[EditProfileViewController alloc] init].usersInterests;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) getInterests {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting current user for cell");
        } else {
            self.currentUser = user;
            self.interestsArray = self.currentUser.preferences;
            
            //self.interestsArray = self.editProfileController.usersInterests;
            [self.interestsCollectionView reloadData];
        }
    }];
    
}
    





- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCollectionViewCell" forIndexPath:indexPath];
    
    cell.interestsLabel.text = [[self.interestsArray[indexPath.item][@"short_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.interestsArray.count;
}



@end
