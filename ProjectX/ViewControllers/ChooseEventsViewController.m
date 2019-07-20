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

- (IBAction)CreateEventAction:(id)sender;

@end

@implementation ChooseEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    self.eventArray = [NSMutableArray new];
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
            
            self.numAttendees.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            self.eventName.text = myEvent.name;
            self.Eventdescription.text = myEvent.descriptionEvent;
            self.eventArray = event;
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
            //NSLog(@"LEFT GESTURE");
            [self nextEvent];
            //[self resetCard];
        }
        
        else if ((self.card.center.x) > (self.card.frame.size.width - 75)){
            //move off to right side
            [UIView animateWithDuration:0.3 animations:^{
                self.card.center = CGPointMake(self.card.center.x + 200, self.card.center.y + 75);
            }];
            //NSLog(@"RIGHT GESTURE");
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
        //NSLog(@"No events found");
        
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
        [self.card setCenter:self.view.center];
    }];
}

- (void) eventLocationIdentifier {
    Event *event = self.eventArray.firstObject;
    MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:location animated:false];
    
    self.mapView.layer.cornerRadius = 15;
    self.mapView.layer.masksToBounds = true;
}

 - (void) eventDateIdentifier {
    Event *event = self.eventArray.firstObject;
     
    FIRTimestamp *eventTimestamp = event.date;
    [self setDateNSEvent:eventTimestamp.dateValue];
    self.eventDate.text =  [NSString stringWithFormat:@"%@", self.dateNSEvent];
}

- (void)didCreate:(Event *)newEvent {
    [self.eventArray addObject:newEvent];
    [self nextEvent];
    [self resetCard];
}

- (IBAction)CreateEventAction:(id)sender {
    [self performSegueWithIdentifier:@"CreateEventSegue" sender:nil];
}
     
#pragma mark - Navigation
     
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    CreateEventViewController *createEventController = (CreateEventViewController *)navigationController.topViewController;
    createEventController.delegate = self;
}
     
@end
