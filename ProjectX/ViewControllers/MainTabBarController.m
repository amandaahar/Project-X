//
//  MainTabBarController.m
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIImpactFeedbackGenerator *myGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleHeavy)];
    [myGen impactOccurred];
    myGen = NULL;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController
{
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return false;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options: toIndex > fromIndex ? UIViewAnimationOptionCurveEaseIn : UIViewAnimationOptionCurveEaseOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
    
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
