//
//  MessageTableViewCell.h
//  ProjectX
//
//  Created by amandahar on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
-(void) setUserLabelText:(NSString *)userLabelText;
-(void) setMessageText:(NSString *)messageTextLabel;

@end

NS_ASSUME_NONNULL_END
