

//
//  YHAlbumPickerViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/7.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHAlbumPickerViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YHAlbumPickerViewController ()<UIAlertViewDelegate>

@end

@implementation YHAlbumPickerViewController
+ (instancetype)albumPickerViewController {
    YHAlbumPickerViewController *albumViewController = [[UIStoryboard storyboardWithName:@"YHAlbumPickerStoryBoard" bundle:nil] instantiateInitialViewController];
    return albumViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSelf];
    [self getAllDatas];
}
- (void)configureSelf {
    self.navigationController.title = @"所有照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
}
- (void)sureButtonClicked {
    
}
- (void)cancelButtonClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Data Source 
- (void)getAllDatas {
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
        [self getAllPhotos];
    } else {
        if (kDeviceVersion.floatValue < 8.0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往设置打开允许访问您的照片库" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"取消", nil];
            [alertView show];
        } else {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置打开允许访问您的照片库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self cancelButtonClicked];
            }];
            [alertViewController addAction:cancelButton];
            [alertViewController addAction:okButton];
        }
    }
}
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // Cancel
        [self cancelButtonClicked];
    } else { // ok
        
    }
}
- (void)getAllPhotos {
    NSMutableArray *assetArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    if (kDeviceVersion.floatValue < 8.0) {
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
        } failureBlock:^(NSError *error) {
            
        }];
        ALAssetsGroup *assetGroup = [[ALAssetsGroup alloc] init];
        [assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
        [assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            [assetArray addObject:result];
            [photoArray addObject:result.]
        }];
    } else {
    
    }
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
