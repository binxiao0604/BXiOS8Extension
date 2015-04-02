//
//  BXSharedUserDefaultsManager.h
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/3/31.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXExtensionSystemMessage.h"

@interface BXSharedUserDefaultsManager : NSObject

@property (nonatomic , strong) NSUserDefaults *sharedUserdefaults;

+ (instancetype)sharedManager;

- (NSUserDefaults *)sharedUserdefaultForExtension;
- (NSString *)readMessageFromUserDefaults;
- (BOOL)readTodayHideStateFromUserDefaults;
- (void)saveMessageWithText:(NSString *)textString;
- (void)saveTodayHideStateWithBool:(BOOL)hide;

@end
