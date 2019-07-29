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
#import "Map.h"
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
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSDate *dateNSEvent;
@property (strong, nonatomic) NSString *annotationID;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

@implementation DetailEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    [self fetchImage];
    
    self.db = [FIRFirestore firestore];
    self.mapView.delegate = self;
    self.annotationID = @"Pin";
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:self.annotationID];
    self.eventArray = [NSMutableArray new];
    
}

#pragma mark - Fetching Events

- (void) fetchEvents {
    
    [[FirebaseManager sharedManager] getEvents:^(NSArray * _Nonnull event, NSError * _Nonnull error) {
        if(error != nil)
        {
            NSLog(@"Error showing documents: %@", error);
        }else
        {
            Event * myEvent = event.firstObject;
            
            self.attendeesNo.text = [NSString stringWithFormat:@"%@", myEvent.attendees];
            //self.eventName.text = myEvent.name;
            self.eventDescription.text = myEvent.descriptionEvent;
            self.eventArray = event;
            self.eventID = myEvent.eventID;
            [self eventDateIdentifier];
            [self eventLocationIdentifier];
//            self.eventLocation.text =
            self.userFriendlyLocation.text = myEvent.userFriendlyLocation;
        }
    }];
    
}

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

#pragma mark - Creating Event

- (void) eventLocationIdentifier {
    
    Event *event = self.eventArray.firstObject;
    
    MKCoordinateRegion location = MKCoordinateRegionMake(CLLocationCoordinate2DMake(event.location.latitude, event.location.longitude), MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:location animated:YES];

    Map *eventAnnotation = [[Map alloc] init];
    eventAnnotation.title = self.eventName.text;
    //eventAnnotation.placeName = self.eventLocation.text;
    //eventAnnotation.placeName = @"testing location";
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

/*
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MapAnnotation * location = view.annotation;
    [[location mapItem] openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
    
}

- (IBAction)directionsToPlace:(UIButton *)sender {
    MapAnnotation * location = self.mapView.annotations[0];
    [[location mapItem] openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
}
*/

- (MKAnnotationView *)eventHomeView:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *eventView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:self.annotationID];
    eventView.canShowCallout = true;
    eventView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 50.0)];
    //eventView.image = [UIImage imageNamed:@"home"];
    
    Event *event = self.eventArray.firstObject;
    
    if(event.categories.intValue == 0){
        //self.categoryIndex.text = @"Food";
        eventView.image = [UIImage imageNamed:@"baseline_local_dining_black_18pt"];
    }
    else if(event.categories.intValue == 1){
        // self.categoryIndex.text = @"Culture";
        eventView.image = [UIImage imageNamed:@"baseline_color_lens_black_18pt"];
    }
    else if(event.categories.intValue == 2){
        //self.categoryIndex.text = @"Fitness";
        eventView.image = [UIImage imageNamed:@"baseline_directions_run_black_18pt"];
    }
    else if(event.categories.intValue == 3){
        //self.categoryIndex.text = @"Education";
        eventView.image = [UIImage imageNamed:@"baseline_local_library_black_18pt"];
    }
    else if(event.categories.intValue == 4){
        //self.categoryIndex.text = @"Other";
        eventView.image = [UIImage imageNamed:@"baseline_event_black_18pt"];
    }
    else{
        //self.categoryIndex.text = @" ";
        eventView.image = [UIImage imageNamed:@"home"];
    }
    
    return eventView;
    
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    return [self eventHomeView:annotation];
}

@end
