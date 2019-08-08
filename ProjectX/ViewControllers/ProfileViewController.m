//
//  ProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "LogInViewController.h"
#import "../AppDelegate.h"
#import "../Models/FirebaseManager.h"
#import "ProfileHeaderCollectionReusableView.h"
#import "AppColors.h"
#import <AVFoundation/AVAudioPlayer.h>

@import Firebase;
@import SAMKeychain;
@interface ProfileViewController () < UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *preferences;
@property (weak, nonatomic) IBOutlet UILabel *bioText;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, strong) User *currentUser;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CAGradientLayer *gradient;
@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden: NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.gradient = [[AppColors sharedManager] getGradientPurple:self.navigationController.navigationBar];
//    [self.navigationController.navigationBar.layer insertSublayer:self.gradient atIndex:1];
//    
    self.interestsCollectionView.delegate = self;
    self.interestsCollectionView.dataSource = self;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.interestsCollectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 5;
    
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.interestsCollectionView.collectionViewLayout;
//    layout.itemSize = CGSizeMake(120, 25);
//    layout.minimumInteritemSpacing = 2;
//    layout.minimumLineSpacing = 10;
    
    //[self.interestsCollectionView br]
     [self setup];
    
    
  
    
}


- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.gradient.frame = self.navigationController.navigationBar.bounds;
}


- (void) setup {
    
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil)
        {
            
        } else
        {
            self.currentUser = user;
            
            [self.interestsCollectionView reloadData];
        }
    }];
    
    
}


-(void) setImage: (NSString *) photoURL {
    NSURL *imageURL = [NSURL URLWithString:photoURL];
    [self.profilePictureImage setImageWithURL:imageURL];
}

#pragma mark - Log Out

- (IBAction)logOut:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                            }];
        
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSError *signOutError;
                                                           NSString *idUser = FIRAuth.auth.currentUser.uid;
                                                           BOOL status = [[FIRAuth auth] signOut:&signOutError];
                                                           if (!status) {
                                                               NSLog(@"Error signing out: %@", signOutError);
                                                               return;
                                                           }else{
                                                               
                                                               [[FirebaseManager sharedManager] removeFCMDeviceToUser:idUser];
                                                               AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                               LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogIn"];
                                                               appDelegate.window.rootViewController = loginViewController;
                                                               NSLog(@"Successfully Signout");
                                                           }
                                                         }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
        }];
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InterestsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestsCell" forIndexPath:indexPath];
    
    //NSString *interest = [self.currentUser.preferences[indexPath.item][@"short_name"] componentsJoinedByString:@" "]
    
    NSString *interest = [[self.currentUser.preferences[indexPath.item][@"short_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    [cell setInterestLabelText:interest];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numOfInterests = self.currentUser.preferences.count;
    return numOfInterests;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ProfileHeaderCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
    
    [reusableView setProfileImageWithURL:self.currentUser.profileImageURL];
    [reusableView setNameText:[[self.currentUser.firstName stringByAppendingString:@" "] stringByAppendingString:self.currentUser.lastName]];
    
    
    [reusableView getFollowLabel].backgroundColor = [[AppColors sharedManager] getBlueBackground];
    [reusableView getFollowLabel].textColor = [UIColor whiteColor];
    [reusableView getMessageLabel].textColor = [[AppColors sharedManager] getBlueBackground];
    [reusableView getMessageLabel].layer.borderColor = [[AppColors sharedManager] getBlueBackground].CGColor;
    [reusableView getMessageLabel].layer.borderWidth = 1.5;
    
    
    
    NSString *atSymbol = @"@";
    if (self.currentUser.username != nil){
        NSString *usernameText = [atSymbol stringByAppendingString:self.currentUser.username];
        [reusableView setUsernameText: usernameText];
    } else {
        [reusableView setUsernameText: self.currentUser.username];
    }
    
    [reusableView setBioText:self.currentUser.bio];
    
    return reusableView;
    
    
}



@end
