//
//  AJPhotoBrowserViewController.h
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@class AJPhotoBrowserViewController;
@protocol AJPhotoBrowserDelegate <NSObject>
@optional
/**
 *  删除照片
 *
 *  @param index 索引
 *  @param vc
 */
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index;

/**
 *  完成
 *
 *  @param photos 所有照片
 *  @param vc
 */
- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos;
@end

@interface AJPhotoBrowserViewController : UIViewController

@property (weak, nonatomic) id<AJPhotoBrowserDelegate> delegate;

/**
 *  初始化
 *
 *  @param photos 需要显示的照片，可以是ALAsset或者UIImage
 *
 *  @return
 */
- (instancetype)initWithPhotos:(NSArray *)photos;


/**
 *  初始化
 *
 *  @param photos 需要显示的照片，可以是ALAsset或者UIImage
 *  @param index  显示第几张 index 防止越界
 *
 *  @return
 */
- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index;

@end
