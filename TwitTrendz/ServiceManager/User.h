//
//  User.h
//  TwitTrendz
//
//  Created by Nishant on 6/2/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileURL;
@property (nonatomic, strong) NSMutableArray *hashTagArray;
@property (nonatomic, assign) NSInteger tweetCounts;

@end
