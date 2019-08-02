//
//  HomeFeedTableViewCell.m
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "HomeFeedTableViewCell.h"
@import AFNetworking;
@import EventKit;
@implementation HomeFeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.addCalendarButton addTarget:self action:@selector(addEventToCalendar) forControlEvents:(UIControlEventTouchDown)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.titleEvent.text = [event name];
    self.descriptionEvent.text = [event summary];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: event.logo]];
    
    [self.imageEvent setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"]
                                      success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                          
                                          [UIView transitionWithView:self.imageEvent duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                                                                        [self.imageEvent setImage:image];
                                          } completion:nil];

                                          
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                          // do something for the failure condition
                                      }];
    self.imageEvent.layer.cornerRadius = 15;
    self.infoButton.layer.cornerRadius = 10;
    self.infoButton.clipsToBounds = YES;
    //self.api.text = [event api];
    
    [self.imageEvent setClipsToBounds:YES];

}

#pragma mark - Actions in the cell

-(void) addEventToCalendar{
   
    EKEventStore * store = [EKEventStore new];
    [store requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError * _Nullable error) {
        
        if(!granted)
        {
            return;
        }
        
    
        EKEvent *event = [EKEvent eventWithEventStore:store];
        [event setTitle:self.event.name];
        [event setStartDate:self.event.date];
        [event setEndDate:[event.startDate dateByAddingTimeInterval:60*60]];
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:self.event.name];
        
        
    }];
}

@end
