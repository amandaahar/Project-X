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
#import "CreateEventViewController.h"
#import "Event.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Map.h"
@import Firebase;

@interface ChooseEventsViewController () <CLLocationManagerDelegate, CreateEventControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *numAttendees;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *Eventdescription;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (weak, nonatomic) IBOutlet UIView *card;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSDate *dateNSEvent;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) FIRDocumentReference *eventIDRef;

- (IBAction)CreateEventAction:(id)sender;

@end

@implementation ChooseEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    self.db = [FIRFirestore firestore];
    
    self.eventArray = [NSMutableArray new];
}

- (void) fetchEvents {
    [[FirebaseManager sharedManager] getEvent:^(NSArray * _Nonnull event, NSError * _Nonnull error) {
        if(error != nil)
        {
            NSLog(@"Error showing documents: %@", error);
        }else
        {
            //NSLog(@"%@", event);
            Event * myEvent = event.firstObject;
            
            self.numAttendees.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            self.eventName.text = myEvent.name;
            self.Eventdescription.text = myEvent.descriptionEvent;
            self.eventArray = event;
            self.eventID = myEvent.eventID;
            [self eventDateIdentifier];
            [self eventLocationIdentifier];
            
            self.card.layer.cornerRadius = 15;
            self.card.layer.masksToBounds = true;
        }
    }];
}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:sender.view.superview];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0.0, 0.0) inView:sender.view.superview];
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        if (self.card.center.x < 75) {
            //Move to left side
            [UIView animateWithDuration:0.3 animations:^{
                self.card.center = CGPointMake(self.card.center.x - 200, self.card.center.y + 75);
            }];
            [self nextEvent];
            //[self resetCard];
        }
        
        else if ((self.card.center.x) > (self.card.frame.size.width - 75)){
            //move off to right side
            [UIView animateWithDuration:0.3 animations:^{
                self.card.center = CGPointMake(self.card.center.x + 200, self.card.center.y + 75);
            }];
            
            Event *myEvent = self.eventArray.firstObject;
            
            FIRDocumentReference *eventRef = [[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid];
            [eventRef updateData:@{ @"events": [FIRFieldValue fieldValueForArrayUnion:@[myEvent.eventIDRef]]
            }];
            
            [self nextEvent];
            self.tabBarController.selectedIndex = 2;
        }
        
        else {
            [self resetCard];
        }
    }
}

- (void) nextEvent {
    NSMutableArray * tempArray = [self.eventArray mutableCopy];
    [tempArray removeObjectAtIndex:0];
    self.eventArray = tempArray;
    
    if (self.eventArray.firstObject == nil) {
        
        self.card.alpha = 0;//keep?
        //self.mapView.isHidden; //hide map!
       // self.mapView.setVisibility(View.GONE);
       
        UIView *emptyCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        emptyCard.center = self.view.center;
        emptyCard.backgroundColor = [UIColor blackColor];
        emptyCard.layer.cornerRadius = 15;
        emptyCard.layer.masksToBounds = true;
        [self.view addSubview:emptyCard];
        
        UILabel *noEventsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 200)];
        noEventsLabel.center = self.view.center;
        [noEventsLabel setText:@"No events found, create your own now!"];
        [noEventsLabel setNumberOfLines:0];
        [noEventsLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:noEventsLabel];
    }
    
    else {
        Event *nextEvent = self.eventArray.firstObject;
        self.numAttendees.text = [NSString stringWithFormat:@"%@", nextEvent.attendees];
        self.eventName.text = nextEvent.name;
        self.Eventdescription.text = nextEvent.descriptionEvent;
        [self eventLocationIdentifier];
        [self eventDateIdentifier];
        [self resetCard];
    }
}

- (void) resetCard {
    [UIView animateWithDuration:0.65 animations:^{
    [self.card setCenter:CGPointMake(self.view.center.x, self.view.center.y + 190)];
    }];
}

- (void) eventLocationIdentifier {
    Event *event = self.eventArray.firstObject;
    MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:location animated:YES];
    
    Map *eventAnnotation = [[Map alloc] init];
    eventAnnotation.title = self.eventName.text;
    //eventAnnotation.placeName = toString(event.location);
    eventAnnotation.placeName = [NSString stringWithFormat:@"%@", event.location];
    eventAnnotation.coordinate = location.center;
    //eventAnnotation.photo = [self resizeImage:event.photo withSize:CGSizeMake(50.0, 50.0)];
    [self.mapView addAnnotation:eventAnnotation];

}

 - (void) eventDateIdentifier {
    Event *event = self.eventArray.firstObject;
     
    FIRTimestamp *eventTimestamp = event.date;
    [self setDateNSEvent:eventTimestamp.dateValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    self.eventDate.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.dateNSEvent]];
}

- (void)didCreate:(Event *)newEvent {
    [self.eventArray addObject:newEvent];
    //[self resetCard];
    [self fetchEvents];
//    NSLog(@"printing the new event: %@", newEvent.name);
//    NSLog(@"printing the new event description: %@", newEvent.description);
    [self nextEvent];
    [self resetCard];
}

- (IBAction)CreateEventAction:(id)sender {
    [self performSegueWithIdentifier:@"CreateEventSegue" sender:nil];
//  [self resetCard];
}
     
#pragma mark - Navigation
     
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    CreateEventViewController *createEventController = (CreateEventViewController *)navigationController.topViewController;
    createEventController.delegate = self;
}

@end
