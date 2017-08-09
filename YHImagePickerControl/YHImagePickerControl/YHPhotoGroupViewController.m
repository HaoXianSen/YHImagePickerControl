//
//  YHPhotoGroupViewController.m
//  YHImagePickerControl
//
//  Created by HaoYuhong on 2017/8/9.
//  Copyright © 2017年 HaoYuhong. All rights reserved.
//

#import "YHPhotoGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YHPhotoModel.h"
#import "YHGroupTableViewCell.h"
#import "YHAlbumPickerViewController.h"

@interface YHPhotoGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *groupTableView;

@property (nonatomic, strong)NSArray *dataSource;

/// ios8 之前媒体资源管理库
@property (nonatomic, strong)ALAssetsLibrary *assetLibrary;
/// ios8 之后获取媒体资源
@property (nonatomic, strong)PHFetchResult *fetchResult;
@end

@implementation YHPhotoGroupViewController

- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return  _assetLibrary;
}
- (PHFetchResult *)fetchResult {
    if (!_fetchResult) {
        _fetchResult = [[PHFetchResult alloc] init];
    }
    return _fetchResult;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self getAllGroupDatas];
}
- (void)setUp {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 80.f;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YHGroupTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YHGroupTableViewCell class])];
    [self.view addSubview:tableView];
    self.groupTableView = tableView;
    
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    self.title = @"照片";
}
- (void)cancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getAllGroupDatas {
    NSMutableArray *array = [NSMutableArray array];
    if (kiOS8Later) {
        [self.fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj);
        }];
    } else {
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
    }
}
#pragma mark - TableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YHGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YHGroupTableViewCell class])];
    YHPhotoModel *model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YHPhotoModel *model = _dataSource[indexPath.row];
    YHAlbumPickerViewController *albumPickerVC = [YHAlbumPickerViewController albumPickerViewController];
    albumPickerVC.model = model;
    [self.navigationController pushViewController:albumPickerVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
