//
//  DetailHomeViewController.m
//  ProjectX
//
//  Created by alexhl09 on 7/25/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "DetailHomeViewController.h"
#import "../Models/MapAnnotation.h"
#import "../Models/FirebaseManager.h"
@import Contacts;
@import AFNetworking;
@interface DetailHomeViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageEvent;
@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *descriptionEvent;
@property (weak, nonatomic) IBOutlet UILabel *locationName;


@end

@implementation DetailHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView.layer setCornerRadius:self.mapView.frame.size.height/2];
    [self.mapView setClipsToBounds:YES];
    [self.createGroupButton.layer setCornerRadius:10];
    [self.createGroupButton setClipsToBounds:YES];
    [self.descriptionEvent setText:self.event.summary];
    [self.navigationItem setTitle:self.event.name];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.event.logo]];

    
    [self.imageEvent setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        [UIView transitionWithView:self.imageEvent duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                            [self.imageEvent setImage:image];
                                        } completion:nil];
                                        
                                        
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    self.mapView.delegate = self;
    CLLocationDistance regionRadius = 2000;
    
    MKCoordinateRegion location = MKCoordinateRegionMakeWithDistance(self.event.location, regionRadius, regionRadius);
    
    [self.mapView setRegion:location animated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    self.mapView.delegate = self;
    NSString *dateString = [formatter stringFromDate:self.event.date];
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithInfo:self.event.name :self.event.name :dateString :self.event.location ];
    [self.mapView addAnnotation:annotation];
    [self convertLatLongToAddress:self.event.location.latitude :self.event.location.longitude];
    
    
    // Do any additional setup after loading the view.
}
 - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MapAnnotation * myAnnotation = annotation;
    NSString *identifier = @"marker";
    MKMarkerAnnotationView *view= [MKMarkerAnnotationView new];
    MKMarkerAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(dequeuedView)
    {
        dequeuedView.annotation = myAnnotation;
        view = dequeuedView;
    }else{
        view = [[MKMarkerAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
        [view setCanShowCallout:YES];
        [view setCalloutOffset:CGPointMake(-5, 5)];
        UIButton * mapsButton = [[UIButton alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, 30, 30)];
        [mapsButton setBackgroundImage:[UIImage imageNamed:@"mapsIcon"] forState:(UIControlStateNormal)];
        
        [view setRightCalloutAccessoryView: mapsButton];
        
    }
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapAnnotation * location = view.annotation;
    UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
    [myGen prepare];
    [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
    myGen = NULL;
    [[location mapItem] openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
    
}

-(void) convertLatLongToAddress : (double) latitude : (double) longitude
{
    CLGeocoder * geoCoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks[0];
        
        [self.locationName setText: placemark.name];
    }];
}

- (IBAction)directionsToPlace:(UIButton *)sender {
    MapAnnotation * location = self.mapView.annotations[0];
    [[location mapItem] openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
}
- (IBAction)createGroup:(UIButton *)sender {
    [[FirebaseManager sharedManager] setNewAPIEvent:self.event completion:^(NSError * _Nonnull error) {
        if(error == nil)
        {
   
              self.tabBarController.selectedIndex = 2;
        }else{
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
                [myGen prepare];
                [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
                myGen = NULL;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

  
    
    
}

- (IBAction)shareEvent:(id)sender {
    NSArray* sharedObjects=[NSArray arrayWithObjects:[[self.event.name stringByAppendingString: self.event.summary] stringByAppendingString:self.event.date.description],  self.imageEvent.image,nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:^{
        UINotificationFeedbackGenerator *myGen = [[UINotificationFeedbackGenerator alloc] init];
        [myGen prepare];
        [myGen notificationOccurred:(UINotificationFeedbackTypeSuccess)];
        myGen = NULL;
    }];
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
