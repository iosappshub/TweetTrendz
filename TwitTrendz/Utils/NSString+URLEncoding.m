//
//  NSString+URLEncoding.m
//
//
//  Created by TechFlitter on 21/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (__bridge CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
