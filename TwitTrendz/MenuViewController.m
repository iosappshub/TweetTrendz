//
//  MenuViewController.m
//  TwitTrendz
//
//  Created by Nishant on 5/31/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "TZNavigationController.h"
#import "HomeViewController.h"
#import "TweetsViewController.h"
#import "SeachViewController.h"
#import "TwitterEngine.h"
#import "AsyncImageView.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    else
        self.tableView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfile)
                                                 name:kTwitterProfileNotification object:nil];
    
    titles = @[@"Search & Trendz", @"My Wall", @"I, Me & Myself", @"Yeah, I'm famous!"];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
        avatarImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        avatarImageView.image = [UIImage imageNamed:@"Avatar"];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 50.0;
        avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        avatarImageView.layer.borderWidth = 3.0f;
        avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        avatarImageView.layer.shouldRasterize = YES;
        avatarImageView.clipsToBounds = YES;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 200, 30)];
        nameLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:18];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.minimumScaleFactor = 0.5;
        
        UIButton *profileButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 184)];
        [profileButton addTarget:self action:@selector(profilePressed) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:avatarImageView];
        [view addSubview:nameLabel];
        [view addSubview:profileButton];
        
        view;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshProfile];
}

- (void)refreshProfile
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *profileDictionary = [TwitterEngine singleton].profileDictionary;
        if (profileDictionary) {
            NSString *urlString = [profileDictionary objectForKey:@"profile_image_url"];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
            if (backgroundImageURL)
                [avatarImageView setImageURL:backgroundImageURL];
            [nameLabel setText:[NSString stringWithFormat:@"@%@", [profileDictionary objectForKey:@"screen_name"]]];
            [self.tableView reloadData];
        }
    });
}

- (void)profilePressed
{
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    TZNavigationController *navigationController = [[TZNavigationController alloc] initWithRootViewController:homeViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:18];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        SeachViewController *seachViewController = [[SeachViewController alloc] initWithNibName:@"SeachViewController" bundle:nil];
        TZNavigationController *navigationController = [[TZNavigationController alloc] initWithRootViewController:seachViewController];
        self.frostedViewController.contentViewController = navigationController;
    }
    else {
        TweetsViewController *tweetsViewController = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
        tweetsViewController.tweetType = indexPath.row;
        TZNavigationController *navigationController = [[TZNavigationController alloc] initWithRootViewController:tweetsViewController];
        self.frostedViewController.contentViewController = navigationController;
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

@end

