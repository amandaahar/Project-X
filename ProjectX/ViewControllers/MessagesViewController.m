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
    // [self.tabBarController setViewControllers:@[]];
    // [self.tabBarItem setAccessibilityElementsHidden:YES];
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
                                        

                                        

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesInChat.count;
}

@end





