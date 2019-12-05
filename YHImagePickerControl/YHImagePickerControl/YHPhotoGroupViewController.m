//
//  YHPhotoGroupViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHPhotoGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YHPhotoModel.h"
#import "YHGroupTableViewCell.h"
#import "YHAlbumPickerViewController.h"
#ifdef __IPHONE_8_0
#import <Photos/Photos.h>
#endif

@interface YHPhotoGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *groupTableView;

@property (nonatomic, strong)NSArray *dataSource;

/// ios8 之前媒体资源管理库
@property (nonatomic, strong)ALAssetsLibrary *assetLibrary;
@end

@implementation YHPhotoGroupViewController

- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return  _assetLibrary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self getAllGroupDatas];
}
- (void)setUp {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 80.f;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YHGroupTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YHGroupTableViewCell class])];
    [self.view addSubview:tableView];
    _groupTableView = tableView;
    
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    self.title = @"照片";
}
- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getAllGroupDatas {
    NSMutableArray *array = [NSMutableArray array];
    
#ifdef __IPHONE_8_0
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            
            PHFetchResult *userResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            PHFetchResult *libResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            
            [libResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YHPhotoModel *photoModel = [[YHPhotoModel alloc] initWithAssetCollection:obj];
                [array addObject:photoModel];
            }];
            
            [userResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YHPhotoModel *photoModel = [[YHPhotoModel alloc] initWithAssetCollection:obj];
                [array addObject:photoModel];
            }];
            self.dataSource = [array copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.groupTableView reloadData];
            });
        }
    }];
#else
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                YHPhotoModel *model = [[YHPhotoModel alloc] initWithGroup:group];
                [array addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataSource = array;
                [self.groupTableView reloadData];
            });
        } failureBlock:^(NSError *error) {
            
        }];
    } else {
        [self showPhotosCannotOpenAlert];
    }
#endif
    
}
#pragma mark - TableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YHGroupTableViewCell class])];
    YHPhotoModel *model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoModel *model = _dataSource[indexPath.row];
    YHAlbumPickerViewController *albumPickerVC = [YHAlbumPickerViewController albumPickerViewController];
    albumPickerVC.model = model;
    [self.navigationController pushViewController:albumPickerVC animated:YES];
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
