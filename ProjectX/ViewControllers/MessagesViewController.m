//
//  MessagesViewController.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageTableViewCell.h"
#import "../Cells/MessageBubble.h"

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property(nonatomic, strong) NSMutableArray *messagesInChat;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation MessagesViewController

NSLayoutConstraint *bottom;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden: YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotifications:) name:UIKeyboardWillShowNotification object:nil];
    bottom = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:bottom];


}

-(void) handleKeyboardNotifications : (NSNotification*) notification
{
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
   //  User *currentUser = [[User alloc]init];
    [[FirebaseManager sharedManager] getCurrentUser:^(User *user, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting user");
        } else {
            [user composeMessage:self.messageText.text chat:self.chat];
        }
    }];
    self.messageText.text = @"";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
-(void)getMessages {
    FIRFirestore *db = [FIRFirestore firestore];
    FIRCollectionReference *messages = [[[[db collectionWithPath:@"Event"] documentWithPath:self.chat.event] collectionWithPath:@"Chats"] documentWithPath:self.chat.
}
 */
                                        
-(void) fetchMessages{
    FIRFirestore *db = [FIRFirestore firestore];
  //  Fircol
    self.chat = [self.chat initWithFIRCollectionReference:[db collectionWithPath:self.chat.path]];
    [self.messagesTableView reloadData];
    
    
//    FIRFirestore *db = [FIRFirestore firestore];
//    [[db collectionWithPath:self.chat.path] getDocumentsWithCompletion: ^(FIRQuerySnapshot *snapshot, NSError *error) {
//        if (error != nil) {
//            NSLog(@"error getting messages in chat collection");
//        } else {
//
//        }
//    }];
    
    
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * identifier = @"bubble";
    MessageBubble *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MessageBubble" bundle:nil] forCellReuseIdentifier:@"bubble"];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    Message *message = self.chat.messages[indexPath.row];
   if(cell.text == nil)
   {
      [cell setMyText:message.text];
   }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chat.messages.count;
}

@end





