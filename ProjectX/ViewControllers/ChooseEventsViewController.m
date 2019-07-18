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
@property (strong, nonatomic) NSArray *eventArray;

@end

@implementation ChooseEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    self.eventArray = [NSArray new];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PerformAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PerformAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
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
            self.eventArray = event;
            
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
        

        NSMutableArray * tempArray = [self.eventArray mutableCopy];
        /*
         for (Event *myEvent in self.myEvent2){
            //[tempArray removeObject: myEvent]; //Make sure to delete just one element in array not all!
            [tempArray removeObjectAtIndex:0];
            NSLog(@"%@", tempArray);
            NSLog(@"Inside for");
        }
         */
        //NSMutableArray * tempArray = [tempArray removeLastObject];
        
        [tempArray removeObjectAtIndex:0];
        
        self.eventArray = tempArray;
        NSLog(@"inside if");
        Event *nextEvent = self.eventArray.firstObject;
        //self.myEvent2 = nextEvent;
        //self.eventDate = nextEvent.date;
        self.numAttendees.text = [NSString stringWithFormat:@"%@", nextEvent.attendees];
        self.eventName.text = nextEvent.name;
        self.Eventdescription.text = nextEvent.descriptionEvent;

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
