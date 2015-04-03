//
//  PhotoEditingViewController.m
//  BXPhotoEditingExtension
//
//  Created by 彬潇 on 15/4/3.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "PhotoEditingViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "BXImageProgress.h"

@interface PhotoEditingViewController () <PHContentEditingController>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong) PHContentEditingInput *input;

@property (nonatomic,strong) UIImage *processorImage;
@property (nonatomic,strong) BXImageProgress *processor;

@end

@implementation PhotoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.processor = [[BXImageProgress alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PHContentEditingController

- (BOOL)canHandleAdjustmentData:(PHAdjustmentData *)adjustmentData {
//    如果你的扩展应用能对之前的编辑生效，那这个方法返回 true。

    // Inspect the adjustmentData to determine whether your extension can work with past edits.
    // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
    return NO;
}

- (void)startContentEditingWithInput:(PHContentEditingInput *)contentEditingInput placeholderImage:(UIImage *)placeholderImage {
//    这个方法在 View Controller 出现之前并且 asset 可以被编辑时被调用。它被传入两个对象 - 一个 PHContentEditingInput 实例（要被编辑的 asset）和一个 UIImage 实例（可能是原本的图像或者根据下面提到的 canHandleAdjustmentData(adjustmentData:) 方法的返回值得到的被编辑过的图像）。
 
    self.input = contentEditingInput;
    if ([self.input isEqual:contentEditingInput]) {
        self.imageView.image = self.input.displaySizeImage;
    }
}

- (void)finishContentEditingWithCompletionHandler:(void (^)(PHContentEditingOutput *))completionHandler {
// 这个方法在图像被编辑以后被调用。一个存储编辑和描述编辑调整的数据的 PHContentEditingOutput 实例会被创建。这个实例会被传入 completionHandler。    
    // Render and provide output on a background queue.
    if (self.input == nil) {
        [self didClickCancelButton:nil];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create editing output from the editing input.
        PHContentEditingOutput *output = [[PHContentEditingOutput alloc] initWithContentEditingInput:self.input];
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:@"Face Blur"];
        NSString *identifier = @"com.appcoda.FaceBlur.FaceBlur-filter";
        PHAdjustmentData *adjustmentData = [[PHAdjustmentData alloc]initWithFormatIdentifier:identifier formatVersion:@"1.0" data:archiveData];
        output.adjustmentData = adjustmentData;
        NSString *path = self.input.fullSizeImageURL.path;
        if (path) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            image = [self.processor processImage:image];
            NSData *jpegData = UIImageJPEGRepresentation(image, 1.0);
            NSError *error;
            BOOL saveSucceeded = [jpegData writeToURL:output.renderedContentURL options:NSDataWritingAtomic error:&error];
            if (saveSucceeded) {
                completionHandler(output);
            }else {
                NSLog(@"%s_%d_| save  error ",__FUNCTION__,__LINE__);
                completionHandler(nil);
            }

        }else {
            NSLog(@"%s_%d_| load  error ",__FUNCTION__,__LINE__);
            completionHandler(nil);
        }

    });
    
}

- (BOOL)shouldShowCancelConfirmation {
//    确保在视图控制器中执行shouldShowCancelConfirmation 方法，如有未保存的更改则返回YES。该方法返回YES后，Photos app将会展示确认UI，从而方便用户确认是否真的想取消此前的更改。
    return NO;
}

- (void)cancelContentEditing {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
//    这个方法在用户取消编辑时被调用。你应当在这里清理不需要的资源
}

- (IBAction)didClickCancelButton:(id)sender {
    self.imageView.image = self.input.displaySizeImage;
    self.processorImage = nil;
}

- (IBAction)didClickEditButton:(id)sender {
    self.processorImage = [self.processor processImage:self.input.displaySizeImage];
    self.imageView.image = self.processorImage;
}

@end
