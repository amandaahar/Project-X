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
#import "User.h"
#import "MessagesViewController.h"



@interface GroupsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *events;
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
    
    self.events = [[NSMutableArray alloc] init];
    
     
}

-(void) getChats {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil) {
            NSLog(@"Error getting user");
        } else {
            self.currentUser = user;
            for(FIRDocumentReference *eventDoc in self.currentUser.events) {
                [eventDoc addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
                    if(error == nil){
                    Event * myEvent = [[Event alloc] initWithDictionary:snapshot.data eventID:snapshot.documentID];
                    [self.events addObject: myEvent];
                    [self.chatsTableView reloadData];
                    }
                }];
                
            }
            
        }
        
     }];

}


//-(void)removeExpiredChats {
//    for (Chat *chat in self.chats) {
//        if(chat.isExpired) {
//            [self.chats removeObject:chat];
//        }
//    }
//
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.chatsTableView indexPathForCell:tappedCell];
    Event *eventToPass = self.events[indexPath.row];
    MessagesViewController *messagesViewController = [segue destinationViewController];
    
    messagesViewController.eventID = eventToPass.eventID;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GroupTableViewCell *cell = [self.chatsTableView dequeueReusableCellWithIdentifier:@"GroupsCell"];
    
    Event *event = self.events[indexPath.row];
    // NSLog(@"created at date%@", chat.createdAt);
    
    
    
            [cell setNameOfChatText:event.name];
            if (event.pictures[0] != nil) {
                [cell setImage:event.pictures[0]];
            } else {
                [cell setImage:@"http://pngimg.com/uploads/earth/earth_PNG39.png"];
            }
            
            
    

    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}


@end
