//
//  LocationViewController.m
//  ProjectX
//
//  Created by aadhya on 8/5/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSgementedControl;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
