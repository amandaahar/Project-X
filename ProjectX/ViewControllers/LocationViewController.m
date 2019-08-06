//
//  LocationViewController.m
//  ProjectX
//
//  Created by aadhya on 8/5/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface LocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UISegmentedControl *distanceSgementedControl;
@property (weak, nonatomic) IBOutlet UIButton *makeSoundButton;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (IBAction)soundAction:(id)sender {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop_drip" ofType:@"wav"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
}

/*
- (void)createGeoHash {
    int precision = 10;
    NSString *g_BASE32 = @"0123456789bcdefghijklmnopqrstuvwxyz";
    NSRange latitudeRange = NSMakeRange(-90, 90);
    NSRange longitudeRange = NSMakeRange(-180, 180);
    NSString *hash = @"";
    int hashVal = 0;
    int bits = 0;
    int even = 1;
    
    while (hash.length < precision) {
        int val = even;
        NSRange range = even ? longitudeRange : latitudeRange;
        double mid = range + range
        
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
