//
//  TwitterEngine.h
//  TwitTrendz
//
//  Created by Nishant on 5/29/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

extern NSString * const kApplicationName;
extern NSString * const kTwitterConfigurationError;
extern NSString * const kTwitterProfileNotification;

@interface TwitterEngine : NSObject
{
    ACAccount *twitterAccount;
}

@property (nonatomic, retain) NSDictionary *profileDictionary;

+ (TwitterEngine *)singleton;

- (void)getMyProfile:(void (^)(NSDictionary *profileDictionary))success failure:(void (^)(NSString *error))failure;
- (void)getHomeTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure;
- (void)getMyTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure;
- (void)getMentionedTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure;
- (void)search:(NSString *)query success:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure;
- (void)getUserTweetsWithHandle:(NSString *)handleName success:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure;

@end
