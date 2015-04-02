//
//  ViewController.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/3/22.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "ViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <ExtensionDemoKit/ExtensionDemoKit.h>
#import <TodayExtensionDemoKit/TodayExtensionDemoKit.h>

@interface ViewController ()<UITextFieldDelegate,UIActionSheetDelegate>

#pragma mark ---共享数据---
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UISwitch *todaySwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openContainingAPPNotification:) name:@"openContainingAppNotification" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear:animated];
    self.todaySwitch.on = ![[BXSharedUserDefaultsManager sharedManager] readTodayHideStateFromUserDefaults];
}

#pragma  mark ---Notification----
- (void)applicationDidBecomeActive
{
    self.todaySwitch.on = ![[BXSharedUserDefaultsManager sharedManager] readTodayHideStateFromUserDefaults];

}

- (void)openContainingAPPNotification:(NSNotification *)notification
{
    NSString *openPage = [notification.userInfo objectForKey:@"openPage"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"测试Url传值" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:openPage otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark ---actionSheet delegate---
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark ---共享数据保存---



#pragma mark ---TextField delegate---
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.messageTextField resignFirstResponder];
    [[BXSharedUserDefaultsManager sharedManager] saveMessageWithText:textField.text];
    return YES;
}

- (IBAction)didClickSwitchAction:(id)sender {
    UISwitch *todaySwitch = (UISwitch *)sender;
    if ([todaySwitch isOn]) {
//        [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"renren.BXiOSExtensionDemo.BXTodayExtension"];
        [ControlTodayViewDisplay showTodayView];
        [[BXSharedUserDefaultsManager sharedManager] saveTodayHideStateWithBool:NO];
    }else{
//        [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"renren.BXiOSExtensionDemo.BXTodayExtension"];
        [ControlTodayViewDisplay hideTodayView];
        [[BXSharedUserDefaultsManager sharedManager] saveTodayHideStateWithBool:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openContainingAppNotification" object:nil];
}

//#pragma mark ----filemanager共享数据---
//- (void)saveTextByFileManager
//{
//    NSError *err = nil;
//    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.BXTodayExtensionGroups"];
//    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/good"];
//     NSString *value = self.messageTextField.text;
//    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
//    if (!result) {
//    NSLog(@"%@",err);
//    } else {
//    NSLog(@"save value:%@ success.",value);
//    }
//}

@end














