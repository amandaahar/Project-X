//
//  MessagesViewController.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageTableViewCell.h"
#import "LanguagesTableViewController.h"
#import "../Cells/MessageBubble.h"
#import "../Helpers/TranslatorManager.h"
#import "../Helpers/AppColors.h"
#import "../Models/User.h"
#import "../Cells/PhotoBubble.h"
#import "DetailEventViewController.h"
#import <WaterDrops-Swift.h>
#import <AVFoundation/AVAudioPlayer.h>
@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property(nonatomic, strong) NSMutableArray *messagesInChat;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSString * idCurrentUser;
@property (strong, nonatomic) User *user;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIImage *createPicture;
@property (strong, nonatomic) NSString *urlImage;
@end

@implementation MessagesViewController
NSString * identifier = @"bubble";
NSString * identifier2 = @"photo";
NSLayoutConstraint *bottom;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error == nil)
        {
            self.user = user;
            UIBarButtonItem *lan = [[UIBarButtonItem alloc] initWithTitle:[@"Language: " stringByAppendingString:self.user.language] style:(UIBarButtonItemStylePlain) target:self action:@selector(chooseLanguage:)];
            UIBarButtonItem *det = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:(UIBarButtonItemStylePlain) target:self action:@selector(detailsSegue:)];
            [[self navigationItem] setRightBarButtonItems:@[lan,det]];
        }
    }];
    self.messageText.layer.cornerRadius = 15;
    self.messageText.clipsToBounds = YES;
    self.sendButton.layer.cornerRadius = 15;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [[AppColors sharedManager] getOrange].CGColor;
    
    NSString * language = [[NSLocale preferredLanguages] firstObject];
    NSLog(@"%@",language);
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotifications:) name:UIKeyboardWillShowNotification object:nil];
    bottom = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:bottom];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden: YES];
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    self.messagesTableView.allowsSelection = NO;
    self.idCurrentUser = FIRAuth.auth.currentUser.uid;
    [self.messagesTableView registerNib:[UINib nibWithNibName:@"MessageBubble" bundle:nil] forCellReuseIdentifier:identifier];
    [self.messagesTableView registerNib:[UINib nibWithNibName:@"PhotoBubble" bundle:nil] forCellReuseIdentifier:identifier2];

    [[FirebaseManager sharedManager] getMessagesFromEvent:self.eventID completion:^(NSArray * _Nonnull messages, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error getting messages");
        } else  {
            self.messagesInChat = messages.mutableCopy;
            [self.messagesTableView reloadData];
            if(self.messagesInChat.count > 0)
            {
                
            }
            
        }
    }];

}
- (IBAction)removeKeyword:(UITapGestureRecognizer *)sender {
    [self.messageText resignFirstResponder];
    bottom.constant = 0;
}

- (void)chooseLanguage:(NSString *)text {
    UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
    [myGen prepare];
    [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
    myGen = NULL;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
    [self performSegueWithIdentifier:@"languages" sender:self];
    
}


- (void)handleKeyboardNotifications:(NSNotification*)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    for (NSLayoutConstraint * constraint in self.view.constraints)
    {
        if([constraint.identifier isEqualToString:@"bottom"])
        {
           bottom.constant = -keyboardFrame.size.height;
        }
    }
    [self.view layoutIfNeeded];
   
}

- (IBAction)didTapSend:(id)sender {
    if(![self.messageText.text isEqualToString: @""])
    {
        [[FirebaseManager sharedManager] getCurrentUser:^(User *user, NSError *error) {
            if (error != nil) {
                NSLog(@"Error getting user");
                UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
                [myGen prepare];
                [myGen notificationOccurred:(UINotificationFeedbackTypeError)];
                myGen = NULL;
            } else {
                [user composeMessage:self.messageText.text chat:self.eventID];
                UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
                [myGen prepare];
                [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
                myGen = NULL;
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"music_marimba_chord" ofType:@"wav"];
                NSURL *soundUrl = [NSURL fileURLWithPath:path];
                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
                self.audioPlayer.play;
                
                self.messageText.text = @"";
            }
            
        }];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"languages"])
    {
        LanguagesTableViewController * vc = [segue destinationViewController];
        vc.previousLanguage = self.user.language;
    }
    
    else if([segue.identifier isEqualToString:@"eventDetails"])
    {
        DetailEventViewController * detailsVC = [segue destinationViewController];
        detailsVC.detailEventID = self.eventID;
    }
    
}

- (void)detailsSegue:(NSString *)text {
    
    UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
    [myGen prepare];
    [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
    myGen = NULL;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
    [self performSegueWithIdentifier:@"eventDetails" sender:self];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageBubble *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Message *message = self.messagesInChat[indexPath.row];
    
    if([message.text containsString:@"http"]){
        PhotoBubble *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2];
        [cell2 setUserLanguage:self.user.language];
        [cell2 setIdEvent:self.eventID];
        if([self.idCurrentUser isEqualToString:message.userID])
        {
            [cell2 showOutgoingMessage:message];
            
        }else
        {
            [cell2 showIncomingMessage:message];
        }
        
        
        
        
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell2 autoresizesSubviews];
        [cell2 layoutSubviews];
        
        [cell2 layoutIfNeeded];
        
        return cell2;
    }
    [cell setUserLanguage:self.user.language];
    [cell setIdEvent:self.eventID];
    if([self.idCurrentUser isEqualToString:message.userID])
    {
        [cell showOutgoingMessage:message];
        
    }else
    {
        [cell showIncomingMessage:message];
    }
    
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell autoresizesSubviews];
    [cell layoutSubviews];
    
    [cell layoutIfNeeded];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellheight = 70; //assuming that your TextView's origin.y is 30 and TextView is the last UI element in your cell
    
    NSString *text = [[self.messagesInChat objectAtIndex:indexPath.row] text];
    
    UIFont *font = [UIFont systemFontOfSize:14];// The font should be the same as that of your textView
    CGSize constraintSize = CGSizeMake(150, CGFLOAT_MAX);// maxWidth = max width for the textView
    
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    cellheight += size.height; //you can also add a cell padding if you want some space below textView
    return cellheight;
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesInChat.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *message = self.messagesInChat[indexPath.row];
    if([self.idCurrentUser isEqualToString:message.userID])
    {
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"Delete message" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to delete this message?" message:message.text preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                [[FirebaseManager sharedManager] removeMessageFromChat:self.eventID andMessage:message.idMessage completion:^(NSError * _Nonnull error) {
                    if(error != nil){
                        NSLog(@"%@",error.localizedDescription);
                    }
                }];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
            [alert addAction:delete];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        return @[delete];
    } else {
        return @[];
    }
   
    
}
- (IBAction)sendImage:(UIButton *)sender {
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *image = [self resizeImage:originalImage withSize:CGSizeMake(400, 400)];
    NSString *urlImage =[self imageStorage:image];
   

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size
{
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (NSString *)imageStorage : (UIImage *) image
{
    FIRStorage *storage = [FIRStorage storage];
    NSUUID *randomID = [[NSUUID alloc] init];
    FIRStorageReference *storageRef = [storage referenceWithPath:[self.eventID stringByAppendingString: [@"/images/" stringByAppendingString:[NSString stringWithFormat: @"%@", randomID.description, @".jpg"]]]];
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
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
                    self.urlImage = downloadURL.absoluteString;
                    NSLog(@"Image URL: %@", self.urlImage);
                    if(downloadURL.absoluteString != nil && ![downloadURL.absoluteString isEqualToString: @""])
                    {
                        [[FirebaseManager sharedManager] getCurrentUser:^(User *user, NSError *error) {
                            if (error != nil) {
                                NSLog(@"Error getting user");
                                UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
                                [myGen prepare];
                                [myGen notificationOccurred:(UINotificationFeedbackTypeError)];
                                myGen = NULL;
                            } else {
                                [user composeMessage:downloadURL.absoluteString chat:self.eventID];
                                UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
                                [myGen prepare];
                                [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
                                myGen = NULL;
                                
                                NSString *path = [[NSBundle mainBundle] pathForResource:@"music_marimba_chord" ofType:@"wav"];
                                NSURL *soundUrl = [NSURL fileURLWithPath:path];
                                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
                                self.audioPlayer.play;
                                
                                //self.messageText.text = @"";
                            }
                            
                        }];
                    }
                }
            }];
        }
    }];
    
    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        NSLog(@"Picture sending success!");
    }];
    
    return downloadURL.absoluteString;
}
@end





