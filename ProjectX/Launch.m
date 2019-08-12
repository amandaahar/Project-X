//
//  Launch.m
//  ProjectX
//
//  Created by alexhl09 on 8/10/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "Launch.h"
#import <Pastel-Swift.h>
@interface Launch ()

@end

@implementation Launch

- (void)viewDidLoad {
    [super viewDidLoad];
    PastelView *pastelView = [[PastelView alloc] initWithFrame:self.view.bounds];
    
    [pastelView startAnimation];
    [self.view insertSubview:pastelView atIndex:0];
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
