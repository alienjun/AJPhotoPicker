//
//  BoTapAssetView.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAsset;

@protocol BoTapAssetViewDelegate <NSObject>

//选中
- (void)touchSelect:(BOOL)select;

//是否可选
- (BOOL)shouldTap;

//不可选时进行其他操作
- (void)shouldTapAction;

@end

@interface BoTapAssetView : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<BoTapAssetViewDelegate> delegate;
@end
