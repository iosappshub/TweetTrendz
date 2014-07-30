//
//  SeachViewController.h
//  TwitTrendz
//
//  Created by Nishant on 6/3/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeachViewController : UIViewController
{
    BOOL handleSearch;
    IBOutlet UISearchBar *tweetSearchBar;
    IBOutlet UILabel *infoLabel;
    IBOutlet UITableView *tweetsTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSArray *tweetsArray;
}

@end
