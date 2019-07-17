//
//  SignUpViewController.m
//  ProjectX
//
//  Created by aadhya on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
@import Firebase;

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) FIRAuth *handle;
@property (strong, nonatomic, readwrite) FIRFirestore *db;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.db = [FIRFirestore firestore];
}

- (void) viewWillAppear:(BOOL)animated {
    self.handle = [[FIRAuth auth]
        addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
        }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[FIRAuth auth] removeAuthStateDidChangeListener:self.handle];
}

- (IBAction)signUpUser:(id)sender {
    // initialize a user object
    
//    FIRUser *newUser = [FIRUser user];
//
//    // set user properties
//    newUser.username = self.usernameField.text;
//    newUser.email = self.emailField.text;
//    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [[FIRAuth auth] createUserWithEmail:self.emailField.text
                               password:self.passwordField.text
                             completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [[[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] setData:@{
                                                                                       @"username": self.usernameField.text,
                                                                                       @"email": self.emailField.text
                                                                                       } completion:^(NSError * _Nullable error) {
                                                                                           if (error != nil) {
                                                                                               NSLog(@"Error writing document: %@", error);
                                                                                           } else {
                                                                                               NSLog(@"Document successfully written!");
                                                                                               AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                               SignUpViewController *SignUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                                                                                               appDelegate.window.rootViewController = SignUpViewController;
                                                                                           }
                                                                                       }];
             /*if (user) {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                NSString *uid = self.user.uid;
                NSString *email = user.email;
                NSURL *photoURL = user.photoURL;
            }
              */
        }
    }];
}

- (IBAction)shutKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
