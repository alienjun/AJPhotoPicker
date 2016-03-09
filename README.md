#PhotoPicker
2016-03-05 
添加滑动多选

用于发表图片时候选择相册图片和拍照这样的需求，虽然网上也有很多类似的控件，写的挺不错的，但是深入使用就有些问题，还是自己写算了；网上的一些轮子看起来好像能用，但深入之后总是没那么完善需要改了各种测试，用到自己项目里面需要费点时间；再加上定制化和兼容问题，和后期考虑的一些需求，就更应该自己开个坑了。

目前这个控件自己用起来非常简单，就几行代码+委托就可以了。要做定制化也比较容易，项目为了兼容iOS7，读取照片使用AssetsLibrary。

布局基本上都是基于Masonry实现，因为项目里面都在用它。


![Aaron Swartz](https://github.com/alienjun/PhotoPicker/blob/master/Screenshots/111.gif)

![Aaron Swartz](https://github.com/alienjun/PhotoPicker/blob/master/Screenshots/222.gif)

![Aaron Swartz](https://github.com/alienjun/PhotoPicker/blob/master/Screenshots/333.gif)

####使用方式：
```
    BoPhotoPickerViewController *picker = [[BoPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 5;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    
    [self presentViewController:picker animated:YES completion:nil];

```

委托：
```
#pragma mark - BoPhotoPickerProtocol
-(void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets{
}

-(void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset{
    NSLog(@"%s",__func__);
}

-(void)photoPicker:(BoPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset{
    NSLog(@"%s",__func__);
}

-(void)photoPickerDidMaximum:(BoPhotoPickerViewController *)picker{
    NSLog(@"%s",__func__);
}

-(void)photoPickerDidMinimum:(BoPhotoPickerViewController *)picker{
    NSLog(@"%s",__func__);
}

-(void)photoPickerTapAction:(BoPhotoPickerViewController *)picker{
}
```

详细使用见Demo。


欢迎一起交流技术。

微博：[AlienJunX](http://weibo.com/alienjunx)

##License

This project is under MIT License. See LICENSE file for more information.
