//
//  BXSharedUserDefaultsManager.h
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/3/24.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXExtensionSystemMessage.h"
#import <UIKit/UIKit.h>

@interface BXSharedUserDefaultsManager : NSObject

@property (nonatomic , strong) NSUserDefaults *sharedUserdefaults;

+ (instancetype)sharedManager;

- (NSUserDefaults *)sharedUserdefaultForExtension;
- (NSString *)readMessageFromUserDefaults;
- (BOOL)readTodayHideStateFromUserDefaults;
- (void)saveMessageWithText:(NSString *)textString;
- (void)saveTodayHideStateWithBool:(BOOL)hide;

- (void)saveMessageByFileManagerWithString:(NSString *)messageString;
- (NSString *)readMessageFromFileManager;
- (void)saveMessageByFileManagerWithImage:(UIImage *)image;
- (UIImage *)readImageFromFileManager;


@end
