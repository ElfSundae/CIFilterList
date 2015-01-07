//
//  AppDelegate.m
//  CIFilterList
//
//  Created by Elf Sundae on 1/7/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window makeKeyAndVisible];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[ [[UINavigationController alloc] initWithRootViewController:
                                               [ListViewController.alloc initWithCategoryType:CILCategoryTypeByEffect]],
                                              [[UINavigationController alloc] initWithRootViewController:
                                               [ListViewController.alloc initWithCategoryType:CILCategoryTypeByUsage]],
                                              [[UINavigationController alloc] initWithRootViewController:
                                               [ListViewController.alloc initWithCategoryType:CILCategoryTypeBuiltIn]]
                                              ];
        self.window.rootViewController = tabBarController;
        
        return YES;
}

@end
