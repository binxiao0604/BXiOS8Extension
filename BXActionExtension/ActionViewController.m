//
//  ActionViewController.m
//  BXActionExtension
//
//  Created by 彬潇 on 15/4/3.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ActionViewController ()

//@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITextView *textView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    NSItemProvider *itemProvider = item.attachments[0];
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
        // 这是一段纯文本！
        __weak UITextView *textView = self.textView;
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
            
            if (item) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [textView setText:item];
                    //设置语音合成并加以启动
                    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textView.text];
                    [utterance setRate:0.1];
                    [synthesizer speakUtterance:utterance];
                }];
            }
        }];
    }

//    BOOL imageFound = NO;
//    for (NSExtensionItem *item in self.extensionContext.inputItems) {
//        for (NSItemProvider *itemProvider in item.attachments) {
//            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
//                // This is an image. We'll load it, then place it in our image view.
//                __weak UIImageView *imageView = self.imageView;
//                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
//                    if(image) {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            [imageView setImage:image];
//                        }];
//                    }
//                }];
//                
//                imageFound = YES;
//                break;
//            }
//        }
//        
//        if (imageFound) {
//            // We only handle one image, so stop looking for more.
//            break;
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
