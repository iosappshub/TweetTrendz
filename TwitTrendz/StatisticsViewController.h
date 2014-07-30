//
//  StatisticsViewController.h
//  TwitTrendz
//
//  Created by Nishant on 6/3/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController
{
    IBOutlet UITableView *tweetsTableView;
    NSArray *usersArray;
    NSArray *retweetsArray;
    NSArray *favoritesArray;
}

@property (nonatomic, strong) NSArray *tweetsArray;
@property (nonatomic, assign) BOOL profileUser;
@end
