//
//  EditProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EditProfileViewController.h"
#import "../Models/FirebaseManager.h"


@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *editedProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *bioText;
@property (weak, nonatomic) IBOutlet UITextField *interests;
@property (strong, nonatomic) NSMutableArray *interestsCategories;
@property (strong, nonatomic) NSMutableArray *usersInterests;
@property (weak, nonatomic) NSString *selectedRowText;
@property (strong, nonatomic) UIPickerView *interestsPicker;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (weak, nonatomic) NSString *profileImageString;

@end

@implementation EditProfileViewController
UIToolbar *interestsToolBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCurrentProperties];
    self.db = [FIRFirestore firestore];
    
    [self.tabBarController.tabBar setHidden: YES];
    // [self.usersInterests alloc] init];
    self.usersInterests = [[NSMutableArray alloc] init];
    
    //UIPickerView *interestsPicker = [[UIPickerView alloc]init];
    self.interestsPicker = [[UIPickerView alloc]init];
    self.interestsPicker.delegate = self;
    self.interestsPicker.dataSource = self;
    
    //set up picker view toolbar with Done button
    interestsToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,30)];
    [interestsToolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *doneButton = [self setUpDoneButton];
    interestsToolBar.items = @[doneButton];

    self.interests.inputView = self.interestsPicker;
    self.interests.inputAccessoryView = interestsToolBar;
    self.interestsCategories = [[NSMutableArray alloc] initWithObjects:@"hiking", @"fishing", @"music", nil];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [interestsToolBar setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    [self.interests setInputAccessoryView:interestsToolBar];

}

- (IBAction)didTapSave:(id)sender {
    //NSString * profilePicURL = [self imageStorage];
    //NSURL * profilePicURL =
    //[[NSURL alloc] initWithString:[self imageStorage].absoluteString];
    [self imageStorage] ;
    
    
    
}

- (void)setUpCurrentProperties {
    //__block User *currentUser = [[User alloc]init];
    
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting current user for profile");
        } else {
            self.currentUser = user;
            
            NSURL *imageURL = [NSURL URLWithString:self.currentUser.profileImageURL];
            
            self.firstNameText.text = self.currentUser.firstName;
            self.lastNameText.text = self.currentUser.lastName;
            self.bioText.text = self.currentUser.bio;
            [self.editedProfileImage setImageWithURL:imageURL];
            
        }
    }];
}

- (void)doneCategoryPicker: (UIButton *) button {
    [self.usersInterests addObject:self.selectedRowText];
    self.interests.text = [self.usersInterests componentsJoinedByString:@"\n,"];
    [self.interestsPicker removeFromSuperview];
    [interestsToolBar setHidden:YES];
    [self.interests endEditing:YES];
    
}

-(UIBarButtonItem *) setUpDoneButton {
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneCategoryPicker:)];
    
    barButtonDone.style = UIBarButtonItemStyleDone;
    barButtonDone.tintColor = [UIColor blueColor];
    
    return barButtonDone;
    
}

- (IBAction)changeProfileImageButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    else {
        NSLog(@"Camera unavailable so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (void) updateUserProperties {
    FIRDocumentReference *userRef = [[self.db collectionWithPath:@"Users"] documentWithPath:self.currentUser.userID];
    [userRef updateData:
     @{
       @"firstName": self.firstNameText.text,
       @"lastName": self.lastNameText.text,
       @"bio": self.bioText.text,
       @"preferences": self.usersInterests,
       @"profileImage": self.profileImageString,
       } completion:^(NSError * _Nullable error) {
           if (error != nil) {
               NSLog(@"Error updating document: %@", error);
           } else {
               NSLog(@"Docuement updated from edit profile");
           }
       }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];//Do I really need this
    
    self.editedProfileImage.image = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    //    [self imageStorage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *) imageStorage {
    
    FIRStorage *storage = [FIRStorage storage];
    NSUUID *randomID = [[NSUUID alloc] init];
    FIRStorageReference *storageRef = [storage referenceWithPath:[@"profileImages/" stringByAppendingString:[NSString stringWithFormat: @"%@", randomID.description, @".jpg"]]];
    //NSURL *localFile = [NSURL URLWithString:[NSString stringWithFormat:@"%@", storageRef]];
    NSData *data = UIImageJPEGRepresentation(self.editedProfileImage.image, 0.75);
    //FIRStorageReference *eventImagesRef = [storageRef child:@"images/mountains.jpg"];
    FIRStorageMetadata *uploadMetaData = [[FIRStorageMetadata alloc] init];
    uploadMetaData.contentType = @"image/jpeg";
    __block NSURL *downloadURL = [[NSURL alloc] init];
    
    FIRStorageUploadTask *uploadTask = [storageRef putData:data metadata:uploadMetaData completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            NSLog(@"Uh-oh, first error occurred!");
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            int size = metadata.size;
            // You can also access to download URL after upload.
            [storageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Uh-oh, second error occurred!");
                } else {
                    downloadURL = URL;
                    self.profileImageString = downloadURL.absoluteString;
//                    NSURL *downloadURL = URL;
                    NSLog(@"Here is your downloaded URL: %@", downloadURL);
                    NSLog(@" here is image url%@", self.profileImageString);
                    
                    [self updateUserProperties];
                }
            }];
        }
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload completed successfully
        NSLog(@"Picture sending success!");
    }];
    
    return downloadURL.absoluteString;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    NSInteger numComponents = 1;
    return numComponents;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.interestsCategories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.interestsCategories[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [interestsToolBar setHidden:NO];
    self.selectedRowText = self.interestsCategories[row];
}

@end
