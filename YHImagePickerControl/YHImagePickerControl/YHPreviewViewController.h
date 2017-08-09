//
//  YHPreviewViewController.h
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHPreviewViewController : UIViewController
+ (instancetype)previewControllerWithDataSource:(NSArray *)dataSource andSelectedIndexPath:(NSIndexPath *)selectedIndexPath;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)NSIndexPath *currentIndexPath;

@end
