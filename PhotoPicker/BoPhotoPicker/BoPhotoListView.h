//
//  BoPhotoListView.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;
@class ALAsset;

@protocol BoPhotoListProtocol <NSObject>

- (void)tapAction:(ALAsset *)asset;

@end


@interface BoPhotoListView : UICollectionView
@property (weak, nonatomic) id<BoPhotoListProtocol> my_delegate;
@property (strong, nonatomic) ALAssetsGroup *assetsGroup;

@end
