//
//  UserTimlineViewController.m
//  TwitTrendz
//
//  Created by Nishant on 6/4/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "UserTimlineViewController.h"
#import "TZNavigationController.h"
#import "TwitterEngine.h"
#import "AsyncImageView.h"
#import "AMSmoothAlertView.h"
#import "StatisticsViewController.h"
#import "ProfileViewController.h"

#define CELL_HEIGHT 100

#define PICTURE_TAG  1000
#define NAME_TAG  2000
#define TEXT_TAG  3000

@interface UserTimlineViewController ()

@end

@implementation UserTimlineViewController

@synthesize handleName = _handleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tweetsArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _handleName;
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Trendz"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showStatistics)];
    
    [tweetsTableView setRowHeight:CELL_HEIGHT];
    
    [self loadUserTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showStatistics
{
    StatisticsViewController *statisticsViewController = [[StatisticsViewController alloc] initWithNibName:@"StatisticsViewController" bundle:nil];
    statisticsViewController.tweetsArray = tweetsArray;
    statisticsViewController.profileUser = YES;
    [self.navigationController pushViewController:statisticsViewController animated:YES];
}

- (void)loadUserTweets
{
    self.navigationController.view.userInteractionEnabled = NO;
    [activityIndicator startAnimating];
    [[TwitterEngine singleton] getUserTweetsWithHandle:_handleName success:^(NSArray *tweets) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([tweets isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = (NSDictionary *)tweets;
                NSArray *errorArray = [errorDictionary objectForKey:@"errors"];
                NSString *errorString = [[errorArray firstObject] objectForKey:@"message"];
                AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:kApplicationName andText:errorString
                                                                                andCancelButton:NO forAlertType:AlertFailure];
                [alertView.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
                alertView.cornerRadius = 3.0f;
                [alertView show];
                return;
            }
            
            tweetsArray = tweets;
            [tweetsTableView reloadData];
            [activityIndicator stopAnimating];
            self.navigationController.view.userInteractionEnabled = YES;
        });
    } failure:^(NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            self.navigationController.view.userInteractionEnabled = YES;
            AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:kApplicationName andText:error
                                                                            andCancelButton:NO forAlertType:AlertFailure];
            [alertView.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
            alertView.cornerRadius = 3.0f;
            [alertView show];
        });
    }];
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweetsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellIdentifier_%ld", (long)indexPath.row];
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
    
    NSDictionary *tweetDictionary = [tweetsArray objectAtIndex:indexPath.row];
    
    NSString *screen_name = [[tweetDictionary objectForKey:@"user"] objectForKey:@"screen_name"];
    UILabel *nameLabelByTag = (UILabel *)[cell.contentView viewWithTag:NAME_TAG];
    nameLabelByTag.text = [NSString stringWithFormat:@"@%@", screen_name];
    
    UILabel *textLabelByTag = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    textLabelByTag.text = [tweetDictionary objectForKey:@"text"] ;
    
    NSString *urlString = [[tweetDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
    AsyncImageView *avatarImageViewByTag = (AsyncImageView *)[cell.contentView viewWithTag:PICTURE_TAG];
    avatarImageViewByTag.imageURL = backgroundImageURL;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *hashtagsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *tweetDictionary in tweetsArray) {
        NSDictionary *entitiesDictionary = [tweetDictionary objectForKey:@"entities"];
        NSArray *hashtagObjArray = [entitiesDictionary objectForKey:@"hashtags"];
        for (NSDictionary *hashtagDictionary in hashtagObjArray)
            if (![hashtagsArray containsObject:[hashtagDictionary objectForKey:@"text"]])
                [hashtagsArray addObject:[hashtagDictionary objectForKey:@"text"]];
    }
    
    NSDictionary *selectedTweetDictionary = [tweetsArray objectAtIndex:indexPath.row];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.profileDictionary = [selectedTweetDictionary objectForKey:@"user"];
    profileViewController.hashtagsArray = hashtagsArray;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

@end
