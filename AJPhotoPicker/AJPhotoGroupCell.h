//
//  AJPhotoGroupCell.h
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

@interface AJPhotoGroupCell : UITableViewCell

/**
 *  显示相册信息
 *
 *  @param assetsGroup 相册
 */
- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
