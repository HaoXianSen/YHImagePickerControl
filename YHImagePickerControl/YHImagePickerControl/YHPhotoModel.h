//
//  YHPhotoModel.h
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#ifdef __IPHONE_8_0
    #import <Photos/Photos.h>
#endif

@interface YHPhotoModel : NSObject

@property (copy, nonatomic) NSString *groupName;
@property (strong, nonatomic) ALAssetsGroup *group;

#ifdef __IPHONE_8_0
@property (strong, nonatomic) PHAssetCollection *assetCollection API_AVAILABLE(ios(8.0));
#endif
- (instancetype)initWithGroup:(ALAssetsGroup *)group;

#ifdef __IPHONE_8_0
- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection API_AVAILABLE(ios(8.0));
#endif

@end
