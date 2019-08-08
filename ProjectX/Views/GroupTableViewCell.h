//
//  GroupTableViewCell.h
//  ProjectX
//
//  Created by amandahar on 7/17/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupTableViewCell : UITableViewCell
-(void)setNameOfChatText:(NSString *)nameOfChat;
-(void) setImage: (NSString *) photoURL;
- (void)setEventDateText:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
