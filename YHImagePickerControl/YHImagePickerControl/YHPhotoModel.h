//
//  YHPhotoModel.h
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YHPhotoModel : NSObject

@property (copy, nonatomic)NSString *groupName;
@property (strong, nonatomic)ALAssetsGroup *group;
- (instancetype)initWithGroup:(ALAssetsGroup *)group;

@end
