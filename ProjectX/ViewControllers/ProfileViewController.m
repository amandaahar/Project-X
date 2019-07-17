//
//  ProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ProfileViewController.h"
#import "../Models/FirebaseManager.h"
#import "UIImageView+AFNetworking.h"
@import Firebase;
//@class FirebaseManager;
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *preferences;
@property (weak, nonatomic) IBOutlet UILabel *bioText;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = [FIRFirestore firestore];
    
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil)
        {
            
        }else
        {
            self.currentUser = user;
            NSLog(@"%@",user.username);
            
            self.nameText.text = [[self.currentUser.firstName stringByAppendingString:@" "] stringByAppendingString:self.currentUser.lastName];
            
            self.username.text = self.currentUser.username;
            
            [self setImage:self.currentUser.profileImageURL];
            
            for (NSString *category in self.currentUser.preferences) {
                // NSString *interestsString = [[NSString alloc] init];
                // self.preferences.text = @"";
                self.preferences.text = [[self.preferences.text stringByAppendingString:@" "] stringByAppendingString:category];
                
            }
            
            
        }
    }];
    
    
    
     
    /*
    for (NSString *category in self.currentUser.preferences) {
        
        
    }
     */
    
    
    

}
- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"editProfileSegue" sender:nil];
    
}

-(void) setImage: (NSString *) photoURL {
    NSURL *imageURL = [NSURL URLWithString:photoURL];
    [self.profilePictureImage setImageWithURL:imageURL];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
