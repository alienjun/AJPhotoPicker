//
//  AJPhotoPickerViewController.h
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AJPhotoPickerViewController;
@protocol AJPhotoPickerProtocol <NSObject>
@optional
//选择完成
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets;

//点击选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset*)asset;

//取消选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset*)asset;

//点击相机按钮相关操作
- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker;

//取消
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker;

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker;

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker;

//选择过滤
- (void)photoPickerDidSelectionFilter:(AJPhotoPickerViewController *)picker;

@end


@interface AJPhotoPickerViewController : UIViewController

@property (weak, nonatomic) id<AJPhotoPickerProtocol> delegate;

//选择过滤
@property (nonatomic, strong) NSPredicate *selectionFilter;

//资源过滤
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

//选中的项
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

//最多选择项
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

//最少选择项
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

//显示空相册
@property (nonatomic, assign) BOOL showEmptyGroups;

//是否开启多选
@property (nonatomic, assign) BOOL multipleSelection;
@end
