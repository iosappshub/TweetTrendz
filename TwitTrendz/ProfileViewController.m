//
//  ProfileViewController.m
//  TwitTrendz
//
//  Created by Nishant on 6/4/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "ProfileViewController.h"
#import "TZNavigationController.h"
#import "TwitterEngine.h"
#import "AsyncImageView.h"
#import "AMSmoothAlertView.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileDictionary = _profileDictionary;
@synthesize hashtagsArray = _hashtagsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"...";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    else
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f], NSForegroundColorAttributeName,
                                    [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f], NSBackgroundColorAttributeName,
                                    [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f], UITextAttributeTextColor,
                                    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextShadowColor,
                                    nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;

    avatarImageView.image = [UIImage imageNamed:@"Avatar"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 5.0;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 2.0f;
    
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadProfile
{
    if (!_profileDictionary)
        return;
    
    self.navigationItem.title = [_profileDictionary objectForKey:@"name"];
    
    NSString *urlString = [_profileDictionary objectForKey:@"profile_image_url"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
    if (backgroundImageURL)
        [avatarImageView setImageURL:backgroundImageURL];
    
    friendsLabel.text = [[_profileDictionary objectForKey:@"friends_count"] stringValue];
    followersLabel.text = [[_profileDictionary objectForKey:@"followers_count"] stringValue];
    followingLabel.text = [[_profileDictionary objectForKey:@"following"] stringValue];
    tweetsLabel.text = [[_profileDictionary objectForKey:@"statuses_count"] stringValue];
    favouriteLabel.text = [[_profileDictionary objectForKey:@"favourites_count"] stringValue];
    
    NSString *hashtagString = @"";
    for (int count = 0; count < [_hashtagsArray count]; count++) {
        
        if (count == [_hashtagsArray count] - 1) {
            NSString *hashtag = [NSString stringWithFormat:@"#%@", [_hashtagsArray objectAtIndex:count]];
            hashtagString = [hashtagString stringByAppendingString:hashtag];
        }
        else {
            NSString *hashtag = [NSString stringWithFormat:@"#%@, ", [_hashtagsArray objectAtIndex:count]];
            hashtagString = [hashtagString stringByAppendingString:hashtag];
        }
    }
    hashTagLabel.text = hashtagString;
}

@end
