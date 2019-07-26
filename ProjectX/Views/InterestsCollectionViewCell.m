//
//  InterestsCollectionViewCell.m
//  ProjectX
//
//  Created by amandahar on 7/26/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "InterestsCollectionViewCell.h"


@interface InterestsCollectionViewCell()
@property (weak, nonatomic) IBOutlet PillLabel *interestLabel;

@end

@implementation InterestsCollectionViewCell

- (void) setInterestLabelText:(NSString *)interestLabelText {
    self.interestLabel.text = interestLabelText;
}

@end
