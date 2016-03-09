//
//  AJPhotoGroupView.h
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@class ALAssetsFilter;

@protocol AJPhotoGroupViewProtocol <NSObject>

/**
 *  选中相册
 *
 *  @param assetsGroup 相册
 */
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup;

@end


@interface AJPhotoGroupView : UITableView
//委托
@property (weak, nonatomic) id<AJPhotoGroupViewProtocol> my_delegate;
//过滤掉不现实的信息
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
//选中相册的索引
@property (nonatomic) NSInteger selectIndex;

/**
 *  加载并显示相册
 */
- (void)setupGroup;

@end
