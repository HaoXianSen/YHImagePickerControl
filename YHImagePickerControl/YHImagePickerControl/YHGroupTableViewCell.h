//
//  YHGroupTableViewCell.h
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPhotoModel.h"

@interface YHGroupTableViewCell : UITableViewCell
@property (strong, nonatomic)YHPhotoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
