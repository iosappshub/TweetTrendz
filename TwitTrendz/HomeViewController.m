//
//  HomeViewController.m
//  TwitTrendz
//
//  Created by Nishant on 5/31/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "HomeViewController.h"
#import "TZNavigationController.h"
#import "TwitterEngine.h"
#import "AsyncImageView.h"
#import "AMSmoothAlertView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    self.navigationItem.title = @"Home";
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                    style:UIBarButtonItemStylePlain
                                                                    target:(TZNavigationController *)self.navigationController
                                                                    action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                    target:self action:@selector(showCompose)];
    
    
    avatarImageView.image = [UIImage imageNamed:@"Avatar"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 5.0;
    avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    avatarImageView.layer.borderWidth = 2.0f;
    
    [self loadProfile:[TwitterEngine singleton].profileDictionary];
    [self refreshProfile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfile)
                                                 name:UIApplicationWillEnterForegroundNotification  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showCompose
{
    if (![TwitterEngine singleton].profileDictionary) {
        AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:kApplicationName
                                                                andText:kTwitterConfigurationError andCancelButton:NO forAlertType:AlertFailure];
        [alertView.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
        alertView.cornerRadius = 3.0f;
        [alertView show];
        return;
    }
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller addImage:[UIImage imageNamed:@"icon.png"]];
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:kApplicationName
                                                        andText:@"Yeah, Tweet posted!" andCancelButton:NO forAlertType:AlertSuccess];
            [alertView.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
            alertView.cornerRadius = 3.0f;
            [alertView show];
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    
    controller.completionHandler = myBlock;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)loadProfile:(NSDictionary *)profileDictionary
{
    if (!profileDictionary)
        return;
    
    self.navigationItem.title = [profileDictionary objectForKey:@"name"];
    
    NSString *urlString = [profileDictionary objectForKey:@"profile_image_url"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *backgroundImageURL = [NSURL URLWithString:urlString];
    if (backgroundImageURL)
        [avatarImageView setImageURL:backgroundImageURL];
    
    friendsLabel.text = [[profileDictionary objectForKey:@"friends_count"] stringValue];
    followersLabel.text = [[profileDictionary objectForKey:@"followers_count"] stringValue];
    followingLabel.text = [[profileDictionary objectForKey:@"following"] stringValue];
    tweetsLabel.text = [[profileDictionary objectForKey:@"statuses_count"] stringValue];
    favouriteLabel.text = [[profileDictionary objectForKey:@"favourites_count"] stringValue];
    
    NSDictionary *statusDictionary = [profileDictionary objectForKey:@"status"];
    if (statusDictionary)
        descriptionLabel.text = [statusDictionary objectForKey:@"text"];
}

- (void)refreshProfile
{
    if ([TwitterEngine singleton].profileDictionary)
        return;
    
    self.navigationController.view.userInteractionEnabled = NO;
    [activityIndicator startAnimating];
    [[TwitterEngine singleton] getMyProfile:^(NSDictionary *profileDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadProfile:profileDictionary];
            [activityIndicator stopAnimating];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterProfileNotification object:nil];
        self.navigationController.view.userInteractionEnabled = YES;
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

@end
