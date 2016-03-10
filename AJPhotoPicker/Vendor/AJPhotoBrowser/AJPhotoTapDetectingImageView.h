//
//  AJPhotoTapDetectingImageView.h
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@protocol PhotoTapDetectingImageViewDelegate <NSObject>

- (void)singleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

- (void)doubleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

@end

@interface AJPhotoTapDetectingImageView : UIImageView

@property (weak, nonatomic) id<PhotoTapDetectingImageViewDelegate> delegate;

@end
