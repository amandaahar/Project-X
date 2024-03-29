//
//  CategoriesCollectionViewCell.m
//  ProjectX
//
//  Created by alexhl09 on 7/18/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "CategoriesCollectionViewCell.h"
#import "HomeFeedTableViewCell.h"
#import "../Models/EventAPI.h"

@implementation CategoriesCollectionViewCell

NSDateFormatter *dateFormat2;

- (void)awakeFromNib {
    [super awakeFromNib];
    dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MM/dd/YY"];
    self.threeEvents = [NSArray new];
    self.tableViewEvents.delegate = self;
    self.tableViewEvents.dataSource = self;
    [self.tableViewEvents reloadData];
}

#pragma mark - Protocol methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"feedCell";
    HomeFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"HomeFeedTableViewCell" bundle:nil] forCellReuseIdentifier:@"feedCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }

    [cell setMyEvent:self.threeEvents[indexPath.row]];
    NSString *dateString = [dateFormat2 stringFromDate:[self.threeEvents[indexPath.row] date]];
    [cell.api setText:dateString];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.threeEvents.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedEvent" object:self.threeEvents[indexPath.row]];
    
    
}





@end
