//
//  SignUpViewController.m
//  ProjectX
//
//  Created by aadhya on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
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
    self.passwordField.textContentType = UITextContentTypeNewPassword;
    self.passwordField.passwordRules = [UITextInputPasswordRules passwordRulesWithDescriptor: @"required: upper; required: digit; max-consecutive: 2; minlength: 6;"];
    self.secondPasswordField.delegate = self;
    self.secondPasswordField.textContentType = UITextContentTypeNewPassword;
    self.lastName.delegate = self;
    
}

#pragma mark - Design

-(void) buttonsDesign
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text  isEqualToString: @""])
    {
        return false;
    }else if (textField == self.usernameField)
    {
        [textField resignFirstResponder];
        [self.lastName becomeFirstResponder];
        return YES;
    }else if (textField == self.lastName)
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

    if([self verifyPasswords: self.passwordField.text :self.secondPasswordField.text])
    {
    // call sign up function on the object
    [[FIRAuth auth] createUserWithEmail:self.emailField.text
                                   password:self.passwordField.text
                                 completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error)
        {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self displayAlert:@"Error" :error.localizedDescription];
            }else
            {
                NSLog(@"User registered successfully");
                [[[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid] setData:@{
                  @"firstName": self.usernameField.text,
                  @"email": self.emailField.text,
                  @"lastName" : self.lastName.text
                  } completion:^(NSError * _Nullable error) {
                     if (error != nil)
                     {
                          NSLog(@"Error writing document: %@", error);
                     }else
                     {
                         NSLog(@"Document successfully written!");
                         AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                         SignUpViewController *SignUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                         appDelegate.window.rootViewController = SignUpViewController;
                     }
                }];
                
        }
    }];
    }else
    {
        [self displayAlert:@"Error" :@"Please try with a password with more than 6 characters"];
    }
}

 -(BOOL) verifyPasswords : (NSString *) passwordOne : (NSString *) passwordTwo
 {
     return (passwordOne.length > 5 && passwordOne == passwordTwo);
 }


-(void) displayAlert : (NSString *) title : (NSString *) subtitle
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:subtitle preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:acceptAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)shutKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
