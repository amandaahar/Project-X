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
@property (weak, nonatomic) IBOutlet UITextField *createEventDate; //what about time
@property (weak, nonatomic) IBOutlet UITextField *createAttendees;
@property (weak, nonatomic) IBOutlet UIImageView *createPicture; //Do later
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCreate:(id)sender {
    /*
    [[FirebaseManager sharedManager] getEvent:^(NSArray * _Nonnull event, NSError * _Nonnull error) {
        if(error){
            NSLog(@"Error creating event: %@", error.localizedDescription);
        }
        else{
            [self.delegate didCreate:event.firstObject];
            NSLog(@"Creating event Success!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
     */
    
    /*
     [[[self.db collectionWithPath:@"Event"] documentWithPath:FIRAuth.auth.currentUser.uid] setData:@{
           @"name": self.createEventName.text, @"description": self.createEventDescription.text, @"location": self.createEventLocation.text, @"date": self.createEventDate.text, @"numAttendees": self.createAttendees.text } completion:^(NSError * _Nullable error) {
                if (error != nil) {
                     NSLog(@"Error writing document: %@", error);
                } else {
                    NSLog(@"Document successfully written!");
                    [self dismissViewControllerAnimated:YES completion:nil];
                  }
          }];
     */
    
    __block FIRDocumentReference *ref = [[self.db collectionWithPath:@"Event"] addDocumentWithData:@{
                                                                                                     @"name": self.createEventName.text, @"description": self.createEventDescription.text, @"location": self.createEventLocation.text, @"date": self.createEventDate.text, @"numAttendees": self.createAttendees.text } completion:^(NSError * _Nullable error) {
                                                                                                         if (error != nil) {
                                                                                                             NSLog(@"Error adding document: %@", error);
                                                                                                         } else {
                                                                                                             NSLog(@"Document added with ID: %@", ref.documentID);
                                                                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                                                                         }
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
