//
//  ChooseEventsViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "ChooseEventsViewController.h"
#import "AppDelegate.h"
#import "../Models/FirebaseManager.h"
@import Firebase;

@interface ChooseEventsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *numAttendees;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *Eventdescription;
@property (nonatomic, readwrite) FIRFirestore *db;
//@property (strong, nonatomic) FIRDatabaseReference *ref;
//@property (strong, nonatomic) NSArray *eventArray;
@property (strong, nonatomic) NSArray *myEvent2;

@end

@implementation ChooseEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    self.myEvent2 = [NSArray new];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PerformAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft ;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PerformAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight ;
    [self.view addGestureRecognizer:right];
}

- (void) fetchEvents {
    [[FirebaseManager sharedManager] getEvent:^(NSArray * _Nonnull event, NSError * _Nonnull error) {
        if(error != nil)
        {
            NSLog(@"Error showing documents: %@", error);
        }else
        {
            NSLog(@"%@", event);
            Event * myEvent = event.firstObject;
            //self.eventDate = myEvent.date;
            self.numAttendees.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            self.eventName.text = myEvent.name;
            self.Eventdescription.text = myEvent.descriptionEvent;
            self.myEvent2 = event;
            
            /*
             FIRUser *currentUser = [FIRUser currentUser];
             self.eventName.text = [currentUser username];
             self.ref = [[FIRDatabase database] reference];
             NSString *key = [[self.ref child:@"posts"] childByAutoId].key;
             NSDictionary *post = @{@"eventDate": self.eventDate,
             @"numAttendees": self.numAttendees,
             @"name": self.eventName,
             @"description": self.Eventdescription};
             NSDictionary *childUpdates = @{[@"/Event/" stringByAppendingString:key]: post,
             [NSString stringWithFormat:@"/user-posts/%@/", key]: post};
             [self.ref updateChildValues:childUpdates];
             */
        }
    }];
}

-(void)PerformAction:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"LEFT GESTURE");
        
        /*
        FIRDocumentReference *EventRef =
        [[self.db collectionWithPath:@"Event"] documentWithPath:[[[FIRAuth auth] currentUser] uid]];
        
        // Atomically add a new region to the "regions" array field.
        [EventRef updateData:@{@"Users": [FIRFieldValue fieldValueForArrayUnion:@[@"Danny"]]
                                    }];
        
        // Atomically remove a new region to the "regions" array field.
        [EventRef updateData:@{@"Users": [FIRFieldValue fieldValueForArrayRemove:@[@"San Fran hiking"]]
                               }];
        */
        //[NSMutableArray replaceObjectAtIndex:index withObject:[NSNull null]];
        
        
        NSMutableArray * tempArray = [self.myEvent2 mutableCopy];
        for (Event *myEvent in self.myEvent2){
            [tempArray removeObject: myEvent]; //Make sure to delete just one element in array not all!
            NSLog(@"%@", tempArray);
            NSLog(@"Inside for");
        }
        self.myEvent2 = tempArray;
        NSLog(@"inside if");
        //self.eventDate = myEvent.date;
        Event *myEvent3 = self.myEvent2.firstObject;
        self.numAttendees.text = [NSString stringWithFormat:@"%@", myEvent3.attendees];
        self.eventName.text = myEvent3.name;
        self.Eventdescription.text = myEvent3.descriptionEvent;

    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"RIGHT GESTURE");
        self.tabBarController.selectedIndex = 2;
    }
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
