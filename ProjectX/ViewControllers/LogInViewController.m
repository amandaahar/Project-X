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
#import "MainTabBarController.h"
#import "../Models/FirebaseManager.h"
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
@property (weak, nonatomic) IBOutlet MFTextField *passwordField;
@property (strong, nonatomic) LAContext *context;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.loginButton.layer.cornerRadius = 15;
    self.loginButton.clipsToBounds = YES;
    self.context = [[LAContext alloc] init];
    NSError *error = [[NSError alloc] init];
    [self.context setLocalizedCancelTitle:@"Enter mail and password"];
    [self.context canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
    
    
     NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"mail"];
       if(savedValue != nil){
         [self.context evaluatePolicy:kLAPolicyDeviceOwnerAuthentication localizedReason:@"Log into your account" reply:^(BOOL success, NSError * _Nullable error) {
                if(success){
                NSString * password = [SAMKeychain passwordForService:@"password" account:savedValue];
                [self logInWithUser:savedValue andPassword:password];
            }  }];
        }
          
    
  
    //[[APIEventsManager sharedManager] getCategories];
    // Do any additional setup after loading the view.
}
/// The available states of being logged in or not.
enum AuthenticationState {
 loggedin, loggedout
};

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

-(void) logInWithUser: (NSString * )username andPassword: (NSString *) password{
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
