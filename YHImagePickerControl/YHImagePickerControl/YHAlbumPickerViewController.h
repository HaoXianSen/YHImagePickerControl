//
//  YHAlbumPickerViewController.h
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/7.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPhotoModel.h"

@interface YHAlbumPickerViewController : UIViewController
@property (nonatomic, strong)YHPhotoModel *model;
+ (instancetype)albumPickerViewController;

@end
