//
//  MessagesViewController.h
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat.h"
#import "../Models/FirebaseManager.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessagesViewController : UIViewController
@property (strong, nonatomic) Chat *chat;


@end

NS_ASSUME_NONNULL_END
