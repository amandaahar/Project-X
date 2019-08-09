//
//  EditProfileViewController.m
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileTableViewCell.h"
#import "../Models/FirebaseManager.h"
#import "ShowInterestsTableViewCell.h"
#import "InterestFieldTableViewCell.h"
#import "InterestFieldTableViewCell.h"
@import MaterialTextField;


@interface EditProfileViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) UIImage *profilePhoto;
@property (strong, nonatomic) NSArray *interestsCategories;
@property (strong, nonatomic) NSMutableArray *usersInterests;
@property (strong, nonatomic) NSMutableArray *pickerViewRowTitles;
@property (weak, nonatomic) NSString *selectedRowText;
@property (weak, nonatomic) NSDictionary *selectedRowDictRef;
@property (strong, nonatomic) UIPickerView *interestsPicker;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (weak, nonatomic) NSString *profileImageString;
@property (weak, nonatomic) IBOutlet UITableView *editProfileTableView;

@end

@implementation EditProfileViewController
UIToolbar *interestsToolBar;
NSString *cell0 = @"cell0";
NSString *cell1 = @"cell1";
NSString *cell2 = @"cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usersInterests = [[NSMutableArray alloc] init];
    [self setUpCurrentProperties];
    self.db = [FIRFirestore firestore];
    
    [self.tabBarController.tabBar setHidden: YES];
    
    
    self.editProfileTableView.dataSource = self;
    self.editProfileTableView.delegate = self;
    
    // notifications so xibs can communicate with this view controller
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstNameDidChange:) name:@"firstNameNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastNameDidChange:) name:@"lastNameNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bioDidChange:) name:@"bioNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interestRemoved:) name:@"interestRemovedNotification" object:nil];
    
    
    // make the tableview lines go away
    self.editProfileTableView.separatorColor = [UIColor clearColor];
    
    [self.editProfileTableView registerNib:[UINib nibWithNibName:@"EditProfileTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cell0];
    
    [self.editProfileTableView registerNib:[UINib nibWithNibName:@"InterestFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cell1];
    
    [self.editProfileTableView registerNib:[UINib nibWithNibName:@"ShowInterestsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cell2];
    
    //initialize interest picker
    self.interestsPicker = [[UIPickerView alloc]init];
    self.interestsPicker.delegate = self;
    self.interestsPicker.dataSource = self;
    
    //set up picker view toolbar with Done button
    interestsToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,30)];
    [interestsToolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *doneButton = [self setUpDoneButton];
    interestsToolBar.items = @[doneButton];

    [self fetchCategories];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [interestsToolBar setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
}


#pragma mark - Set up view

- (IBAction)tapGestureForKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)setUpCurrentProperties {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting current user for profile");
        } else {
            self.currentUser = user;
            
            
            NSURL *imageURL = [NSURL URLWithString:self.currentUser.profileImageURL];
            
            
            self.firstName = self.currentUser.firstName;
            self.lastName = self.currentUser.lastName;
            self.bio = self.currentUser.bio;
            self.usersInterests = self.currentUser.preferences;
            self.profileImageString = self.currentUser.profileImageURL;
            
            UIImageView *profilePhotoPlaceholder = [[UIImageView alloc]init];
            [profilePhotoPlaceholder setImageWithURL:imageURL];
            self.profilePhoto = profilePhotoPlaceholder.image;
            
            [self.editProfileTableView reloadData];
        }
    }];
}

- (void)fetchCategories {
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        if(error == nil)
        {
            
            self.interestsCategories = categories;
            self.selectedRowDictRef = self.interestsCategories[0];
        }
    }];
}


# pragma mark UITableView Data Source initializations

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return 3: the text field section, the add interest button and the interested
    // collection view in a cell.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        EditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //NSURL *imageURL = [NSURL URLWithString:self.profileImageString];
        cell.profileView.image = self.profilePhoto;
        cell.firstName.text = self.firstName;
        cell.lastName.text = self.lastName;
        cell.bio.text = self.bio;
        
        //add action to change profile button in cell
        [cell.changePhotoButton addTarget:self action:@selector(changeProfileImageButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        InterestFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.addInterestsField.inputView = self.interestsPicker;
        cell.addInterestsField.inputAccessoryView = interestsToolBar;
        
        return cell;
    } else {
        ShowInterestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // makes collection view grow as content grows
        cell.frame = tableView.bounds;
        [cell layoutIfNeeded];
        [cell.interestsCollectionView layoutIfNeeded];
        [cell.interestsCollectionView reloadData];
        cell.collectionViewHeight.constant = cell.interestsCollectionView.collectionViewLayout.collectionViewContentSize.height;
        
        return cell;
        
    }
}


- (void)doneCategoryPicker:(UIButton *)button {
    if (! [self.usersInterests containsObject:self.selectedRowDictRef]) {
        [self.usersInterests addObject:self.selectedRowDictRef];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"interestsAdded" object:nil userInfo:@{@"newInterest": self.selectedRowDictRef}];
    }
    
    [self.editProfileTableView reloadData];
    [self.interestsPicker removeFromSuperview];
    
}



#pragma mark - Update info

- (void)updateUserProperties {
    FIRDocumentReference *userRef = [[self.db collectionWithPath:@"Users"] documentWithPath:self.currentUser.userID];
    [userRef updateData:
     @{
       @"firstName": self.firstName,
       @"lastName": self.lastName,
       @"bio": self.bio,
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

- (NSString *)updateDocument {
    FIRStorage *storage = [FIRStorage storage];
    NSUUID *randomID = [[NSUUID alloc] init];
    FIRStorageReference *storageRef = [storage referenceWithPath:[@"profileImages/" stringByAppendingString:[NSString stringWithFormat: @"%@", randomID.description, @".jpg"]]];
    //NSURL *localFile = [NSURL URLWithString:[NSString stringWithFormat:@"%@", storageRef]];
    NSData *data = UIImageJPEGRepresentation(self.profilePhoto, 0.75);
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

- (IBAction)didTapSave:(id)sender {
    
    [self updateDocument];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Handle When User changes profile image

// action for when change profile button is pressed on first cell of editProfile table view
- (void)changeProfileImageButton:(UIButton *)button {
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
    self.profilePhoto = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoChangeNotification"
                                                        object:nil
                                                      userInfo:@{@"newPhoto": self.profilePhoto}];
    
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

#pragma mark - Notification methods

- (void)firstNameDidChange: (NSNotification *)notification {
    self.firstName = notification.userInfo[@"firstName"];
    [self.editProfileTableView reloadData];
}

- (void)lastNameDidChange: (NSNotification *)notification {
    self.lastName = notification.userInfo[@"lastName"];
    [self.editProfileTableView reloadData];
    
}

- (void)bioDidChange: (NSNotification *)notification {
    self.bio = notification.userInfo[@"bio"];
    [self.editProfileTableView reloadData];
}

- (void)interestRemoved: (NSNotification *)notification {
    [self.usersInterests removeObject:notification.userInfo[@"removedInterest"]];
}

#pragma mark - Helpers

-(UIBarButtonItem *) setUpDoneButton {
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneCategoryPicker:)];
    
    barButtonDone.style = UIBarButtonItemStyleDone;
    barButtonDone.tintColor = [UIColor blueColor];
    
    return barButtonDone;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    NSInteger numComponents = 1;
    return numComponents;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.interestsCategories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.interestsCategories[row][@"short_name"];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [interestsToolBar setHidden:NO];
    
    self.selectedRowDictRef = self.interestsCategories[row];
    self.selectedRowText = self.interestsCategories[row][@"short_name"];
    
}

@end
