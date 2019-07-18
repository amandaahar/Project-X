//
//  EventsFeedViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "../Models/APIEventsManager.h"
#import "../Models/EventAPI.h"
@import CoreLocation;
@interface EventsFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventCategories;
@property (strong, nonnull) NSMutableArray *events;
@end

@implementation EventsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewEventCategories.delegate = self;
    self.tableViewEventCategories.dataSource = self;
    self.events = [NSMutableArray new];
    
    [[APIEventsManager sharedManager] getEventsByLocation:@"" longitude:@"" completion:^(NSArray * _Nonnull eventsEventbrite, NSArray * _Nonnull eventsTicketmaster, NSError * _Nonnull error) {
        
        for(NSDictionary * eventbriteDic in eventsEventbrite)
        {
            [self.events addObject:[[EventAPI alloc] initWithInfo:eventbriteDic[@"name"][@"text"] :eventbriteDic[@"summary"] :eventbriteDic[@"id"] :eventbriteDic[@"start"][@"local"] :eventbriteDic[@"logo"][@"url"]]];
        }
        for(NSDictionary * ticketmasterDic in eventsTicketmaster)
        {
            [self.events addObject:[[EventAPI alloc] initWithInfo:ticketmasterDic[@"name"] :ticketmasterDic[@"name"] :ticketmasterDic[@"id"] :ticketmasterDic[@"dates"][@"start"][@"dateTime"] :ticketmasterDic[@"images"][0][@"url"]]];
        }
        [self.tableViewEventCategories reloadData];
        
      
    }];
    
   
    // Do any additional setup after loading the view.
}

     
     
     

#pragma mark - Protocol functions

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"cellCategory";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [self.events[indexPath.section] name];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.events.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.events[section] name];
}
     

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
