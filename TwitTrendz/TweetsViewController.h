//
//  TweetsViewController.h
//  TwitTrendz
//
//  Created by Nishant on 5/29/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum tweetTypes {
    wallTweets = 1,
    myTweets,
    mentionedTweets} TweetTypes;

@interface TweetsViewController : UIViewController
{
    IBOutlet UITableView *tweetsTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSArray *tweetsArray;
}

@property (nonatomic, assign) NSInteger tweetType;

@end
