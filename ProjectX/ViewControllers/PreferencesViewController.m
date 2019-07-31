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
#import "../Models/FirebaseManager.h"
#import "../Cells/PreferencesCollectionViewCell.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"
@interface PreferencesViewController () <BLBubbleSceneDataSource, BLBubbleSceneDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SKView *viewBubbles;
@property (nonatomic, strong) NSArray<Bubble *> *bubbles;
@property (nonatomic, strong) NSMutableArray *preferences;
@property (nonatomic, strong) NSMutableArray *preferencesDB;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation PreferencesViewController
BLBubbleScene *scene;
int numberOfBubbles = 0;
BOOL lastTime = false;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    NSLog(@"%@", FIRAuth.auth.currentUser.uid);
    self.preferences =  [NSMutableArray new];
    self.preferencesDB = [NSMutableArray new];
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        
        self.bubbles = [Bubble bubblesWithArray:categories];
        numberOfBubbles = (int)self.bubbles.count / 2;
        [scene reload];
    }];
   

}
- (IBAction)nextBubbleArray:(UIButton *)sender {
    if(!lastTime)
    {
        NSMutableArray<Bubble *> *myBubbles = [NSMutableArray new];
        for(size_t i = numberOfBubbles; i < self.bubbles.count; i++)
        {
            [myBubbles addObject:self.bubbles[i]];
        }
        self.bubbles = [myBubbles copy];
        numberOfBubbles = (int)myBubbles.count;
        for (SKNode *node in [scene children]) {
            if([node isKindOfClass:[BLBubbleNode class]])
            {
                [node removeFromParent];
            }
            
        }
        [scene reload];
        lastTime = YES;
    }else
    {
        for (SKNode *node in [scene children]) {
            if([node isKindOfClass:[BLBubbleNode class]])
            {
                [node removeFromParent];
            }
            
        }
        [scene reload];
        [[FirebaseManager sharedManager] setNewPreferences:[self.preferencesDB copy]];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        appDelegate.window.rootViewController = tabBarViewController;
        
    }
    
    
    
   
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

#pragma mark - Bubble Delegate

- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index
{

    NSLog(@"The bubble is now on state %ld", (long)[bubble.model bubbleState]);
    if((long)[bubble.model bubbleState] == 2)
    {
        if(self.preferences.count < 9)
        {
            Bubble * myBubble = bubble.model;
            NSNumber *index = myBubble.index;
            NSString *name = myBubble.name;
            
            [self.preferences addObject:bubble.model.bubbleText];
         
            NSDictionary * dicDB = [[NSDictionary alloc] initWithObjectsAndKeys: index ,@"id",name, @"short_name",  nil];
            [self.preferencesDB addObject:dicDB];


        }else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Too many categories" message:@"Remove one to add a new one" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleCancel) handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if((long)[bubble.model bubbleState] == 0)
    {
        [self.preferences removeObject:bubble.model.bubbleText];
    }
    NSLog(@"%@", self.preferences);
    [self.collectionView reloadData];
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
    return numberOfBubbles;
}

- (id<BLBubbleModel>)bubbleScene:(BLBubbleScene *)scene
           modelForBubbleAtIndex:(NSInteger)index
{
    return [self.bubbles objectAtIndex:index];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    PreferencesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.pillLabel setText:self.preferences[indexPath.row]];
   //[cell.pillLabel sizeToFit];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.preferences.count;
}


@end