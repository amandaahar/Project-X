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
//@property (weak, nonatomic) IBOutlet UIPickerView *interestsPicker;
@property (weak, nonatomic) IBOutlet UIImageView *editedProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *bioText;
@property (weak, nonatomic) IBOutlet UITextField *interests;
@property (strong, nonatomic) NSMutableArray *interestsCategories;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPickerView *interestsPicker = [[UIPickerView alloc]init];
    
    [self.tabBarController.tabBar setHidden: YES];
    
    interestsPicker.delegate = self;
    interestsPicker.dataSource = self;
    self.interests.inputView = interestsPicker;
    self.interestsCategories = [[NSMutableArray alloc] initWithObjects:@"hiking", @"fishing", @"music", nil];
    
}

- (IBAction)didTapSave:(id)sender {
    [self imageStorage];
    
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

- (void) imageStorage {
    
    FIRStorage *storage = [FIRStorage storage];
    NSUUID *randomID = [[NSUUID alloc] init];
    FIRStorageReference *storageRef = [storage referenceWithPath:[@"profileImages/" stringByAppendingString:[NSString stringWithFormat: @"%@", randomID.description, @".jpg"]]];
    //NSURL *localFile = [NSURL URLWithString:[NSString stringWithFormat:@"%@", storageRef]];
    NSData *data = UIImageJPEGRepresentation(self.editedProfileImage.image, 0.75);
    //FIRStorageReference *eventImagesRef = [storageRef child:@"images/mountains.jpg"];
    FIRStorageMetadata *uploadMetaData = [[FIRStorageMetadata alloc] init];
    uploadMetaData.contentType = @"image/jpeg";
    
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
                    NSURL *downloadURL = URL;
                    NSLog(@"Here is your downloaded URL: %@", downloadURL);
                }
            }];
        }
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload completed successfully
        NSLog(@"Picture sending success!");
    }];
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
    NSInteger *numComponents = 1;
    return numComponents;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.interestsCategories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.interestsCategories[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.interests.text = self.interestsCategories[row];
}

@end
