//
//  AppDelegate.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/3/22.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "AppDelegate.h"
#import <ExtensionDemoKit/ExtensionDemoKit.h>
#import <TodayExtensionDemoKit/TodayExtensionDemoKit.h>
#import "BXWeatherViewController.h"
#import "BXImageViewController.h"
#import "BXCameraViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:kBXExtensionContainingAPPURLScheme]) {
        if ([url.host isEqualToString:kDisplayWeatherVC]) {
//            NSDictionary *dic = @{@"openPage":url.host};
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"openContainingAppNotification" object:self userInfo:dic];
            BXWeatherViewController *weatherVC = [BXWeatherViewController sharedInstance];
            [self.window.rootViewController presentViewController:weatherVC animated:YES completion:nil];
        }else if ([url.host isEqualToString:kDisplayImageVC]) {
            BXImageViewController *weatherVC = [BXImageViewController sharedInstance];
            [self.window.rootViewController presentViewController:weatherVC animated:YES completion:nil];
        }else if ([url.host isEqualToString:kDisplayCameraVC]) {
            BXCameraViewController *weatherVC = [BXCameraViewController sharedInstance];
            [self.window.rootViewController presentViewController:weatherVC animated:YES completion:nil];
        }
        return YES;
    }
    return NO;
}

@end
