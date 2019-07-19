//
//  MessagesViewController.m
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MessagesViewController.h"


@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) Chat *chat;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self.tabBarController setViewControllers:@[]];
    // [self.tabBarItem setAccessibilityElementsHidden:YES];
}

-(void)setChat:(Chat *)chat{
    self.chat = chat;
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
