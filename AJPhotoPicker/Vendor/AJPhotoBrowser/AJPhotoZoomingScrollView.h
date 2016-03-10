//
//  AJPhotoZoomingScrollView.h
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@protocol AJPhotoZoomingScrollViewDelegate <NSObject>

//单击
- (void)singleTapDetected:(UITouch *)touch;

@end

@interface AJPhotoZoomingScrollView : UIScrollView
@property (weak, nonatomic) id<AJPhotoZoomingScrollViewDelegate> mydelegate;

/**
 *  显示图片
 *
 *  @param image 图片
 */
- (void)setShowImage:(UIImage *)image;

/**
 *  调整尺寸
 */
- (void)setMaxMinZoomScalesForCurrentBounds;

/**
 *  重用，清理资源
 */
- (void)prepareForReuse;

@end
