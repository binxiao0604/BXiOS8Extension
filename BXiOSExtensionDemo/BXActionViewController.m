//
//  BXActionViewController.m
//  BXiOSExtensionDemo
//
//  Created by 彬潇 on 15/4/3.
//  Copyright (c) 2015年 彬潇. All rights reserved.
//

#import "BXActionViewController.h"

@interface BXActionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BXActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickShareButtonAction:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[self.textView.text] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
