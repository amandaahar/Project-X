//
//  topCollectionViewCell.m
//  ProjectX
//
//  Created by alexhl09 on 7/19/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "topCollectionViewCell.h"
@import AFNetworking;
@implementation topCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

/**
 setMyEvent
 Description:
 This method is going to set the properties fo the cell dependieng of the event sent by the table view. And also the image from the event is downloaded and loaded in the image view.
 
 -Parameters:
 
 -event: Its a object EventAPI that stores the information of the event to be displayed in the details view
 */

-(void) setMyEvent:(EventAPI *)event
{
    self.event = event;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: event.logo]];

    self.imageEvent.layer.cornerRadius = 20;
    self.imageEvent.clipsToBounds = YES;
    [self.imageEvent setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"]
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        [UIView transitionWithView:self.imageEvent duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                            [self.imageEvent setImage:image];
                                            
                                        } completion:nil];
                                        
                                        
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    [self.titleEvent setText:event.name];
    [self.descriptionEvent setText:event.summary];
    
}

@end
