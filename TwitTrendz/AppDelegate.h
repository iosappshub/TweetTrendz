//
//  AppDelegate.h
//  TwitTrendz
//
//  Created by Nishant on 5/29/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "AMSmoothAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate, AMSmoothAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
