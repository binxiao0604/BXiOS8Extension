//
//  BXSharedUserDefaultsManager.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/3/24.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "BXSharedUserDefaultsManager.h"
#import <CoreData/CoreData.h>

@implementation BXSharedUserDefaultsManager

+ (instancetype)sharedManager
{
    static BXSharedUserDefaultsManager *userDefaultsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaultsManager = [[BXSharedUserDefaultsManager alloc]init];
        userDefaultsManager.sharedUserdefaults = [[NSUserDefaults alloc]initWithSuiteName:kBXExtensionGroupName];
    });
    return userDefaultsManager;
}

- (NSUserDefaults *)sharedUserdefaultForExtension
{
    self.sharedUserdefaults = [[NSUserDefaults alloc]initWithSuiteName:kBXExtensionGroupName];
    return self.sharedUserdefaults;
}

- (NSString *)readMessageFromUserDefaults
{
    return [self.sharedUserdefaults valueForKey:kBXTodayMessageUserdefaultsIdentifier];
}

- (void)saveMessageWithText:(NSString *)textString
{
    [self.sharedUserdefaults synchronize];
    [self.sharedUserdefaults setObject:textString forKey:kBXTodayMessageUserdefaultsIdentifier];
    [self.sharedUserdefaults synchronize];
}

- (BOOL)readTodayHideStateFromUserDefaults
{
    if ([[self.sharedUserdefaults valueForKey:kBXTodayHideUserdefaultsIdentifier] isEqual:@1]) {
        return YES;
    }
    return NO;
}

- (void)saveTodayHideStateWithBool:(BOOL)hide
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kBXExtensionGroupName];
    NSLog(@"containerURL = %@   %s_%d_| ",containerURL.path,__FUNCTION__,__LINE__);
    [self.sharedUserdefaults synchronize];
    [self.sharedUserdefaults setObject:@(hide) forKey:kBXTodayHideUserdefaultsIdentifier];
    [self.sharedUserdefaults synchronize];
}

- (void)saveMessageByFileManagerWithString:(NSString *)messageString;
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kBXExtensionGroupName];
    containerURL = [containerURL URLByAppendingPathComponent:kBXFileManagerPath];
    BOOL result = [messageString writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"save value:%@ success.",messageString);
    }
}

- (NSString *)readMessageFromFileManager
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kBXExtensionGroupName];
    containerURL = [containerURL URLByAppendingPathComponent:kBXFileManagerPath];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:&err];
    NSLog(@"%s_%d_| read data by FileManager success %@",__FUNCTION__,__LINE__,value);
    return value;
    
}

- (void)saveMessageByFileManagerWithImage:(UIImage *)image
{
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kBXExtensionGroupName];
    containerURL = [containerURL URLByAppendingPathComponent:kBXFileManagerImagePath];
    NSData *data = UIImagePNGRepresentation(image);
    BOOL result =  [data writeToURL:containerURL atomically:YES];
    if (!result) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"save  image success.");
    }
}

- (UIImage *)readImageFromFileManager
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kBXExtensionGroupName];
    containerURL = [containerURL URLByAppendingPathComponent:kBXFileManagerImagePath];
    NSData *data = [NSData dataWithContentsOfURL:containerURL];
    return [UIImage imageWithData:data];
}

@end
