//
//  MessageBubble.h
//  ProjectX
//
//  Created by alexhl09 on 7/22/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageBubble : UITableViewCell
@property (nonatomic, strong) NSString * text;
-(void) setMyText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
