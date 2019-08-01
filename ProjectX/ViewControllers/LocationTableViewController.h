//
//  LocationTableViewController.h
//  ProjectX
//
//  Created by aadhya on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationTableViewController : UITableViewController
{
    NSArray *originalData;
    NSMutableArray *searchData;
    UISearchBar *searchBar;
    UISearchController *searchController;
}

//@property (nonatomic, weak) id <ChooseLocationController> delegate;
//@property(nonatomic, weak) id<UITableViewDataSource> searchResultsDataSource;

@end

NS_ASSUME_NONNULL_END
