//
//  DetailHomeViewController.h
//  ProjectX
//
//  Created by alexhl09 on 7/25/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/EventAPI.h"
@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@interface DetailHomeViewController : UIViewController
@property (strong, nonatomic) EventAPI * event;
@end

NS_ASSUME_NONNULL_END
