//
//  PlayHaven.h
//  PlayHaven
//
//  Created by Kurtiss Hare on 2/16/10.
//  Copyright 2010 Medium Entertainment, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma GCC visibility push(default)

@protocol PHRequestDelegate<NSObject>

@required

-(void)playhaven:(UIView *)view didLoadWithContext:(id)contextValue;
-(void)playhaven:(UIView *)view didFailWithError:(NSString *)message context:(id)contextValue;
-(void)playhaven:(UIView *)view wasDismissedWithContext:(id)contextValue;

@end

@interface PlayHaven : NSObject

+(void)preloadWithPublisherToken:(NSString *)publisherToken testing:(BOOL)shouldTest;

// NOTE: configuration only used in conjunction with the debug version of libPlayHaven-Debug.a
+(void)preloadWithPublisherToken:(NSString *)publisherToken testing:(BOOL)shouldTest configuration:(NSDictionary *)configuration;

+(void)loadChartsWithDelegate:(id<PHRequestDelegate>)delegate context:(id)contextValue;
+(void)loadCommunityWithDelegate:(id<PHRequestDelegate>)delegate context:(id)contextValue;
+(void)loadService:(NSString *)service withDelegate:(id<PHRequestDelegate>)delegate params:(NSDictionary *)dictionary context:(id)contextValue;

+(NSString *)version;

@end

/*** CONFIGURATION KEYS ***/

extern NSString * const phLogLevel;

#pragma GCC visibility pop