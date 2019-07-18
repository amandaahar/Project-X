//
//  LogInViewController.m
//  ProjectX
//
//  Created by aadhya on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "LogInViewController.h"
#import "AppDelegate.h"
#import "../Models/APIEventsManager.h"
@import Firebase;

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logInUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [[FIRAuth auth] signInWithEmail:username
                           password:password
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}
- (void)viewDidAppear:(BOOL)animated
{
    if(FIRAuth.auth.currentUser != nil)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LogInViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        appDelegate.window.rootViewController = loginViewController;
    }
}


- (IBAction)shutKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
