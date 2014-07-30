//
//  UserTimlineViewController.h
//  TwitTrendz
//
//  Created by Nishant on 6/4/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTimlineViewController : UIViewController
{
    IBOutlet UITableView *tweetsTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSArray *tweetsArray;
}

@property (nonatomic, strong) NSString *handleName;

@end
