//
//  GroupsViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "GroupsViewController.h"
#import "../Models/FirebaseManager.h"
#import "GroupTableViewCell.h"
#import "Chat.h"


@interface GroupsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *chats;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (nonatomic, strong) User *currentUser;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatsTableView.dataSource = self;
    self.chatsTableView.delegate = self;
    
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil) {
            //NSLog(@"in if");
        }else {
            self.currentUser = user;
            // self.chats = self.currentUser.chats;
            for (FIRDocumentReference *chat in self.currentUser.chats) {
                [chat getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
                    if (snapshot.exists) {
                        // [self.chats arrayByAddingObject:<#(nonnull id)#>]
                        NSLog(@"Document w data: %@", snapshot.data);
                    } else {
                        NSLog(@"no data");
                    }
                }];
            }
            // FIRDocumentReference *chatRef = self.chats[0];
            
        }
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupsCell"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}


@end
