//
//  ViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/7/25.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

@end
