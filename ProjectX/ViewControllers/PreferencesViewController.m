//
//  PreferencesViewController.m
//  ProjectX
//
//  Created by alexhl09 on 7/27/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "PreferencesViewController.h"
#import "../Models/Bubble.h"
#import "../Models/APIEventsManager.h"
@interface PreferencesViewController () <BLBubbleSceneDataSource, BLBubbleSceneDelegate>
@property (weak, nonatomic) IBOutlet SKView *viewBubbles;
@property (nonatomic, strong) NSArray<Bubble *> *bubbles;
@property (nonatomic, strong) NSMutableArray *preferences;
@property (weak, nonatomic) IBOutlet UILabel * listPreferences;
@end

@implementation PreferencesViewController
BLBubbleScene *scene;

- (void)viewDidLoad
{
    self.preferences =  [NSMutableArray new];
    [super viewDidLoad];
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        
        self.bubbles = [Bubble bubblesWithArray:categories];
        [scene reload];
    }];
   

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    scene = [BLBubbleScene sceneWithSize:CGSizeMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0)];
    scene.backgroundColor = [UIColor whiteColor];
    scene.bubbleDataSource = self;
    scene.bubbleDelegate = self;

    
    [self.viewBubbles presentScene:scene];
}

#pragma mark Bubble Delegate

- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index
{
    NSLog(@"Bubble Pressed! %@", bubble.fillColor);

    NSLog(@"The bubble is now on state %ld", (long)[bubble.model bubbleState]);
    if((long)[bubble.model bubbleState] == 2)
    {
        [self.preferences addObject:bubble.model.bubbleText];
    }else if((long)[bubble.model bubbleState] == 0)
    {
        [self.preferences removeObject:bubble.model.bubbleText];
    }
    NSLog(@"%@", self.preferences);
    
}
- (CGFloat)bubbleRadiusForBubbleScene:(BLBubbleScene *)scene
{
    return 25;
}

- (CGFloat)bubbleFontSizeForBubbleScene:(BLBubbleScene *)scene
{
    return 7;
}
- (UIColor *)bubbleScene:(BLBubbleScene *)scene bubbleStrokeColorForState:(BLBubbleNodeState)state
{
    return [UIColor clearColor];
}

- (UIColor *)bubbleScene:(BLBubbleScene *)scene bubbleFillColorForState:(BLBubbleNodeState)state{
    return [UIColor redColor];
}


#pragma mark Bubble Data Source

- (NSInteger)numberOfBubblesInBubbleScene:(BLBubbleScene *)scene
{
    return self.bubbles.count;
}

- (id<BLBubbleModel>)bubbleScene:(BLBubbleScene *)scene
           modelForBubbleAtIndex:(NSInteger)index
{
    return [self.bubbles objectAtIndex:index];
}

@end
