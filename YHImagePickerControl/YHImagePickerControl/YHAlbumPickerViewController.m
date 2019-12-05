

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
#import "YHPreviewViewController.h"

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
    self.title = @"所有照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonClicked)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
- (void)configureCollectionView {
    self.flowLayout.itemSize = CGSizeMake((self.view.frame.size.width-3)/4, (self.view.frame.size.width-3)/4);
    self.flowLayout.minimumLineSpacing = 1.0;
    self.flowLayout.minimumInteritemSpacing = 1.0;
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
    [self getAllPhotos];
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
    [SVProgressHUD show];
    
#ifdef __IPHONE_8_0
    if (_model && _model.assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[
            [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]
        ];
        PHFetchResult<PHAsset *> *results = [PHAsset fetchAssetsInAssetCollection:_model.assetCollection options:options];
        [results enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [assetArray addObject:obj];
        }];
        self.assetArray = [assetArray copy];
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    }
    
#else
    if (_model && _model.group) {
        [_model.group setAssetsFilter:[ALAssetsFilter allAssets]];
        [_model.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [assetArray addObject:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _assetArray = [assetArray mutableCopy];
                [_collectionView reloadData];
                [SVProgressHUD dismiss];
            });
        }];

    }
#endif
}
#pragma mark - Collection Datasouce And Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHPhotoAssetCell" forIndexPath:indexPath];
    id asset = self.assetArray[indexPath.item];

#ifdef __IPHONE_8_0
        PHAsset *phAsset = asset;
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.photoImageView.image = result;
        }];
#else
        ALAsset *alAsset = asset;
        cell.photoImageView.image = [UIImage imageWithCGImage:[alAsset aspectRatioThumbnail]];
#endif
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPreviewViewController *previewVC = [YHPreviewViewController previewControllerWithDataSource:self.assetArray andSelectedIndexPath:indexPath];
    [self.navigationController pushViewController:previewVC animated:YES];
}
@end
