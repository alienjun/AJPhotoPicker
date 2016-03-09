//
//  AJTapDetectingView.h
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@protocol TapDetectingViewDelegate <NSObject>

//单击
- (void)viewSingleTapDetected:(UIView *)view touch:(UITouch *)touch;

//双击
- (void)viewDoubleTapDetected:(UIView *)view touch:(UITouch *)touch;

@end

@interface AJTapDetectingView : UIView

@property (weak, nonatomic) id<TapDetectingViewDelegate> delegate;

@end
