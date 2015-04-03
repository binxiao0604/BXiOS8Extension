//
//  DocumentPickerViewController.m
//  BXProviderExtension
//
//  Created by 彬潇 on 15/4/2.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "DocumentPickerViewController.h"

@interface DocumentPickerViewController ()

@end

@implementation DocumentPickerViewController

- (IBAction)openDocument:(id)sender {
    NSURL* documentURL = [self.documentStorageURL URLByAppendingPathComponent:@"Untitled.txt"];
    
    // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
    [self dismissGrantingAccessToURL:documentURL];
}

-(void)prepareForPresentationInMode:(UIDocumentPickerMode)mode {
    // TODO: present a view controller appropriate for picker mode here
    //如果有必要，那么重写此方法来设置其所需的所有资源。特别是当您的应用程序为不同的模式使用了不同的视图层次结构的时候，请确保在这个方法实现中设置了正确的视图层次结构。
    
}

//- (void)dismissGrantingAccessToURL:(NSURL *)url
//{
////    调用此方法来关闭该文档选择器的视图控制器以及所提供的授权访问的网址。每种模式都有自己所要求的URL。
//}



@end
