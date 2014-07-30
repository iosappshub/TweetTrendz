//
//  ProfileViewController.h
//  TwitTrendz
//
//  Created by Nishant on 6/4/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView;

@interface ProfileViewController : UIViewController
{
    IBOutlet AsyncImageView *avatarImageView;
    IBOutlet UILabel *hashTagLabel;
    IBOutlet UILabel *friendsLabel;
    IBOutlet UILabel *followersLabel;
    IBOutlet UILabel *followingLabel;
    IBOutlet UILabel *tweetsLabel;
    IBOutlet UILabel *favouriteLabel;
}

@property (nonatomic, strong) NSDictionary *profileDictionary;
@property (nonatomic, strong) NSMutableArray *hashtagsArray;

@end