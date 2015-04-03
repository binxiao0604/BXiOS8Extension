//
//  ShareViewController.m
//  BXShareExtension
//
//  Created by 彬潇 on 15/4/2.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ExtensionDemoKit/ExtensionDemoKit.h>

@interface ShareViewController ()

@property (nonatomic, strong) UIImage *postImage;

@end

@implementation ShareViewController

//输入内容校验; 控制post按钮.
- (BOOL)isContentValid {
    NSInteger lengthOfText = self.contentText.length;
    //显示校验信息;
    self.charactersRemaining = @(10 - lengthOfText);
    //post发送控制;
    if (self.charactersRemaining.integerValue <= 0) {
        return NO;
    }
    return YES;
}

- (void)didSelectPost {
//    [super didSelectPost];
//    NSExtensionItem* extensionItem = [[NSExtensionItem alloc] init];
//    [extensionItem setAttachments:@[[[NSItemProvider alloc] initWithItem:self.postImage typeIdentifier:(NSString*)kUTTypeImage]]];
//    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
    [self configSession];
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

#pragma mark ---add action---
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeholder = @"请输入分享内容";
    self.title = @"分享";
    NSLog(@"%s_%d_|  extensionContext =  %@",__FUNCTION__,__LINE__,self.extensionContext);
    //提取item;
    NSExtensionItem *item =  [self.extensionContext.inputItems firstObject];
    if (!item) {
            return;
        }
    NSLog(@"%s_%d_| item = %@",__FUNCTION__,__LINE__,item);
    //提取provider;
    NSItemProvider *provider = [[item attachments] firstObject];
    if (!provider) {
        return;
    }
    NSLog(@"%s_%d_| provider = %@",__FUNCTION__,__LINE__,provider);
    //检查是否包含所需要信息;需要导入MobileCoreServices框架,并且解析会消耗资源放在后台执行;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([provider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
            [provider  loadItemForTypeIdentifier:(NSString *) kUTTypeImage options:nil completionHandler:^(UIImage * image, NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (image) {
                    __weak typeof(strongSelf) weakSelfAgain = strongSelf;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelfAgain callBackForExtensionData:(UIImage *)image];
                    });
                }
            }];
        }
    });
}

//- (void)presentationAnimationDidFinish
//{
//
//}

- (void)callBackForExtensionData:(UIImage *)image
{
    self.postImage = image;
    [[BXSharedUserDefaultsManager sharedManager] saveMessageByFileManagerWithImage:self.postImage];
}

- (void)configSession
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionConfigIdentifier];
    sessionConfig.sharedContainerIdentifier = kBXExtensionGroupName;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kImageLoadUrl]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    jsonDic[@"text"] = self.contentText;
    jsonDic[@"image"] = [self extractDetailsFromImage:self.postImage];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        request.HTTPBody = jsonData;
    }else{
        NSLog(@"%s_%d_| error = %@",__FUNCTION__,__LINE__,error.localizedDescription);
    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

- (NSDictionary *)extractDetailsFromImage:(UIImage *)image
{
    NSMutableDictionary *imageDetailMessagsDic = [NSMutableDictionary dictionary];
    imageDetailMessagsDic[@"height"] = @(image.size.height);
    imageDetailMessagsDic[@"width"] = @(image.size.width);
    imageDetailMessagsDic[@"orientation"] = @(image.imageOrientation);
    imageDetailMessagsDic[@"scale"] = @(image.scale);
    imageDetailMessagsDic[@"description"] = image.description;
    return [imageDetailMessagsDic copy];
}

////取消发送设置;实现该方法host app分享会无法取消。程序假死。
//- (void)didSelectCancel
//{
//    NSLog(@"%s_%d_| did click cancel button action ",__FUNCTION__,__LINE__);
//}

@end
