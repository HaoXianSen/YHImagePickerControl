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

@end
