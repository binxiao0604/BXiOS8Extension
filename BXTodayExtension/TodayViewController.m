//
//  TodayViewController.m
//  BXTodayExtension
//
//  Created by 彬潇 on 15/3/22.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <ExtensionDemoKit/ExtensionDemoKit.h>
#import <TodayExtensionDemoKit/TodayExtensionDemoKit.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic,strong) NSUserDefaults *sharedUserDefault;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic , copy) NSString *openVCTypeString;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.messageLabel.text = [[BXSharedUserDefaultsManager sharedManager] readMessageFromUserDefaults] ? : @"";
    self.messageLabel.text =  [[BXSharedUserDefaultsManager sharedManager] readMessageFromFileManager] ? : @"";
//    有的时候运行程序，view显示不出来，这个时候你可能需要,或者根据需要调整界面大小;
//    self.preferredContentSize = CGSizeMake(0, 400);//宽度默认是整屏，设置宽度无效;
}

#pragma mark ---NCWidgetProviding delegate----
//widget界面布局默认从图表右边界对齐，要从左边对齐需要实现NCWidgetProviding的代理方法；
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    NSLog(@"%s_%d_|  %@",__FUNCTION__,__LINE__,NSStringFromUIEdgeInsets(defaultMarginInsets));
    //默认值为{0, 47, 39, 0}
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

//即使你的扩展现在不可见 (也就是用户没有拉开通知中心)，系统也会时不时地调用实现了 NCWidgetProviding 的扩展的这个方法，来要求扩展刷新界面。
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
//一般可以做一些像 API 请求之类的事情，在获取到了数据并更新了界面，或者是失败后都使用提供的 completionHandler 来向系统进行报告。
    NSString *oldMessage = self.messageLabel.text;
    //    NSString *newMessage = [[BXSharedUserDefaultsManager sharedManager] readMessageFromUserDefaults];    [[BXSharedUserDefaultsManager sharedManager] saveMessageByFileManagerWithString:textField.text];
      NSString *newMessage = [[BXSharedUserDefaultsManager sharedManager] readMessageFromFileManager];
    if (!newMessage) {
        completionHandler(NCUpdateResultFailed);
    }else if([oldMessage isEqual:newMessage])
    {
        completionHandler(NCUpdateResultNoData);
    }else{
        self.messageLabel.text = newMessage;
        completionHandler(NCUpdateResultNewData);//更新数据;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickWeather:(id)sender {
    NSLog(@"%s_%d_| ",__FUNCTION__,__LINE__);
    self.openVCTypeString = kDisplayWeatherVC;
    [self openContainingAppWithTypeString];
}

- (IBAction)didClickImageButton:(id)sender {
    NSLog(@"%s_%d_| ",__FUNCTION__,__LINE__);
    self.openVCTypeString = kDisplayImageVC;
    [self openContainingAppWithTypeString];
}

- (IBAction)didClickCameraButton:(id)sender {
    NSLog(@"%s_%d_| ",__FUNCTION__,__LINE__);
    self.openVCTypeString = kDisplayCameraVC;
    [self openContainingAppWithTypeString];
}


- (void)openContainingAppWithTypeString
{
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",kBXExtensionContainingAPPURLScheme,self.openVCTypeString]] completionHandler:^(BOOL success) {
        NSLog(@"%s_%d_|  open Containing App success %@ ",__FUNCTION__,__LINE__,self.openVCTypeString);
    }];
}

#pragma mark ---TodayExtension 隐藏自己---
- (IBAction)hideTodayExtension:(id)sender {
    NSLog(@"%s_%d_| ",__FUNCTION__,__LINE__);
    [ControlTodayViewDisplay hideTodayView];
    [[BXSharedUserDefaultsManager sharedManager] saveTodayHideStateWithBool:YES];
}

@end
