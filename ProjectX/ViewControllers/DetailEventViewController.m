//
//  DetailEventViewController.m
//  ProjectX
//
//  Created by aadhya on 7/28/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "DetailEventViewController.h"

@interface DetailEventViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventCategory;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *attendeesNo;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *userFriendlyLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;

@end

@implementation DetailEventViewController

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
