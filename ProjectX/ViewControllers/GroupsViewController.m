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
#import "Event.h"



@interface GroupsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *chats;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, readwrite) FIRFirestore *db;


@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self.chatsTableView reloadData];
    self.db = [FIRFirestore firestore];
    [self getChats];
    
    self.chatsTableView.dataSource = self;
    self.chatsTableView.delegate = self;
    
    self.chats = [[NSMutableArray alloc] init];
    
    
    
    
    
    NSLog(@"after firebase");
     
}

-(void) getChats {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil) {
            NSLog(@"Error getting user");
        } else {
            self.currentUser = user;
            for (FIRDocumentReference *chatDoc in self.currentUser.chats) {
                [chatDoc getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
                    if (snapshot.exists) {
                        // [self.chats arrayByAddingObject:<#(nonnull id)#>]
                        Chat *chat = [[Chat alloc] initWithDictionary:snapshot.data];
                        // NSString *imageURL = [[NSString alloc]init];
                        
                    
                        
                        [self.chats addObject:chat];
                        [self.chatsTableView reloadData];
                        
                        NSLog(@"chat array: %@", self.chats);
                        NSLog(@"chat w data: %@", chat);
                        
                        //NSLog(@"Document w data: %@", snapshot.data);
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
    GroupTableViewCell *cell = [self.chatsTableView dequeueReusableCellWithIdentifier:@"GroupsCell"];
    
    Chat *chat = self.chats[indexPath.row];
    
    
    [chat getEventForChat:^(Event *event, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting event");
        } else {
            
            [cell setImage:event.pictures[0]];
            
        }
        
    }];
    
    

    [cell setNameOfChatText:chat.name];
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}


@end
