

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
#import "YHPhotoAssetCell.h"

@interface YHAlbumPickerViewController ()<UIAlertViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)NSArray *assetArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic)ALAssetsLibrary *assetsLibrary;
@end

@implementation YHAlbumPickerViewController
+ (instancetype)albumPickerViewController {
    YHAlbumPickerViewController *albumViewController = [[UIStoryboard storyboardWithName:@"YHAlbumPickerStoryBoard" bundle:nil] instantiateInitialViewController];
    return albumViewController;
}
- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSelf];
    [self configureCollectionView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllDatas];
}
- (void)configureSelf {
    self.navigationController.title = @"所有照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
}
- (void)configureCollectionView {
    self.flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/4, self.view.frame.size.width/4);
    self.flowLayout.minimumLineSpacing = 0.0;
    self.flowLayout.minimumInteritemSpacing = 0.0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YHPhotoAssetCell" bundle:nil] forCellWithReuseIdentifier:@"YHPhotoAssetCell"];
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
    if (kiOS8Later) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self getAllPhotos];
            } else {
                [self showPhotosCannotOpenAlert];
            }
        }];
    } else {
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            [self getAllPhotos];
        } else {
            [self showPhotosCannotOpenAlert];
        }
    
    }
}
- (void)showPhotosCannotOpenAlert {
    if (kDeviceVersion.floatValue < 8.0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往设置打开允许访问您的照片库" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"取消", nil];
        [alertView show];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请前往设置打开允许访问您的照片库" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self goToSystemSetting];
        }];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self cancelButtonClicked];
        }];
        [alertViewController addAction:cancelButton];
        [alertViewController addAction:okButton];
        [self presentViewController:alertViewController animated:YES completion:nil];
    }

}
- (void)goToSystemSetting {
    if (kiOS8Later) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            [[UIApplication sharedApplication] openURL:settingUrl];
        }
    } else {
        NSURL *privaceUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=photos"];
        if ([[UIApplication sharedApplication] canOpenURL:privaceUrl]) {
            [[UIApplication sharedApplication] openURL:privaceUrl];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请手动到设置里，到应用的设置页面，打开允许访问相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
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
//    if (kDeviceVersion.floatValue < 8.0) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    [SVProgressHUD show];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(@"%@", group);
        if (group != nil && [group numberOfAssets] != 0) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [assetArray addObject:result];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _assetArray = [assetArray mutableCopy];
            [_collectionView reloadData];
            [SVProgressHUD dismiss];
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
#pragma mark - Collection Datasouce And Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHPhotoAssetCell" forIndexPath:indexPath];
    ALAsset *asset = self.assetArray[indexPath.item];
    cell.photoImageView.image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    return cell;
}
@end
