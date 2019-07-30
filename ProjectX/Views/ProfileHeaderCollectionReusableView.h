//
//  ProfileHeaderCollectionReusableView.h
//  ProjectX
//
//  Created by amandahar on 7/30/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderCollectionReusableView : UICollectionReusableView

- (void) setProfileImageWithURL:(NSString *)photoURL;

- (void) setNameText:(NSString *)name;

- (void) setUsernameText:(NSString *)username;

- (void) setBioText:(NSString *)bio;

@end

NS_ASSUME_NONNULL_END
