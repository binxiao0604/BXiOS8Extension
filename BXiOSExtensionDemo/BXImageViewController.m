//
//  BXImageViewController.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/4/2.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "BXImageViewController.h"
#import <ExtensionDemoKit/ExtensionDemoKit.h>

@interface BXImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BXImageViewController

+ (instancetype)sharedInstance
{
    BXImageViewController *imageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return imageVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self uploadImageFormFileManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickCloseButtonAction:(id)sender {
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)uploadImageFormFileManager
{
    self.imageView.image = [[BXSharedUserDefaultsManager sharedManager]readImageFromFileManager] ? :[UIImage imageNamed:@"屏幕快照 2015-04-02 17.58.57"];

}

@end
