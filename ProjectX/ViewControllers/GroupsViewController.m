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
#import "DetailEventViewController.h"

@interface GroupsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Event *eventToPass;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = [FIRFirestore firestore];
    self.chatsTableView.dataSource = self;
    self.chatsTableView.delegate = self;
    [self getChats];
    self.events = [[NSMutableArray alloc] init];
    
}

-(void) getChats {
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil) {
            NSLog(@"Error getting user");
        } else {
            
            self.currentUser = user;
            [self.events removeAllObjects];
            for(FIRDocumentReference *eventDoc in self.currentUser.events) {
                [eventDoc addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
                    if(error == nil){
                    [self.events removeAllObjects];
                    Event * myEvent = [[Event alloc] initWithDictionary:snapshot.data eventID:snapshot.documentID];
                    [self.events addObject: myEvent];
                    [self.chatsTableView reloadData];
                    }
                }];
                
            }
            
        }
        
     }];

}


//- (void) removeExpiredChats {
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
    MessagesViewController *messagesViewController = [segue destinationViewController];
    //DetailEventViewController *detailsViewController = [segue destinationViewController];
    
    messagesViewController.eventID = self.eventToPass.eventID;
    [[messagesViewController navigationItem] setTitle:self.eventToPass.name];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *GroupchatID = @"cell";
    GroupTableViewCell *cell = [self.chatsTableView dequeueReusableCellWithIdentifier:GroupchatID];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GroupchatID];
    }
    Event *event = self.events[indexPath.row];
    [cell setNameOfChatText:event.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.eventToPass = self.events[indexPath.row];
    [self performSegueWithIdentifier:@"chat" sender:self];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *copyEvents = self.events.mutableCopy;
        [copyEvents removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *references = [NSMutableArray new];
        Event *eventToDelete = self.events[indexPath.row];
        [[[self.db collectionWithPath:@"Event"] documentWithPath: eventToDelete.eventID] updateData:@{@"swipeUsers":[FIRFieldValue fieldValueForArrayRemove: @[FIRAuth.auth.currentUser.uid]] }];
        
        for (Event *event in copyEvents) {
            FIRDocumentReference *eventRef = [[self.db collectionWithPath:@"Event"] documentWithPath: event.eventID];
            [references addObject:eventRef];
        }
      
        FIRDocumentReference *deleteRef = [[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid];
        [deleteRef updateData:@{ @"events":references} completion:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error deleting document: %@", error);
            } else {
                NSLog(@"Document successfully deleted");
                [self.chatsTableView reloadData];
                
            }
        }];
        
    }
    
}

#pragma mark - UITableView Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

@end
