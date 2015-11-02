//
//  BoPhotoListCell.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@interface BoPhotoListCell : UICollectionViewCell

-(void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter;

@end
