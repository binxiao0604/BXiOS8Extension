//
//  ControlTodayViewDisplay.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/4/2.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "ControlTodayViewDisplay.h"
#import <NotificationCenter/NotificationCenter.h>
#import <ExtensionDemoKit/ExtensionDemoKit.h>

@implementation ControlTodayViewDisplay

+ (void)hideTodayView
{
    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:kBXExtensionTodayExtensionIdentifier];
}

+ (void)showTodayView
{
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:kBXExtensionTodayExtensionIdentifier];
}

@end
