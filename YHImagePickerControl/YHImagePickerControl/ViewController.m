//
//  ViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/7/25.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "ViewController.h"
#import "YHPhotoCollectionViewCell.h"
#import "YHImagePickerViewController.h"

@interface ViewController ()<UIActionSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSelf];
}
- (void) configureSelf {
    [self.collectionView registerNib:[UINib nibWithNibName:PhotoCollectionViewCellId bundle:nil] forCellWithReuseIdentifier:PhotoCollectionViewCellId];
}
#pragma mark - Selected photos method
- (IBAction)selectedPhotosButtonClicked:(id)sender {
    [self showSelectPhotoSheet];
}
- (void)showSelectPhotoSheet {
    if (kDeviceVersion.floatValue < 8.0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"please select your method" delegate:self cancelButtonTitle:@"close" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album", @"Take Picture", nil];
        [sheet showInView:self.view];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"please select your method" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPhotoAlbum];
        }];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:photoAlbumAction];
        [alertController addAction:takePhotoAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark- UIAlertSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //photo album
        [self showPhotoAlbum];
    } else if (buttonIndex == 1) { // take photo
    
    }
}
- (void)showPhotoAlbum {
    YHImagePickerViewController *imagePickerVC = [[YHImagePickerViewController alloc] init];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCellId forIndexPath:indexPath];
    return cell;
}

@end
