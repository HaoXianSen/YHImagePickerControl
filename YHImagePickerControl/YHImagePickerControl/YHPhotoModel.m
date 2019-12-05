//
//  YHPhotoModel.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHPhotoModel.h"

@implementation YHPhotoModel
- (instancetype)initWithGroup:(ALAssetsGroup *)group {
    if (self = [super init]) {
         NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        _groupName = groupName;
        _group = group;
    }
    return self;
}
#ifdef __IPHONE_8_0
- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection  {
    if (self = [super init]) {
        _assetCollection = assetCollection;
    }
    return self;
}
#endif

@end
