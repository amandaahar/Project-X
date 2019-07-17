//
//  ProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ProfileViewController.h"
@import Firebase;

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *preferences;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = [FIRFirestore firestore];
    
    FIRDocumentReference *docRef =
    [[self.db collectionWithPath:@"Users"] documentWithPath:@"DAhDAxEMoJNpOcjkaWe1cyevl9v2"];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            NSLog(@"Document data: %@", snapshot.data);
        } else {
            NSLog(@"Document does not exist");
        }
    }];
    
    NSLog(@"%@", docRef);
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
