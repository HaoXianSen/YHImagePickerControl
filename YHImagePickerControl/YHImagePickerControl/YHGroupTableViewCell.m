//
//  YHGroupTableViewCell.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHGroupTableViewCell.h"

@implementation YHGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(YHPhotoModel *)model {
    _model = model;
    _posterImageView.image = [UIImage imageWithCGImage:[model.group posterImage]];
    NSString *titleStr = [NSString stringWithFormat:@"%@  (%ld)", model.groupName, [model.group numberOfAssets]];
    _titleLabel.text = titleStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
