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
#import "../Helpers/AppColors.h"

#import <AVFoundation/AVAudioPlayer.h>

@interface GroupsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Event *eventToPass;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (strong, nonatomic) NSString *eventImageURL;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) CAGradientLayer *gradient;
@end

@implementation GroupsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.db = [FIRFirestore firestore];
    self.chatsTableView.dataSource = self;
    self.chatsTableView.delegate = self;
    self.searchBar.delegate = self;
    [self getChats];
    [self.chatsTableView reloadData];
    self.events = [[NSMutableArray alloc] init];
    self.filteredData = self.events;
}

- (void)getChats
{
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error != nil) {
            NSLog(@"Error getting user");
        } else {
            
            self.currentUser = user;
            [self.events removeAllObjects];
            
            for(FIRDocumentReference *eventDoc in self.currentUser.events) {
                [eventDoc getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
                    if(error == nil){
                    Event * myEvent = [[Event alloc] initWithDictionary:snapshot.data eventID:snapshot.documentID];
                    [self.events addObject: myEvent];
                    
                    }
                }];
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.chatsTableView reloadData];
            });
            
        }
        
     }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
    [myGen prepare];
    [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
    myGen = NULL;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.play;
    
    MessagesViewController *messagesViewController = [segue destinationViewController];
    messagesViewController.eventID = self.eventToPass.eventID;
    [[messagesViewController navigationItem] setTitle:self.eventToPass.name];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *GroupchatID = @"cell";
    GroupTableViewCell *cell = [self.chatsTableView dequeueReusableCellWithIdentifier:GroupchatID];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GroupchatID];
    }
    //Event *event = self.events[indexPath.row];
    Event *event = self.filteredData[indexPath.row];
    [cell setNameOfChatText:event.name];
    [cell setEventDateText:event.date];
    [cell setImage:event.pictures[0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.eventToPass = self.events[indexPath.row];
    [self performSegueWithIdentifier:@"chat" sender:self];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredData.count;
}

#pragma mark - Searching

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Event *evaluatedObject, NSDictionary *bindings) {
            NSString* chatName = evaluatedObject.name;
           return [chatName containsString:searchText];
        }];
        self.filteredData = [self.events filteredArrayUsingPredicate:predicate];
        //NSLog(@"%@", self.filteredData);
    }
    else {
        self.filteredData = self.events;
    }
    
    [self.chatsTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

#pragma mark - Deleting groups

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
