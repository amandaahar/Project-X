//
//  SignUpViewController.m
//  ProjectX
//
//  Created by aadhya on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "SignUpViewController.h"
#import "../Helpers/AppColors.h"
@import MaterialTextField;
@import Firebase;
@import CoreLocation;
@interface SignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MFTextField *usernameField;
@property (weak, nonatomic) IBOutlet MFTextField *emailField;
@property (weak, nonatomic) IBOutlet MFTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) FIRAuth *handle;
@property (strong, nonatomic, readwrite) FIRFirestore *db;
@property (weak, nonatomic) IBOutlet MFTextField *secondPasswordField;
@property (weak, nonatomic) IBOutlet MFTextField *lastName;
@property (weak, nonatomic) IBOutlet MFTextField *username;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (weak, nonatomic) IBOutlet UISwitch *acceptTerms;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.db = [FIRFirestore firestore];
    self.usernameField.delegate = self;
    self.passwordField.textContentType  = UITextContentTypeName;
    self.emailField.delegate = self;
    self.emailField.textContentType  = UITextContentTypeEmailAddress;
    self.passwordField.delegate = self;
    self.username.delegate = self;
    self.username.textContentType = UITextContentTypeUsername;
    self.passwordField.textContentType = UITextContentTypeNewPassword;
    self.passwordField.passwordRules = [UITextInputPasswordRules passwordRulesWithDescriptor: @"required: upper; required: digit; max-consecutive: 2; minlength: 6;"];
    self.secondPasswordField.delegate = self;
    self.secondPasswordField.textContentType = UITextContentTypeNewPassword;
    self.lastName.delegate = self;
    self.signUpButton.layer.borderWidth = 1;
    self.signUpButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.signUpButton.layer.cornerRadius = 15;
    [self.signUpButton setClipsToBounds:YES];
    self.gradient = [[AppColors sharedManager] getGradientDefault:self.view];
    [self.view.layer insertSublayer:self.gradient atIndex:0];
    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.gradient.frame = self.view.bounds;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Design

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text  isEqualToString: @""])
    {
        return false;
    } else if (textField == self.usernameField)
    {
        [textField resignFirstResponder];
        [self.lastName becomeFirstResponder];
        return YES;
    } else if (textField == self.lastName)
    {
        [textField resignFirstResponder];
        [self.username becomeFirstResponder];
        return YES;
        
    } else if (textField == self.username)
    {
        [textField resignFirstResponder];
        [self.emailField becomeFirstResponder];
        return YES;
    } else if (textField == self.emailField)
    {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
        return YES;
    } else if (textField == self.passwordField)
    {
        [textField resignFirstResponder];
        [self.secondPasswordField becomeFirstResponder];
        return YES;
    } else if (textField == self.secondPasswordField)
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}



- (void)viewWillAppear:(BOOL)animated {
    self.handle =
        [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[FIRAuth auth] removeAuthStateDidChangeListener:self.handle];
}

- (IBAction)signUpUser:(id)sender {
    // initialize a user object

    if(self.acceptTerms.isOn){
        if([self verifyPasswords: self.passwordField.text passwordTwo:self.secondPasswordField.text])
        {
        // call sign up function on the object
        [[FIRAuth auth] createUserWithEmail:self.emailField.text
                                   password:self.passwordField.text
                                 completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error)
            {
                if (error != nil) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    [self displayAlert:@"Error" subtitle:error.localizedDescription];
                }else
                {
                    NSString * language = [[NSLocale preferredLanguages] firstObject];
                    if([language containsString:@"-"])
                    {
                        NSRange range = [language rangeOfString:@"-"];
                        NSString *newString = [language substringToIndex:range.location];
                        language = newString;
                    }
                    NSLog(@"User registered successfully");
                
                    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                                        NSError * _Nullable error) {
                        if (error != nil) {
                            [[[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] setData:@{ @"firstName": self.usernameField.text,
                                                                                                       @"email": self.emailField.text,
                                                                                                    @"lastName" : self.lastName.text,
                                                                                                    @"username" : self.username.text,
                                                                                                         @"lan": language,
                                                                                                        @"bio" : @"",
                                                                                                        @"fcm" : @"",
                                                                                                  @"profileImage" : @"https://profiles.utdallas.edu/img/default.png"
                                                                                                     } completion:^(NSError * _Nullable error) {
                                                                                                                                 if (error != nil)
                                                                                                                                 {
                                                                                                                                     NSLog(@"Error writing document: %@", error);
                                                                                                                                 } else
                                                                                                                                 {
                                                                                                                                     NSLog(@"Document successfully written!");
                                                                                                                                     [self performSegueWithIdentifier:@"preferences" sender:self];
                                                                                                                                 }
                                                                                                     }];
                        } else {
                            NSLog(@"Remote instance ID token: %@", result.token);
                            [[[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] setData:@{ @"firstName": self.usernameField.text,
                                                                                                                              @"email": self.emailField.text,
                                                                                                                              @"lastName" : self.lastName.text,
                                                                                                                              @"username" : self.username.text,
                                                                                                                              @"lan": language,
                                                                                                                              @"bio" : @"",
                                                                                                                              @"fcm" : result.token,
                                                                                                                              @"profileImage" : @"https://profiles.utdallas.edu/img/default.png"
                                                                                                                              } completion:^(NSError * _Nullable error) {
                                                                                                                                  if (error != nil)
                                                                                                                                  {
                                                                                                                                      NSLog(@"Error writing document: %@", error);
                                                                                                                                  } else
                                                                                                                                  {
                                                                                                                                      NSLog(@"Document successfully written!");
                                                                                                                                      [self performSegueWithIdentifier:@"preferences" sender:self];
                                                                                                                                  }
                                                                                                                              }];
                           
                        }
                       
                    }];
                    
            }
        }];
        } else
        {
            [self displayAlert:@"Error" subtitle:@"Please try with a password with more than 6 characters"];
        }
    }else{
         [self displayAlert:@"Error" subtitle:@"Please accept terms and conditions"];
    }
    
    
        
}

- (BOOL)verifyPasswords:(NSString *)passwordOne passwordTwo:(NSString *)passwordTwo
 {
     NSLog(@"%@",passwordOne);
     NSLog(@"%@",passwordTwo);
     return (passwordOne.length > 5 && [passwordOne isEqualToString: passwordTwo]);
 }


- (void)displayAlert:(NSString *)title subtitle:(NSString *)subtitle
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:subtitle preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:acceptAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)showTermsAndConditions:(UIButton *)sender {
}


- (IBAction)shutKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
