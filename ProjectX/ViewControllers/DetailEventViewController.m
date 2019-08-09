//
//  DetailEventViewController.m
//  ProjectX
//
//  Created by aadhya on 7/28/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "DetailEventViewController.h"
#import "../Models/FirebaseManager.h"
#import "../Models/MapAnnotation.h"
@import Contacts;
@import AFNetworking;
@import Firebase;

@interface DetailEventViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *attendeesNo;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *userFriendlyLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSDate *dateNSEvent;
@property (strong, nonatomic) NSString *annotationID;
@property (nonatomic, strong) Event *myEvent;
@property (strong, nonatomic) NSString *eventImageURL;

@end

@implementation DetailEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEvents];
    //[self fetchImage];
    
    self.mapView.delegate = self;
    self.annotationID = @"Pin";
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:self.annotationID];
}

#pragma mark - Fetching Event details

- (void) fetchEvents
{
    [[FirebaseManager sharedManager] getCurrentEvent:self.detailEventID completion:^(Event * _Nonnull myEvent, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting event details.");
        }
        else {
            self.myEvent = myEvent;
            
            self.attendeesNo.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            self.eventDescription.text = myEvent.descriptionEvent;
            self.userFriendlyLocation.text = myEvent.userFriendlyLocation;
            self.eventCategory.text = myEvent.categories;
            
            self.eventImageURL = myEvent.pictures[0];
            NSURL *url = [NSURL URLWithString:self.eventImageURL];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            self.eventImage.image = [UIImage imageWithData:imageData];
            
            MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(myEvent.location.latitude, myEvent.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
            [self.mapView setRegion:location animated:YES];
            
            MapAnnotation *eventAnnotation = [[MapAnnotation alloc] init];
            eventAnnotation.title = self.eventName.text;
            eventAnnotation.locationName = self.userFriendlyLocation.text;
            //eventAnnotation.placeName = self.eventLocation.text;
            //eventAnnotation.placeName = [NSString stringWithFormat:@"%@", event.location];
            eventAnnotation.coordinate = location.center;
            [self.mapView addAnnotation:eventAnnotation];
            
//            FIRTimestamp *eventTimestamp = myEvent.date;
//            [self setDateNSEvent:eventTimestamp.dateValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            self.eventDate.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:myEvent.date]];
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
            self.eventImage.image = eventImage;
        }
    }];
}
 */

#pragma mark - Map

- (MKAnnotationView *)eventHomeView:(id<MKAnnotation>)annotation
{
    MKAnnotationView *eventView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:self.annotationID];
    eventView.canShowCallout = true;
    eventView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 50.0)];
        
    [[FirebaseManager sharedManager] getCurrentEvent:self.detailEventID completion:^(Event * _Nonnull myEvent, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting event details.");
        }
        else {
            self.myEvent = myEvent;
    
            if(myEvent.categories.intValue == 0){
                eventView.image = [UIImage imageNamed:@"baseline_local_dining_black_18pt"];
            }
            else if(myEvent.categories.intValue == 1){
                eventView.image = [UIImage imageNamed:@"baseline_color_lens_black_18pt"];
            }
            else if(myEvent.categories.intValue == 2){
                eventView.image = [UIImage imageNamed:@"baseline_directions_run_black_18pt"];
            }
            else if(myEvent.categories.intValue == 3){
                eventView.image = [UIImage imageNamed:@"baseline_local_library_black_18pt"];
            }
            else if(myEvent.categories.intValue == 4){
                eventView.image = [UIImage imageNamed:@"baseline_event_black_18pt"];
            }
            else{
                eventView.image = [UIImage imageNamed:@"baseline_event_black_18pt"];
            }
        }
        
    }];
    
    return eventView;
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [self eventHomeView:annotation];
}

- (IBAction)directionsToPlace:(UIButton *)sender
{
    [[FirebaseManager sharedManager] getCurrentEvent:self.detailEventID completion:^(Event * _Nonnull myEvent, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error getting event details.");
        }
        else {
            self.myEvent = myEvent;
            
            MapAnnotation * userLocation = self.mapView.annotations[0];
            userLocation.locationName = myEvent.userFriendlyLocation;
            userLocation.title = myEvent.name;
            MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(myEvent.location.latitude, myEvent.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
            userLocation.coordinate = location.center;
            
            MapAnnotation * locationAnnote = self.mapView.annotations.firstObject;
            UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
            [myGen prepare];
            [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
            myGen = NULL;
            [[locationAnnote mapItem] openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
        }
    }];
}

@end
