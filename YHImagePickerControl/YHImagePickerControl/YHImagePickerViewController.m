//
//  YHImagePickerViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/7/27.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHImagePickerViewController.h"

@interface YHImagePickerViewController ()

@end

@implementation YHImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureSelf];
}
- (void)configureSelf {
    if (!self.navigationController) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
        nav.navigationBar.barStyle = UIBarStyleDefault;
        nav.navigationBar.barTintColor = [UIColor blackColor];
    }
    self.navigationController.title = @"所有照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
}
- (void)sureButtonClicked {
    
}
- (void)cancelButtonClicked {

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
