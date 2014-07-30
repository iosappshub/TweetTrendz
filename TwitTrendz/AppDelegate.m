//
//  AppDelegate.m
//  TwitTrendz
//
//  Created by Nishant on 5/29/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "AppDelegate.h"
#import "TweetsViewController.h"
#import "TZNavigationController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "TwitterEngine.h"
#import <AudioToolbox/AudioToolbox.h>

#define APPLICATION_TYPE 2
#define PUSH_URL @"http://horaryastrology.in/public/push/register.json"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([self.window respondsToSelector:@selector(setTintColor:)])
        self.window.tintColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f]];
    
    TZNavigationController *navigationController = [[TZNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    MenuViewController *menuController = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];

    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = NO;
    frostedViewController.delegate = self;
    frostedViewController.limitMenuViewSize = YES;
    self.window.rootViewController = frostedViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark PushNotification
#pragma mark push notification methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceUDID = [[[[deviceToken description]
                              stringByReplacingOccurrencesOfString: @"<" withString: @""]
                             stringByReplacingOccurrencesOfString: @">" withString: @""]
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceUDID forKey:@"TOKEN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self sendDeviceDetails:deviceUDID];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Device is not registered for push notification : %@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *apsDictionary = [userInfo objectForKey:@"aps"];
    
    application.applicationIconBadgeNumber = [[apsDictionary objectForKey:@"badge"] intValue];
    
    if ([apsDictionary objectForKey:@"alert"] != nil) {
        SystemSoundID soundID;
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"push_notification" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        NSString *alert = [apsDictionary objectForKey:@"alert"];
        NSString *url = [apsDictionary objectForKey:@"url"];
        AMSmoothAlertView *alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:kApplicationName
                                                                                andText:alert andCancelButton:YES forAlertType:AlertInfo];
        [alertView.defaultButton setTitle:@"Okay" forState:UIControlStateNormal];
        alertView.cornerRadius = 3.0f;
        alertView.delegate = self;
        alertView.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
            if(button == alertObj.defaultButton) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            application.applicationIconBadgeNumber = 0;
        };
        [alertView show];
    }
}

- (void)receivedData:(NSData *)data
{
    NSError *error;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (responseDict != nil && error == nil) {
        if ([[responseDict objectForKey:@"code"] intValue] == 200) {
            NSLog(@"%@", responseDict);
            return;
        }
    }
    
    NSLog(@"Device is not registered for push notification!");
}

- (void)emptyReply
{
    NSLog(@"Device is not registered for push notification!");
}

- (void)timedOut
{
    NSLog(@"Device is not registered for push notification!");
}

- (void)receivedError:(NSError *)error
{
    NSLog(@"Device is not registered for push notification!");
}

- (void)sendDeviceDetails:(NSString *)deviceToken
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSUUID *vendorIdObject = [[UIDevice currentDevice] identifierForVendor];
    [dict setObject:[vendorIdObject UUIDString]  forKey:@"device_identifier"];
    [dict setObject:deviceToken forKey:@"device_udid"];
    [dict setObject:[NSNumber numberWithInt:APPLICATION_TYPE] forKey:@"application_type"];
    
    NSLog(@"Device Details : \n %@", dict);

    NSError *error;
    NSURL *url = [NSURL URLWithString:PUSH_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             [self performSelectorOnMainThread:@selector(receivedData:) withObject:data waitUntilDone:NO];
         } else if ([data length] == 0 && error == nil) {
             [self performSelectorOnMainThread:@selector(emptyReply) withObject:nil waitUntilDone:NO];
         } else if (error != nil && error.code == NSURLErrorTimedOut) {
             [self performSelectorOnMainThread:@selector(timedOut) withObject:nil waitUntilDone:NO];
         } else if (error != nil) {
             [self performSelectorOnMainThread:@selector(receivedError:) withObject:error waitUntilDone:NO];
         }
     }];
}

@end
