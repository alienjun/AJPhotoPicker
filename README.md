
介绍
==============
基于AssetsLibrary的照片选取器。<br/>
![Aaron Swartz](https://github.com/alienjun/PhotoPicker/blob/master/Screenshots/111.gif)
![Aaron Swartz](https://github.com/alienjun/PhotoPicker/blob/master/Screenshots/222.gif)

描述
==============
用于代替系统的图片选择器的控件，基于AssetsLibrary方便定制自己的需求，使用UICollectionView进行图片展示；网上也有一些做的很不错的类似控件，而大多数实现过于复杂不方便自己定制，在试用了几款后决定自己写这个控件；目前已经添加了几个自己需要的功能，同时控件在集成使用时也相对简单，几行代码+委托就可以了。在布局上使用autolayout基于Masonry。


特性
==============
- 基于AssetsLibrary、UICollectionView、Masonry。
- 支持 视频、图片选择。
- 支持多选、滑动多选、预览。
- 使用方式简单，便于定制。



用法
==============
###弹出图片选择控件
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    //最大可选项
    picker.maximumNumberOfSelection = 5;
    //是否多选
    picker.multipleSelection = YES;
    //资源过滤
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    //是否显示空的相册
    picker.showEmptyGroups = YES;
    //委托（必须）
    picker.delegate = self;
    //可选过滤
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];


###实现委托
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


安装
==============
### 手动安装

1. 下载 AJPhotoPicker 文件夹内的所有内容。
2. 将 AJPhotoPicker 内的源文件添加(拖放)到你的工程(如果你的工程中有Masonry，可以将AJPhotoPicker下的Vendor/Masonry删除)。
3. 链接以下 frameworks:
	* UIKit
	* CoreFoundation
	* QuartzCore
	* AssetsLibrary
	* MobileCoreServices
	
4. 导入 `AJPhotoPickerViewController.h`。



系统要求
==============
该项目最低支持 `iOS 7.0` 和 `Xcode 7.0`。


许可证
==============
AJPhotoPicker 使用 MIT 许可证，详情见 LICENSE 文件。



