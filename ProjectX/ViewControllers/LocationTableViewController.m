//
//  LocationTableViewController.m
//  ProjectX
//
//  Created by aadhya on 7/31/19.
//  Copyright © 2019 Charge. All rights reserved.
//

#import "LocationTableViewController.h"
#import <MapKit/MapKit.h>

@interface LocationTableViewController () <MKLocalSearchCompleterDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     UISearchController *resultSearchController = [[UISearchBar alloc] init];
    [UISearchBar sizeToFit];
    [UISearchBar setPlaceholder:@"Search for places"];
    UINavigationItem titleView = [resultSearchController.searchBar];
    
    resultSearchController hidesNavigationBarDuringPresentation = false;
     */
    
//    UISearchController *resultSearchController = nil;
//    LocationTableViewController = UIStoryboard
    
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    //searchController = [[UISearchController alloc] initWithSearchResultsController:LocationTableViewController];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/
    
    searchController.delegate = self;
//    searchController.searchResultsUpdater = self;
//    searchController.hidesNavigationBarDuringPresentation = false;
//    searchController.dimsBackgroundDuringPresentation = false;
    
    //searchController.searchResultsDataSource = self;
    //set the delegate = self. Previously declared in ViewController.h
    
    self.tableView.tableHeaderView = searchBar; //this line add the searchBar
    //on the top of tableView.
    

//    self.completer = [[MKLocalSearchCompleter alloc] init];
//    self.completer.delegate = self;
//
//    // Limit search results to the map view's current region.
//    self.completer.region = self.myMapView.region;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray *group1 = [[NSArray alloc] initWithObjects:@"Napoli", @"Juventus", @"Inter", @"Milan", @"Lazio", nil];
        NSArray *group2 = [[NSArray alloc] initWithObjects:@"Real Madrid", @"Barcelona", @"Villareal", @"Valencia", @"Deportivo", nil];
        NSArray *group3 = [[NSArray alloc] initWithObjects:@"Manchester City", @"Manchester United", @"Chelsea", @"Arsenal", @"Liverpool", nil];
        
        originalData = [[NSArray alloc] initWithObjects:group1, group2, group3, nil];
        searchData = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
