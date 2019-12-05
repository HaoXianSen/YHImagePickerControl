# YHImagePickerControl
构建一个类似系统相册的功能，获取系统相册分组，以及组内照片，以及照片预览功能。

## 技术文档
主要区分
### iOS 8.0 之前
iOS8之前用 ALAssetsLibrary.kit 获取照片分组、照片、以及照片缩略图
主要类
* 1. ALAssetsLibrary：提供访问系统图片app下的照片或者视频。
* 2. ALAssetsGroup：表示一个分组，即一个相簿
* 3. ALAsset：表示一个一张相片或者一个视频，包括其相关信息
* 4. ALAssetFilter: 一个筛选类，可以根据此类筛选出符合条件的照片或者视频

主要思想：
用ALAssetsLibrary类负责访问相册，可以写入或者查找照片视频；从而可以查找出相簿信息，以及相片信息。相当于ALAssets是一个管理类，其他类是其模型类。

主要用法：
   *  获取权限：[ALAssetsLibrary authorizationStatus]
   * 权限相关枚举：
    ```
typedef NS_ENUM(NSInteger, ALAuthorizationStatus) {
ALAuthorizationStatusNotDetermined NS_ENUM_DEPRECATED_IOS(6_0, 9_0) = 0, // User has not yet made a choice with regards to this application
ALAuthorizationStatusRestricted NS_ENUM_DEPRECATED_IOS(6_0, 9_0),        // This application is not authorized to access photo data.
// The user cannot change this application’s status, possibly due to active restrictions
//  such as parental controls being in place.
ALAuthorizationStatusDenied NS_ENUM_DEPRECATED_IOS(6_0, 9_0),            // User has explicitly denied this application access to photos data.
ALAuthorizationStatusAuthorized NS_ENUM_DEPRECATED_IOS(6_0, 9_0)        // User has authorized this application to access photos data.
}
    ```
   *  获取分组ALAssetsGroup:
    ```
[self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
if (group) {
YHPhotoModel *model = [[YHPhotoModel alloc] initWithGroup:group];
[array addObject:model];
}
dispatch_async(dispatch_get_main_queue(), ^{
_dataSource = array;
[self.groupTableView reloadData];
});
} failureBlock:^(NSError *error) {
}];
    ```
   *  获取组内图片Assets:ALAsset: 
    ``` 
[_model.group setAssetsFilter:[ALAssetsFilter allAssets]];
[_model.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
if (result) {
[assetArray addObject:result];
}
dispatch_async(dispatch_get_main_queue(), ^{
_assetArray = [assetArray mutableCopy];
[_collectionView reloadData];
[SVProgressHUD dismiss];
});
}];
}
    ```
   *  获取缩略图： 
    ```
[UIImage imageWithCGImage:[alAsset aspectRatioThumbnail]]
    ```
获取相关图片或者信息：用ALAsset的相关属性

### iOS 8.0 之后

iOS 8.0 之后苹果发布 photo.kit 用于替代 AssetsLibrary，iOS 9.0开始废弃 AssetsLibrary。

主要相关类：
* 1. PHPhotoLibrary: 相比于之前的ALAssetsLibrary，此类只负责权限相关和注册监听相册变化。
* 2. PHAssetCollection:PHCollection：用于表示一个相簿，同时此类也是获取相簿连接类。
* 3. PHAsset：用于表示一个图片或者视频，同时此类也是获取图片资源的连接类
* 4. PHFetchResult：此类是一个包含泛型的类，包装了多个泛型对象，如：PHAsset、PHAssetCollection... 表示一次的检索结果
* 5. PHFecthOptions：此类表示检索的选项。
* 6. PHImageManager: UIImage 相关类，主要负责获取对应尺寸的图片。

主要用法
    * 询问权限： 
    ```
[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}
权限枚举：
typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
// The user cannot change this application’s status, possibly due to active restrictions
//   such as parental controls being in place.
PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
PHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.
};
    ```
   * 获取分组: PHAssetCollection
    ```
if (status == PHAuthorizationStatusAuthorized) {
PHFetchResult *userResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
PHFetchResult *libResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
[libResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
YHPhotoModel *photoModel = [[YHPhotoModel alloc] initWithAssetCollection:obj];
[array addObject:photoModel];
}];
[userResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
YHPhotoModel *photoModel = [[YHPhotoModel alloc] initWithAssetCollection:obj];
[array addObject:photoModel];
}];
self.dataSource = [array copy];
dispatch_async(dispatch_get_main_queue(), ^{
[self.groupTableView reloadData];
});
}
    ```
   *  获取组内图片：PHAsset
    ```
PHFetchOptions *options = [PHFetchOptions new];
options.sortDescriptors = @[
[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]
];
PHFetchResult<PHAsset *> *results = [PHAsset fetchAssetsInAssetCollection:_model.assetCollection options:options];
[results enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
[assetArray addObject:obj];
}];
self.assetArray = [assetArray copy];
[self.collectionView reloadData]; 
    ```
    * 获取Image图片：
    ```
PHAsset *phAsset = asset;
[[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
cell.photoImageView.image = result;
}];
    ```
