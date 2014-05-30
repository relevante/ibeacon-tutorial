//
//  IMViewController.h
//  iBeaconTemplate
//
//  Created by James Nick Sears on 5/29/14.
//  Copyright (c) 2014 iBeaconModules.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property IBOutlet UITableView *tableView;
@property (strong) NSArray *beacons;

@end
