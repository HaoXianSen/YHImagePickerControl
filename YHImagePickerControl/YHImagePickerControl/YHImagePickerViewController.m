//
//  YHImagePickerViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/7/27.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHImagePickerViewController.h"
#import "YHAlbumPickerViewController.h"
#import "YHPhotoGroupViewController.h"

@interface YHImagePickerViewController ()

@end

@implementation YHImagePickerViewController
- (instancetype)init
{
    YHPhotoGroupViewController *groupVC = [[YHPhotoGroupViewController alloc] init];
    self = [super initWithRootViewController:groupVC];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
