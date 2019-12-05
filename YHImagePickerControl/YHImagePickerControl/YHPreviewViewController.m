//
//  YHPreviewViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHPreviewViewController.h"
#import "YHPreviewCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface YHPreviewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation YHPreviewViewController
+ (instancetype)previewControllerWithDataSource:(NSArray *)dataSource andSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    YHPreviewViewController *previewVC = [UIStoryboard storyboardWithName:@"YHPreviewStoryBoard" bundle:nil].instantiateInitialViewController;
    previewVC.dataSource = dataSource;
    previewVC.currentIndexPath = selectedIndexPath;
    return previewVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp {
    self.layout.itemSize = CGSizeMake(self.view.frame.size.width-10, self.view.frame.size.height);
    self.layout.minimumLineSpacing = 5;
    self.layout.minimumInteritemSpacing = 2.5;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 0);
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = UIColor.blackColor;
    self.collectionView.backgroundColor = UIColor.blackColor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
#pragma mark - UICollectionViewController Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YHPreviewCollectionViewCell" forIndexPath:indexPath];
    ALAsset *asset = _dataSource[indexPath.row];
    
#ifdef __IPHONE_8_0
    [[PHImageManager defaultManager] requestImageForAsset:(PHAsset *)asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.previewImageView.image = result;
    }];
    
#else
    cell.previewImageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
#endif
    return cell;
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
