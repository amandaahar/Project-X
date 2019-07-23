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
@import Firebase;

@interface CreateEventViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *createEventName;
@property (weak, nonatomic) IBOutlet UITextField *createEventDescription;
@property (weak, nonatomic) IBOutlet UITextField *createEventLocation;
@property (weak, nonatomic) IBOutlet UITextField *createEventDate;
@property (weak, nonatomic) IBOutlet UITextField *createAttendees;//Change to slider
@property (weak, nonatomic) IBOutlet UIImageView *createPicture; //Finish later
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation CreateEventViewController
CLLocationCoordinate2D coordinate;
UIDatePicker *datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [FIRFirestore firestore];
    datePicker = [[UIDatePicker alloc]init];
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
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];//Do I really need this
    
    self.createPicture.image = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
                                
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

- (IBAction)didTapCreate:(id)sender {

    NSString *address = [NSString stringWithFormat:@"%@", self.createEventLocation.text];
    [[[CLGeocoder alloc] init] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
        }
        FIRGeoPoint *geoPoint = [[FIRGeoPoint alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        NSNumberFormatter *Attendeesformatter = [[NSNumberFormatter alloc]init];
        NSNumber *formattedNumOfAttendees = [Attendeesformatter numberFromString:self.createAttendees.text];
        
        __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"Event"] addDocumentWithData:@{@"name": self.createEventName.text, @"description": self.createEventDescription.text, @"location": geoPoint, @"eventDate": [FIRTimestamp timestampWithDate: datePicker.date], @"numAttendees": formattedNumOfAttendees} completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error adding document: %@", error);
            } else {
                NSLog(@"Document added with ID: %@", ref.documentID);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
    
}
                                                                                                     

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeKeyboard:(id)sender {
    [self.view endEditing:YES];
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
