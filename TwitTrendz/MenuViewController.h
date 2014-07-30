//
//  MenuViewController.h
//  TwitTrendz
//
//  Created by Nishant on 5/31/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@class AsyncImageView;

@interface MenuViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titles;
    AsyncImageView *avatarImageView;
    UILabel *nameLabel;
}

@end
