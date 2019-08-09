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


@interface  ShowInterestsTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) User *currentUser;
@property (strong, nonatomic) EditProfileViewController *editProfileController;
@property (strong, nonatomic) NSIndexPath *indexPathForCellToDelete;
@property (strong, nonatomic) UIColor *initialInterestLabelBackgroundColor;
@property (strong, nonatomic) UIButton *deleteButton;
@end

@implementation ShowInterestsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestsDidChange:) name:@"interestsAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestWasDeleted:) name:@"interestDeleted" object:nil];
    
    
    
    self.interestsCollectionView.dataSource = self;
    self.interestsCollectionView.delegate = self;
    [self.interestsCollectionView registerNib:[UINib nibWithNibName:@"InterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"interestCollectionViewCell"];
    
    [self getInterests];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.interestsCollectionView.collectionViewLayout;
    
    layout.itemSize = CGSizeMake(120, 25);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 10;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    [self.interestsCollectionView addGestureRecognizer:longPress];
    
}

- (void)handleLongPress: (UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint pointPressed = [gestureRecognizer locationInView:self.interestsCollectionView];
    NSIndexPath *indexPath = [self.interestsCollectionView indexPathForItemAtPoint:pointPressed];
    
    
    InterestCollectionViewCell *oldCell = [self.interestsCollectionView cellForItemAtIndexPath:self.indexPathForCellToDelete];
    oldCell.interestsLabel.backgroundColor = self.initialInterestLabelBackgroundColor;// .backgroundColor = [UIColor purpleColor];
    [oldCell stopShaking];
    [oldCell.deleteButton setHidden:YES];
    
    if (indexPath == nil) {
        NSLog(@"did not find cell");
    } else {
        NSLog(@"GOT THE CELL!!!");
        
        
    
        InterestCollectionViewCell *selectedCell = [self.interestsCollectionView cellForItemAtIndexPath:indexPath];
        self.initialInterestLabelBackgroundColor = [[UIColor alloc] initWithCGColor:selectedCell.interestsLabel.backgroundColor.CGColor];
    
        [selectedCell.deleteButton setHidden:NO];
        [selectedCell shake];
    
        self.indexPathForCellToDelete = indexPath;
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)getInterests {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting current user for cell");
        } else {
            self.currentUser = user;
            self.interestsArray = self.currentUser.preferences;
            
            [self.interestsCollectionView reloadData];
        }
    }];
    
}

- (void)interestsDidChange:(NSNotification *)notification {
    [self.interestsArray addObject: notification.userInfo[@"newInterest"]];
    [self.interestsCollectionView reloadData];
    
}

- (void)interestWasDeleted:(NSNotification *)notification {
    NSDictionary *interestToRemove = self.interestsArray[self.indexPathForCellToDelete.item];
    [self.interestsArray removeObject:interestToRemove];
    [self.interestsCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"interestRemovedNotification"
                                                        object:nil
                                                      userInfo:@{@"removedInterest": interestToRemove}];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCollectionViewCell" forIndexPath:indexPath];
    
    cell.interestsLabel.text = [[self.interestsArray[indexPath.item][@"short_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    [cell.deleteButton setHidden:YES];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.interestsArray.count;
}



@end
