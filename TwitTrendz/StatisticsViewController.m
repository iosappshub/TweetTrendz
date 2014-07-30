//
//  StatisticsViewController.m
//  TwitTrendz
//
//  Created by Nishant on 6/3/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "StatisticsViewController.h"
#import "TZNavigationController.h"
#import "TwitterEngine.h"
#import "AsyncImageView.h"
#import "AMSmoothAlertView.h"
#import "StatisticsViewController.h"
#import "UserTimlineViewController.h"
#import "ProfileViewController.h"
#import "User.h"

#define CELL_HEIGHT 100
#define TOP_COUNTS 10

#define PICTURE_TAG  1000
#define NAME_TAG  2000
#define TEXT_TAG  3000

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

@synthesize tweetsArray = _tweetsArray;
@synthesize profileUser = _profileUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        usersArray = [[NSArray alloc] init];
        favoritesArray = [[NSArray alloc] init];
        retweetsArray = [[NSArray alloc] init];
        _profileUser = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Statistics";
    
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
    
    [tweetsTableView setRowHeight:CELL_HEIGHT];
    
    [self parseTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)parseTweets
{
    NSMutableDictionary *usersDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *tweetDictionary in _tweetsArray) {
        
        NSDictionary *userDictionary = [tweetDictionary objectForKey:@"user"];
        NSString *key = [userDictionary objectForKey:@"screen_name"];
        
        User *userObj = [usersDictionary objectForKey:key];
        if (userObj == nil) {
            userObj = [[User alloc] init];
            userObj.screenName = [userDictionary objectForKey:@"screen_name"];
            userObj.name = [userDictionary objectForKey:@"name"];
            userObj.profileURL = [userDictionary objectForKey:@"profile_image_url"];
            userObj.tweetCounts = 0;
        }
        userObj.tweetCounts++;
        [usersDictionary setObject:userObj forKey:key];
    }
    
    NSArray *allUsersArray = [usersDictionary allValues];
    NSSortDescriptor *usersSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweetCounts" ascending:NO];
    usersArray = [allUsersArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:usersSortDescriptor]];
    if ([usersArray count] >= TOP_COUNTS)
        usersArray = [usersArray subarrayWithRange:NSMakeRange(0, TOP_COUNTS)];
    
    NSSortDescriptor *favoritesSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"favorite_count" ascending:NO];
    favoritesArray = [_tweetsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:favoritesSortDescriptor]];
    if ([favoritesArray count] >= TOP_COUNTS)
        favoritesArray = [favoritesArray subarrayWithRange:NSMakeRange(0, TOP_COUNTS)];
    
    NSSortDescriptor *retweetSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"retweet_count" ascending:NO];
    retweetsArray = [_tweetsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:retweetSortDescriptor]];
    if ([retweetsArray count] >= TOP_COUNTS)
        retweetsArray = [retweetsArray subarrayWithRange:NSMakeRange(0, TOP_COUNTS)];
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 34)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor =[UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:15];
    nameLabel.textColor = [UIColor whiteColor];
    
    switch (sectionIndex) {
        case 0:
            nameLabel.text = @"Top Active Users:";
            break;
        case 1:
            nameLabel.text = @"Top Favorites:";
            break;
        case 2:
            nameLabel.text = @"Top Retweets:";
            break;
        default:
            break;
    }
    
    [view addSubview:nameLabel];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [usersArray count];
            break;
        case 1:
            return [favoritesArray count];
            break;
        case 2:
            return [retweetsArray count];
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 60;
        
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        AsyncImageView *avatarImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 25, 48, 48)];
        avatarImageView.tag = PICTURE_TAG;
        avatarImageView.image = [UIImage imageNamed:@"Avatar"];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 24.0;
        avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        avatarImageView.layer.borderWidth = 3.0f;
        avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatarImageView.layer.shouldRasterize = YES;
        avatarImageView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarImageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 250, 25)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor =[UIColor clearColor];
        nameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:15];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.tag = NAME_TAG;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 250, 60)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.backgroundColor =[UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];;
        textLabel.tag = TEXT_TAG;
        textLabel.numberOfLines = 4;
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *nameLabelByTag = (UILabel *)[cell.contentView viewWithTag:NAME_TAG];
    UILabel *textLabelByTag = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    AsyncImageView *avatarImageViewByTag = (AsyncImageView *)[cell.contentView viewWithTag:PICTURE_TAG];
    
    switch (indexPath.section) {
        case 0:
        {
            User *userObj = [usersArray objectAtIndex:indexPath.row];
            nameLabelByTag.text = [NSString stringWithFormat:@"@%@ (%lu%%)", userObj.screenName,
                                   (long)(userObj.tweetCounts * 100) / [_tweetsArray count]];
            NSURL *backgroundImageURL = [NSURL URLWithString:userObj.profileURL];
            avatarImageViewByTag.imageURL = backgroundImageURL;
            
            nameLabelByTag.frame = CGRectMake(60, 5, 250, 25);
            textLabelByTag.frame = CGRectMake(60, 35, (userObj.tweetCounts * 250) / [_tweetsArray count], 20);
            textLabelByTag.backgroundColor = [UIColor orangeColor];
            avatarImageViewByTag.frame = CGRectMake(5, 5, 48, 48);
        }
            break;
        case 1:
        {
            NSDictionary *tweetDictionary = [favoritesArray objectAtIndex:indexPath.row];
            
            NSString *screen_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"screen_name"];
            NSInteger favoritesCount = [[tweetDictionary objectForKey:@"favorite_count"] integerValue];
            
            nameLabelByTag.text = [NSString stringWithFormat:@"@%@ (%ld)", screen_name, (long)favoritesCount];
            textLabelByTag.text = [tweetDictionary objectForKey:@"text"];
            
            NSString *urlString = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
            NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
            avatarImageViewByTag.imageURL = backgroundImageURL;
        }
            break;
        case 2:
        {
            NSDictionary *tweetDictionary = [retweetsArray objectAtIndex:indexPath.row];
            
            NSString *screen_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"screen_name"];
            NSInteger retweetsCount = [[tweetDictionary objectForKey:@"retweet_count"] integerValue];
            
            nameLabelByTag.text = [NSString stringWithFormat:@"@%@ (%ld)", screen_name, (long)retweetsCount];
            textLabelByTag.text = [tweetDictionary objectForKey:@"text"];
            
            NSString *urlString = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
            NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
            avatarImageViewByTag.imageURL = backgroundImageURL;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_profileUser) {
        NSMutableArray *hashtagsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tweetDictionary in _tweetsArray) {
            NSDictionary *entitiesDictionary = [tweetDictionary objectForKey:@"entities"];
            NSArray *hashtagObjArray = [entitiesDictionary objectForKey:@"hashtags"];
            for (NSDictionary *hashtagDictionary in hashtagObjArray)
                if (![hashtagsArray containsObject:[hashtagDictionary objectForKey:@"text"]])
                    [hashtagsArray addObject:[hashtagDictionary objectForKey:@"text"]];
        }
        
        NSDictionary *selectedTweetDictionary = [_tweetsArray objectAtIndex:indexPath.row];
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        profileViewController.profileDictionary = [selectedTweetDictionary objectForKey:@"user"];
        profileViewController.hashtagsArray = hashtagsArray;
        [self.navigationController pushViewController:profileViewController animated:YES];
        return;
    }
    
    NSString *screen_name = @"";
    switch (indexPath.section) {
        case 0:
        {
            User *userObj = [usersArray objectAtIndex:indexPath.row];
            screen_name = userObj.screenName;
        }
            break;
        default:
        {
            NSDictionary *tweetDictionary = [favoritesArray objectAtIndex:indexPath.row];
            screen_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"screen_name"];
        }
            break;
    }
    
    UserTimlineViewController *userTimlineViewController = [[UserTimlineViewController alloc] initWithNibName:@"UserTimlineViewController" bundle:nil];
    userTimlineViewController.handleName = [NSString stringWithFormat:@"@%@", screen_name];
    [self.navigationController pushViewController:userTimlineViewController animated:YES];
}

@end
