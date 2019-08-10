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
#import "../Helpers/AppColors.h"
#import "MainTabBarController.h"
#import "../Models/FirebaseManager.h"
#import <QuartzCore/QuartzCore.h>
#import <ProjectX-Swift.h>
#import <Pastel-Swift.h>
@import SAMKeychain;
@import Firebase;
@import MaterialTextField;
@import LocalAuthentication;
struct KeychainConfiguration {
     NSString *serviceName;
    NSString *accessGroup;
};
@interface LogInViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MFTextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet MFTextField *passwordField;
@property (strong, nonatomic) LAContext *context;
@end

@implementation LogInViewController
CAGradientLayer *gradient;
- (void)viewDidLoad {
    [super viewDidLoad];
    PastelView *pastelView = [[PastelView alloc] initWithFrame:self.view.bounds];
    
    [pastelView startAnimation];
    [self.view insertSubview:pastelView atIndex:0];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.loginButton.layer.cornerRadius = 15;
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginButton.layer.borderWidth = 1;
    self.signUpButton.layer.cornerRadius = 15;
    self.signUpButton.layer.borderWidth = 1;
    self.signUpButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.signUpButton.clipsToBounds = YES;
    self.context = [[LAContext alloc] init];
    NSError *error = [[NSError alloc] init];
    [self.context setLocalizedCancelTitle:@"Enter mail and password"];
    [self.context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
    
    gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[[AppColors sharedManager] getDarkPurple].CGColor, (id)[[AppColors sharedManager]  getDarkBlue].CGColor];
    [gradient layoutIfNeeded];
    [gradient setNeedsDisplay];

    //[self.view.layer insertSublayer:gradient atIndex:0];
    
  
    // Do any additional setup after loading the view.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    gradient.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


/// The available states of being logged in or not.
enum AuthenticationState {
 loggedin, loggedout
};
- (IBAction)touchIDLogIn:(id)sender {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"mail"];
    if(savedValue != nil){
        [self.context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:@"Log into your account" reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSString * password = [SAMKeychain passwordForService:@"password" account:savedValue];
                [self logInWithUser:savedValue andPassword:password];
            }  }];
    }
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
            [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                                NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error fetching remote instance ID: %@", error);
                } else {
                    NSLog(@"Remote instance ID token: %@", result.token);
                    NSString* message =
                    [NSString stringWithFormat:@"Remote InstanceID token: %@", result.token];
                    NSLog(@"%@",message);
                    [[FirebaseManager sharedManager] addFCMDeviceToUSer:result.token];
                }
                 [SAMKeychain setPassword:password forService:@"password" account:username];
           
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"mail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainTabBarController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                appDelegate.window.rootViewController = loginViewController;
            }];
           
        }
    }];
}

- (void)logInWithUser: (NSString * )username andPassword: (NSString *) password{
    [[FIRAuth auth] signInWithEmail:username
                           password:password
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
                             if (error != nil) {
                                 NSLog(@"User log in failed: %@", error.localizedDescription);
                             } else {
                                 NSLog(@"User logged in successfully");
                                 [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                                                     NSError * _Nullable error) {
                                     if (error != nil) {
                                         NSLog(@"Error fetching remote instance ID: %@", error);
                                     } else {
                                         NSLog(@"Remote instance ID token: %@", result.token);
                                         NSString* message =
                                         [NSString stringWithFormat:@"Remote InstanceID token: %@", result.token];
                                         NSLog(@"%@",message);
                                         [[FirebaseManager sharedManager] addFCMDeviceToUSer:result.token];
                                     }
                                     [SAMKeychain setPassword:password forService:@"password" account:username];
                                     
                                     [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"mail"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     MainTabBarController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                                     appDelegate.window.rootViewController = loginViewController;
                                 }];
                                 
                             }
                         }];
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text  isEqualToString: @""])
    {
        return false;
    } else if (textField == self.usernameField)
    {
        [textField resignFirstResponder];
        return YES;
    }else
    {
        [self.passwordField becomeFirstResponder];
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

- (IBAction)shutKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
