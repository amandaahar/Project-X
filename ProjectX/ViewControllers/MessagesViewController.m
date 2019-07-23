//
//  MessagesViewController.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageTableViewCell.h"


@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property(nonatomic, strong) NSMutableArray *messagesInChat;


@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    // [self.tabBarController setViewControllers:@[]];
    // [self.tabBarItem setAccessibilityElementsHidden:YES];
    // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchMessages) userInfo:nil repeats:true];
    
   //  [self fetchMessages];
   // [self.messagesTableView reloadData];
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
                                        
-(void) fetchMessages {
    
    [self.messagesTableView reloadData];
    
}
                                        

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"messageCell"];
    Message *message = self.chat.messages[indexPath.row];
    
   //  [cell setMessageText:message.text];
    
    [cell setMessageText:message.text];
    [cell setUserLabelText:message.nameOfSender];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chat.messages.count;
}

@end





