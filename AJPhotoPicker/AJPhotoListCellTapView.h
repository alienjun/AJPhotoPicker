//
//  AJPhotoListCellTapView.h
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@interface AJPhotoListCellTapView : UIView
//是否选中
@property (nonatomic, assign) BOOL selected;
//是否可操作
@property (nonatomic, assign) BOOL disabled;
@end
