//
//  TwitterEngine.m
//  TwitTrendz
//
//  Created by Nishant on 5/29/14.
//  Copyright (c) 2014 TechFlitter. All rights reserved.
//

#import "TwitterEngine.h"
#import "NSString+URLEncoding.h"

NSString * const kApplicationName = @"TwitTrendz";
NSString * const kTwitterConfigurationError = @"Twitter not configured or permission not provided. Please go to Settings -> Twitter or contact us for more support.";
NSString * const kTwitterProfileNotification = @"kTwitterProfileNotification";

@implementation TwitterEngine

@synthesize profileDictionary = _profileDictionary;

+ (TwitterEngine *)singleton
{
    static TwitterEngine *shareManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    
    return shareManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)getMyProfile:(void (^)(NSDictionary *profile))success failure:(void (^)(NSString *error))failure
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 twitterAccount = [arrayOfAccounts lastObject];
                 NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                 
                 NSDictionary *parameters = @{@"screen_name" : twitterAccount.username};
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 postRequest.account = twitterAccount;
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      if (error)
                          return failure([error localizedDescription]);
                      
                      _profileDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                      return success(_profileDictionary);
                  }];
             }
             else {
                 return failure(kTwitterConfigurationError);
             }
         } else {
             return failure(kTwitterConfigurationError);
         }
     }];
}

- (void)getHomeTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure
{
    if (twitterAccount == nil)
        return failure(kTwitterConfigurationError);
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *parameters = @{@"screen_name" : twitterAccount.username, @"include_rts" : @"1", @"trim_user" : @"0", @"count" : @"200"};
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:parameters];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
             return failure([error localizedDescription]);
         
         NSArray *tweetsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (error)
             return failure([error localizedDescription]);
         return success(tweetsArray);
     }];
}

- (void)getMyTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure
{
    if (twitterAccount == nil)
        return failure(kTwitterConfigurationError);
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    NSDictionary *parameters = @{@"screen_name" : twitterAccount.username, @"include_rts" : @"1", @"trim_user" : @"0", @"count" : @"200"};
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:parameters];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
             return failure([error localizedDescription]);
         
         NSArray *tweetsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (error)
             return failure([error localizedDescription]);
         return success(tweetsArray);
     }];
}

- (void)getMentionedTweets:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure
{
    if (twitterAccount == nil)
        return failure(kTwitterConfigurationError);
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/mentions_timeline.json"];
    NSDictionary *parameters = @{@"screen_name" : twitterAccount.username, @"include_rts" : @"1", @"trim_user" : @"0", @"count" : @"200"};
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:parameters];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
             return failure([error localizedDescription]);
         
         NSArray *tweetsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (error)
             return failure([error localizedDescription]);
         return success(tweetsArray);
     }];
}

- (void)search:(NSString *)query success:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure
{
    if (twitterAccount == nil)
        return failure(kTwitterConfigurationError);
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *parameters = @{@"q" : [query urlEncodeUsingEncoding:NSUTF8StringEncoding], @"src" : @"tren",
                                 @"result_type" : @"recent", @"count" : @"100", @"src" : @"tren"};
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:parameters];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
             return failure([error localizedDescription]);
         
         NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (error)
             return failure([error localizedDescription]);
         NSArray *tweetsArray = [resultDictionary objectForKey:@"statuses"];
         return success(tweetsArray);
     }];
}

- (void)getUserTweetsWithHandle:(NSString *)handleName success:(void (^)(NSArray *tweets))success failure:(void (^)(NSString *error))failure
{
    if (twitterAccount == nil)
        return failure(kTwitterConfigurationError);
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    NSDictionary *parameters = @{@"screen_name" : handleName, @"include_rts" : @"0", @"trim_user" : @"0", @"count" : @"200"};
    
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:parameters];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error)
             return failure([error localizedDescription]);
         
         NSArray *tweetsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         if (error)
             return failure([error localizedDescription]);
         return success(tweetsArray);
     }];
}

@end
