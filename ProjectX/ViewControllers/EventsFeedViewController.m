//
//  EventsFeedViewController.m
//  ProjectX
//
//  Created by amandahar on 7/16/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "../Models/APIEventsManager.h"
@import CoreLocation;
@interface EventsFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewEventCategories;
@property (strong, nonnull) NSArray *categories;
@end

@implementation EventsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewEventCategories.delegate = self;
    self.tableViewEventCategories.dataSource = self;

    
    [[APIEventsManager sharedManager] getCategories:^(NSArray * _Nonnull categories, NSError * _Nonnull error) {
        NSLog(@"%@",categories);
        self.categories = categories;
        [self.tableViewEventCategories reloadData];
    }];
    
   
    // Do any additional setup after loading the view.
}

     
     
     

#pragma mark - Protocol functions

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"cellCategory";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.categories[indexPath.section][@"name"];
    cell.detailTextLabel.text = self.categories[indexPath.section][@"resource_uri"];
    [[APIEventsManager sharedManager] getEventByCategory:self.categories[indexPath.section][@"id"] completion:^(NSArray * _Nonnull events, NSError * _Nonnull error) {
        
    }];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categories.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categories[section][@"name"];
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
