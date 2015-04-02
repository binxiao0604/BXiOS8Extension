//
//  ControlTodayViewDisplay.h
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/4/2.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDisplayWeatherVC;
extern NSString * const kDisplayImageVC;
extern NSString * const kDisplayCameraVC;

@interface ControlTodayViewDisplay : NSObject

+ (void)hideTodayView;
+ (void)showTodayView;

@end
