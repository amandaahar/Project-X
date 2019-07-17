//
//  EditProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *interestsPicker;
@property (weak, nonatomic) IBOutlet UIImageView *editedProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *bioText;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSave:(id)sender {
    
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
