//
//  CreateEventViewController.h
//  ProjectX
//
//  Created by aadhya on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CreateEventControllerDelegate
- (void)didCreate:(Event *)newEvent;
@end

@interface CreateEventViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id <CreateEventControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
