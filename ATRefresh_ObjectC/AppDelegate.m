//
//  AppDelegate.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ATTableController.h"
#import "BaseNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    BaseNavigationController *nvc = [[BaseNavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = nvc;
    return YES;
}


@end
