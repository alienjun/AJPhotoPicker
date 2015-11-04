//
//  BoPhotoListCell.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@protocol BoPhotoListCellDelegate <NSObject>

//每次点击相关方法
- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

//特殊的cell 点击操作
- (void)tapAction:(ALAsset *)asset;
@end


@interface BoPhotoListCell : UICollectionViewCell
@property (weak, nonatomic) id<BoPhotoListCellDelegate> delegate;

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end
