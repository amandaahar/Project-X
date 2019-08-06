//
//  CreateEventViewController.m
//  ProjectX
//
//  Created by aadhya on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "CreateEventViewController.h"
#import "ChooseEventsViewController.h"
#import "AppDelegate.h"
#import "../Models/FirebaseManager.h"
#import "MFTextField.h"
#import "User.h"
@import Firebase;

@interface CreateEventViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MFTextField *createEventName;
@property (weak, nonatomic) IBOutlet MFTextField *createEventDescription;
@property (weak, nonatomic) IBOutlet MFTextField *createEventLocation;
@property (weak, nonatomic) IBOutlet MFTextField *createEventDate;
@property (weak, nonatomic) IBOutlet MFTextField *createAttendees;//slider
@property (weak, nonatomic) IBOutlet UIImageView *createPicture;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;//Make sure doesnt crash if not complete
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) NSString *EventImageString;
@property (weak, nonatomic) NSString *userFriendlyLocation;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) User *currentUser;

@end

@implementation CreateEventViewController
CLLocationCoordinate2D coordinate;
UIDatePicker *datePicker;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.db = [FIRFirestore firestore];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.createEventDate setInputView:datePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.createEventDate setInputAccessoryView:toolBar];
    
}

- (void) ShowSelectedDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];

    self.createEventDate.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    [self.createEventDate resignFirstResponder];
    
}

#pragma mark - Event Image

- (IBAction)OpenCameraButton:(id)sender {
    
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
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];//Do I really need this
    
    self.createPicture.image = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
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
    FIRStorageReference *storageRef = [storage referenceWithPath:[@"images/" stringByAppendingString:[NSString stringWithFormat: @"%@", randomID.description, @".jpg"]]];
    NSData *data = UIImageJPEGRepresentation(self.createPicture.image, 0.75);
    FIRStorageMetadata *uploadMetaData = [[FIRStorageMetadata alloc] init];
    uploadMetaData.contentType = @"image/jpeg";
    __block NSURL *downloadURL = [[NSURL alloc] init];
    
    FIRStorageUploadTask *uploadTask = [storageRef putData:data metadata:uploadMetaData completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            NSLog(@"Error occurred: %@", error);
        } else {
            int size = metadata.size;
            [storageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error occurred: %@", error);
                } else {
                    downloadURL = URL;
                    NSLog(@"Downloaded URL: %@", downloadURL);
                    self.EventImageString = downloadURL.absoluteString;
                    NSLog(@"Image URL: %@", self.EventImageString);
                }
            }];
        }
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        NSLog(@"Picture sending success!");
    }];
    
    return downloadURL.absoluteString;
    
}

#pragma mark - Creating event

- (IBAction)chooseCategory:(id)sender {

    NSNumber *storeCategory = [[NSNumber alloc]init];
    
    if(self.segmentedControl.selectedSegmentIndex == 0){
        self.categoryLabel.text = @"Food";
        storeCategory = [NSNumber numberWithInt:0];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.categoryLabel.text = @"Culture";
        storeCategory = [NSNumber numberWithInt:1];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 2){
        self.categoryLabel.text = @"Fitness";
        storeCategory = [NSNumber numberWithInt:2];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 3){
        self.categoryLabel.text = @"Education";
        storeCategory = [NSNumber numberWithInt:3];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 4){
        self.categoryLabel.text = @"Other";
        storeCategory = [NSNumber numberWithInt:4];
    }
    else{
        self.categoryLabel.text = @"Select";
        storeCategory = [NSNumber numberWithInt:4];
    }
    
}



- (IBAction)didTapCreate:(id)sender {
    
    if (![self validateFields]) {
        return;
    }
    // This could be a block, that returns the string, then the rest of the work has to wait for this
    [self imageStorage];
    
    NSString *address = [NSString stringWithFormat:@"%@", self.createEventLocation.text];
    [[[CLGeocoder alloc] init] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
        }
        FIRGeoPoint *geoPoint = [[FIRGeoPoint alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        NSNumberFormatter *Attendeesformatter = [[NSNumberFormatter alloc] init];
        NSNumber *formattedNumOfAttendees = [Attendeesformatter numberFromString:self.createAttendees.text];

        NSNumber *storeCategory = [[NSNumber alloc] init];
        
        if(self.segmentedControl.selectedSegmentIndex == 0){
            self.categoryLabel.text = @"Food";
            storeCategory = [NSNumber numberWithInt:0];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 1){
            self.categoryLabel.text = @"Culture";
            storeCategory = [NSNumber numberWithInt:1];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 2){
            self.categoryLabel.text = @"Fitness";
            storeCategory = [NSNumber numberWithInt:2];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 3){
            self.categoryLabel.text = @"Education";
            storeCategory = [NSNumber numberWithInt:3];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 4){
            self.categoryLabel.text = @"Other";
            storeCategory = [NSNumber numberWithInt:4];
        }
        else{
            self.categoryLabel.text = @"Select";
            storeCategory = [NSNumber numberWithInt:4];
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"Event"] addDocumentWithData:@{@"name": self.createEventName.text, @"description": self.createEventDescription.text, @"location": geoPoint, @"eventDate": [FIRTimestamp timestampWithDate: datePicker.date], @"numAttendees": formattedNumOfAttendees, @"categoryIndex": storeCategory, @"userFriendlyLocation": address, @"swipeUsers": @[FIRAuth.auth.currentUser.uid]} completion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error adding document: %@", error);
                } else {
                    NSLog(@"Document added with ID: %@", ref.documentID);
                    self.eventID = ref.documentID;
                    [self addEventImage];
                    [self addEventToCurrentUser:self.eventID];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        });
    }];
    
}

- (void) addEventImage {
    
    FIRDocumentReference *eventRef = [[self.db collectionWithPath:@"Event"] documentWithPath:self.eventID];
    [eventRef updateData:@{ @"pictures": [FIRFieldValue fieldValueForArrayUnion:@[self.EventImageString]]}
            completion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error updating document: %@", error);
                } else {
                    NSLog(@"Document updated with Image");
                }
            }];
    
}

#pragma mark - Done creating

- (IBAction)didTapCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)closeKeyboard:(id)sender {
    
    [self.view endEditing:YES];
    
}

#pragma mark - Helpers
- (NSError *)errorWithLocalizedDescription:(NSString *)localizedDescription
{
    NSString *domain = @"Project-XDomain";
    NSInteger code = -1;
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

- (BOOL)validateFields {
    
    NSError *error = [self errorWithLocalizedDescription:@"Required field"];
    BOOL areFieldsValid = YES;
    
    if (self.createEventName.text.length == 0) {
        [self.createEventName setError:error animated:YES];
        areFieldsValid = NO;
        //[self.createEventName s]
        //return;
    }
    if (self.createEventDescription.text.length == 0) {
        [self.createEventDescription setError:error animated:YES];
        areFieldsValid = NO;
        
    }
    if (self.createEventLocation.text.length == 0) {
        [self.createEventLocation setError:error animated:YES];
        areFieldsValid = NO;
        
    }
    if (self.createAttendees.text.length == 0) {
        [self.createAttendees setError:error animated:YES];
        areFieldsValid = NO;
        
    }
    if (self.createEventDate.text.length == 0) {
        [self.createEventDate setError:error animated:YES];
        areFieldsValid = NO;
        //return;
    }
    return areFieldsValid;
    
}

- (void)addEventToCurrentUser: (NSString *)eventID {
    FIRDocumentReference *eventRef = [[self.db collectionWithPath:@"Events"] documentWithPath:self.eventID];
    FIRDocumentReference *userRef = [[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid];
    
    NSString *address = [NSString stringWithFormat:@"%@", self.createEventLocation.text];
    
    [[[CLGeocoder alloc] init] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
        }
        FIRGeoPoint *geoPoint = [[FIRGeoPoint alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        NSNumberFormatter *Attendeesformatter = [[NSNumberFormatter alloc] init];
        NSNumber *formattedNumOfAttendees = [Attendeesformatter numberFromString:self.createAttendees.text];
        
        NSNumber *storeCategory = [[NSNumber alloc] init];
        
        if(self.segmentedControl.selectedSegmentIndex == 0){
            self.categoryLabel.text = @"Food";
            storeCategory = [NSNumber numberWithInt:0];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 1){
            self.categoryLabel.text = @"Culture";
            storeCategory = [NSNumber numberWithInt:1];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 2){
            self.categoryLabel.text = @"Fitness";
            storeCategory = [NSNumber numberWithInt:2];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 3){
            self.categoryLabel.text = @"Education";
            storeCategory = [NSNumber numberWithInt:3];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 4){
            self.categoryLabel.text = @"Other";
            storeCategory = [NSNumber numberWithInt:4];
        }
        else{
            self.categoryLabel.text = @"Select";
            storeCategory = [NSNumber numberWithInt:4];
        }
        
    [userRef updateData:@{@"name": self.createEventName.text, @"description": self.createEventDescription.text, @"location": geoPoint, @"eventDate": [FIRTimestamp timestampWithDate: datePicker.date], @"numAttendees": formattedNumOfAttendees, @"categoryIndex": storeCategory, @"userFriendlyLocation": address, @"events": [FIRFieldValue fieldValueForArrayUnion:@[eventRef]] }];
    
    /*
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting current user for profile");
        } else {
            self.currentUser = user;
            [self.currentUser joinEvent:eventID];
        }
    }];
    */
     }];
}

@end
