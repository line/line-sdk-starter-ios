//
//  AppDelegate.m
//  LineSDKStarterObjC
//
//  Copyright (c) 2015 Line corp. All rights reserved.
//

#import "AppDelegate.h"
#import <LineAdapter/LineAdapter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LineAdapter handleLaunchOptions:launchOptions];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [LineAdapter handleOpenURL:url];
}

@end
