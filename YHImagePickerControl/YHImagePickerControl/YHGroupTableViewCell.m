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
    if (model.group) {
        _posterImageView.image = [UIImage imageWithCGImage:[model.group posterImage]];
        NSString *titleStr = [NSString stringWithFormat:@"%@  (%ld)", model.groupName, [model.group numberOfAssets]];
        _titleLabel.text = titleStr;
    } else if (model.assetCollection) {
        
        NSInteger count = 0;
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[
            [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]
        ];
        PHFetchResult<PHAsset *> *results = [PHAsset fetchAssetsInAssetCollection:model.assetCollection options:options];
        count = results ? results.count : count;
        NSString *titleStr = [NSString stringWithFormat:@"%@  (%ld)", model.assetCollection.localizedTitle, count];
        _titleLabel.text = titleStr;
        CGSize thumbnailSize = _posterImageView.bounds.size;
        if (results.count > 0) {
            [[PHImageManager defaultManager] requestImageForAsset:results.firstObject targetSize:thumbnailSize contentMode:PHImageContentModeAspectFit options: nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                self.posterImageView.image = result;
            }];
        } else {
            self.posterImageView.image = nil;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
