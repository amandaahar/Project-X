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
//#import "LocationTableViewController.h"
#import "Event.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "../Models/MapAnnotation.h"
#import "../Models/User.h"
@import Firebase;
@import CoreLocation;

@interface ChooseEventsViewController () <CLLocationManagerDelegate, CreateEventControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *numAttendees;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *Eventdescription;
@property (weak, nonatomic) IBOutlet UILabel *categoryIndex;
@property (weak, nonatomic) IBOutlet UIView *card;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *eventPhoto;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSDate *dateNSEvent;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *annotationID;
@property (strong, nonatomic) FIRDocumentReference *eventIDRef;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (strong, nonatomic) NSString *eventImageURL;
@property (strong, nonatomic) CLLocation *UserCurrentLocation;
@property (nonatomic, strong) User *currentUser;
@property (strong, nonatomic) UIView *emptyCard;
@property (strong, nonatomic) UILabel *noEventsLabel;

@end

@implementation ChooseEventsViewController

CLLocationManager *UserLocationManager;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[self fetchEvents];
    //[self fetchImage];
    
    self.db = [FIRFirestore firestore];
    self.mapView.delegate = self;
    self.annotationID = @"Pin";
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:self.annotationID];
    self.eventArray = [NSMutableArray new];
    [self movingPreview];
    
    self.UserCurrentLocation = [[CLLocation alloc] initWithLatitude:36 longitude:-122];
    [self currentLocationIdentifier];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    
    /*
    FIRDatabaseReference *geofireRef = [[FIRDatabase database] reference];
    GeoFire *geoFire = [[GeoFire alloc] initWithFirebaseRef:geofireRef];
    
    [geoFire setLocation:[[CLLocation alloc] initWithLatitude:37.7853889 longitude:-122.4056973]
                  forKey:@"firebase-hq"
     withCompletionBlock:^(NSError *error) {
         if (error != nil) {
             NSLog(@"whoops: An error occurred: %@", error.localizedDescription);
         } else {
             NSLog(@"Saved location successfully!");
         }
     }];
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:37.7832889 longitude:-122.4056973];
    // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
    GFCircleQuery *circleQuery = [geoFire queryAtLocation:self.UserCurrentLocation withRadius:5.6];
    
    // Query location by region
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
    MKCoordinateRegion region = MKCoordinateRegionMake(center.coordinate, span);
    GFRegionQuery *regionQuery = [geoFire queryWithRegion:region];
    
//    FIRDatabaseHandle queryHandle = [query observeEventType:GFEventTypeKeyEntered withBlock:^(NSString *key, CLLocation *location) {
//        NSLog(@"Key '%@' entered the search area and is at location '%@'", key, location);
//    }];
    
    */
    
}

#pragma mark - Fetching Events

- (void) fetchEvents {
    
    [[FirebaseManager sharedManager] getEvents:^(NSArray * _Nonnull event, NSError * _Nonnull error) {
        if(error != nil)
        {
            NSLog(@"Error showing documents: %@", error);
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"How to choose events:"
                                                                           message:@"Swipe the event card right if you would like to attend, swipe left to see next event"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"I am ready!"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     //[self movingPreview];
                                                                 }];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
            //NSLog(@"%@", event);
            Event * myEvent = event.firstObject;
            
            self.numAttendees.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            self.eventName.text = myEvent.name;
            self.Eventdescription.text = myEvent.descriptionEvent;
            self.eventArray = event;
            self.eventID = myEvent.eventID;
            [self eventDateIdentifier];
            [self eventLocationIdentifier];
            
            self.eventImageURL = myEvent.pictures[0];
            NSURL *url = [NSURL URLWithString:self.eventImageURL];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            self.eventPhoto.image = [UIImage imageWithData:imageData];
            
            self.eventLocation.text = myEvent.userFriendlyLocation;
            
            if(myEvent.categories.intValue == 0){ //How to fix that everything is food if none available
                self.categoryIndex.text = @"Food";
            }
            else if(myEvent.categories.intValue == 1){
                self.categoryIndex.text = @"Culture";
            }
            else if(myEvent.categories.intValue == 2){
                self.categoryIndex.text = @"Fitness";
            }
            else if(myEvent.categories.intValue == 3){
                self.categoryIndex.text = @"Education";
            }
            else if(myEvent.categories.intValue == 4){
                self.categoryIndex.text = @"Other";
            }
            else{
                self.categoryIndex.text = @"Not available";
            }
            
            self.card.layer.cornerRadius = 15;
            self.card.layer.masksToBounds = true;
        }
    }];

}

/*
- (void) fetchImage {
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    FIRStorageReference *eventImageRef = [storageRef child:@"images/02DC7684-D657-4B5B-82FC-8D1DA735E300"];
    
     [eventImageRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"Uh-oh, first error occurred: %@", error);
        } else {
            UIImage *eventImage = [UIImage imageWithData:data];
            self.eventPhoto.image = eventImage;
        }
    }];
    
}
*/

#pragma mark - Location methods

- (void)currentLocationIdentifier
{
    UserLocationManager = [CLLocationManager new];
    [UserLocationManager requestWhenInUseAuthorization];
    UserLocationManager.delegate = self;
    UserLocationManager.distanceFilter = kCLDistanceFilterNone;
    UserLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [[FirebaseManager sharedManager] getCurrentUser:^(User * _Nonnull user, NSError * _Nonnull error) {
        if(error == nil){
            self.currentUser = user;
            [self fetchEvents];
        }
    }];
    [UserLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.UserCurrentLocation = [locations objectAtIndex:0];
    [UserLocationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.UserCurrentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *Area = [[NSString alloc]initWithString:placemark.locality];
         [self.navigationItem.leftBarButtonItem setTitle:Area];
     }];
}


- (void) movingPreview {
    
    [UIView animateKeyframesWithDuration:1.0 delay:1.5 options:nil animations:^{self.card.frame = CGRectMake(self.card.frame.origin.x + 200, self.card.frame.origin.y - 75, self.card.frame.size.width, self.card.frame.size.height);
        
    } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{self.card.frame = CGRectMake(self.card.frame.origin.x - 200, self.card.frame.origin.y + 75, self.card.frame.size.width, self.card.frame.size.height);
                                    } completion:^(BOOL finished) {
                                      //self.animationInProgress = YES;
                                    }];
                                }];
    
    /*
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.2];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.card center].x - 20.0f, [self.card center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.card center].x + 20.0f, [self.card center].y)]];
    [[self.card layer] addAnimation:animation forKey:@"position"];
    */

}

#pragma mark - Choosing Events

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
            UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
            [myGen prepare];
            [myGen notificationOccurred:(UINotificationFeedbackTypeError)];
            myGen = NULL;
            [self nextEvent];
            //[self resetCard];
        }
        
        else if ((self.card.center.x) > (self.card.frame.size.width - 75)){
            //Move to right side
            [UIView animateWithDuration:0.3 animations:^{
                self.card.center = CGPointMake(self.card.center.x + 200, self.card.center.y + 75);
            }];
            
            Event *myEvent = self.eventArray.firstObject;
            
            FIRDocumentReference *eventRef = [[self.db collectionWithPath:@"Users"] documentWithPath:FIRAuth.auth.currentUser.uid];
            [eventRef updateData:@{ @"events": [FIRFieldValue fieldValueForArrayUnion:@[myEvent.eventIDRef]] }];
            [self nextEvent];
            UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
            [myGen prepare];
            [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
            myGen = NULL;
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
        self.card.alpha = 0;
        self.mapView.alpha = 0;
        
        self.emptyCard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        self.emptyCard.center = self.view.center;
        self.emptyCard.backgroundColor = [UIColor blackColor];
        self.emptyCard.layer.cornerRadius = 15;
        self.emptyCard.layer.masksToBounds = true;
        [self.view addSubview:self.emptyCard];
        
        self.noEventsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 200)];
        self.noEventsLabel.center = self.view.center;
        [self.noEventsLabel setText:@"No events found, create your own now!"];
        [self.noEventsLabel setNumberOfLines:0];
        [self.noEventsLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:self.noEventsLabel];
    }
    
    else {
        Event *nextEvent = self.eventArray.firstObject;
        self.numAttendees.text = [NSString stringWithFormat:@"%@", nextEvent.attendees];
        //self.categoryIndex.text = [NSString stringWithFormat:@"%@", nextEvent.categories];
        self.eventName.text = nextEvent.name;
        self.Eventdescription.text = nextEvent.descriptionEvent;
        [self eventLocationIdentifier];
        [self eventDateIdentifier];
        
        self.eventImageURL = nextEvent.pictures[0];
        NSURL *url = [NSURL URLWithString:self.eventImageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        self.eventPhoto.image = [UIImage imageWithData:imageData];
        
        [self resetCard];
        self.eventLocation.text = nextEvent.userFriendlyLocation;
        
        if(nextEvent.categories.intValue == 0){
            self.categoryIndex.text = @"Food";
        }
        else if(nextEvent.categories.intValue == 1){
            self.categoryIndex.text = @"Culture";
        }
        else if(nextEvent.categories.intValue == 2){
            self.categoryIndex.text = @"Fitness";
        }
        else if(nextEvent.categories.intValue == 3){
            self.categoryIndex.text = @"Education";
        }
        else if(nextEvent.categories.intValue == 4){
            self.categoryIndex.text = @"Other";
        }
        else{
            self.categoryIndex.text = @"Other";
        }
    }
}

- (void) resetCard {
    
    [UIView animateWithDuration:0.65 animations:^{
    [self.card setCenter:CGPointMake(self.view.center.x, self.view.center.y + 190)];
    }];
    
}

#pragma mark MKMapViewDelegate Methods

- (MKAnnotationView *)eventHomeView:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *eventView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:self.annotationID];
    eventView.canShowCallout = true;
    eventView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 50.0)];
    
    Event *event = self.eventArray.firstObject;
    
    if(event.categories.intValue == 0){
        eventView.image = [UIImage imageNamed:@"baseline_local_dining_black_18pt"];
    }
    else if(event.categories.intValue == 1){
        eventView.image = [UIImage imageNamed:@"baseline_color_lens_black_18pt"];
    }
    else if(event.categories.intValue == 2){
        eventView.image = [UIImage imageNamed:@"baseline_directions_run_black_18pt"];
    }
    else if(event.categories.intValue == 3){
        eventView.image = [UIImage imageNamed:@"baseline_local_library_black_18pt"];
    }
    else if(event.categories.intValue == 4){
        eventView.image = [UIImage imageNamed:@"baseline_event_black_18pt"];
    }
    else{
        eventView.image = [UIImage imageNamed:@"baseline_event_black_18pt"];
    }
    
    return eventView;
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    else {
        return [self eventHomeView:annotation];
    }
}

#pragma mark - Creating Event

- (void) eventLocationIdentifier {
    
    Event *event = self.eventArray.firstObject;
    
    MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:location animated:YES];
    
    MapAnnotation *eventAnnotation = [[MapAnnotation alloc] init];
    eventAnnotation.title = self.eventName.text;
    eventAnnotation.locationName = self.eventLocation.text;
    //eventAnnotation.placeName = [NSString stringWithFormat:@"%@", event.location];
    eventAnnotation.coordinate = location.center;
    
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
    [self fetchEvents];
    [self nextEvent];
    [self resetCard];
    
}

- (IBAction)CreateEventAction:(id)sender {
    [self performSegueWithIdentifier:@"CreateEventSegue" sender:nil];
//  [self resetCard]; Should I create a card for the created event or directly make a group
}

- (IBAction)resetAllCards:(UIBarButtonItem *)sender {
    [self fetchEvents];
    [self resetCard];
    
    self.emptyCard.alpha = 0;
    self.noEventsLabel.alpha = 0;
    self.card.alpha = 1;
    self.mapView.alpha = 1;
}

     
#pragma mark - Navigation
     
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"CreateEventSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        CreateEventViewController *createEventController = (CreateEventViewController *)navigationController.topViewController;
        createEventController.delegate = self;
    }
    
    /*
    else if ([segue.identifier isEqualToString: @"ChooseLocationSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        //LocationTableViewController *ChooseLocationController = (LocationTableViewController *)navigationController.topViewController;
        //ChooseLocationController.delegate = self;
    }
     */
}

#pragma mark - Change Location

- (IBAction)changeLocation:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Location" message:@"Insert the new location" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        [self getCoordinates:textField.text completionHandler:^(CLLocation *coordinates, NSError *error) {
            if(error == nil){
                [self.navigationItem.leftBarButtonItem setTitle:textField.text];
                [UserLocationManager stopUpdatingLocation];
                [self.eventArray removeAllObjects];
                self.UserCurrentLocation = coordinates;
                [self fetchEvents];
            }
        }];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:accept];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Place";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)getCoordinates : (NSString *) addressString completionHandler:(void(^)(CLLocation* coordinates, NSError *error))completion
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error != nil){
            completion(nil, error);
        }
        CLPlacemark *placemark = placemarks[0];
        if(placemark == nil){
            NSError *error = [[NSError alloc] init];
            
            completion(nil,error);
        }
        CLLocation *location = placemark.location;
        completion(location, nil);
    }];
    
}

@end
