//
//  HomeViewController.h
//  TwitTrendz
//
//  Created by Nishant on 5/31/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface HomeViewController : UIViewController
{
    IBOutlet AsyncImageView *avatarImageView;
    IBOutlet UILabel *friendsLabel;
    IBOutlet UILabel *followersLabel;
    IBOutlet UILabel *followingLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *tweetsLabel;
    IBOutlet UILabel *favouriteLabel;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@end
