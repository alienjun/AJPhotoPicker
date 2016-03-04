//
//  BoPhotoListCell.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoPhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BoTapAssetView.h"


@interface BoPhotoListCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) BoTapAssetView *tapAssetView;
@property (strong, nonatomic) ALAsset *asset;
@end

@implementation BoPhotoListCell

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced {
    self.asset = asset;
    if (self.imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imageView.layer.cornerRadius = 3;
        self.imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.tapAssetView) {
        BoTapAssetView *tapView = [[BoTapAssetView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:tapView];
        self.tapAssetView = tapView;
    }
    
    if ([asset isKindOfClass:[UIImage class]]) {
        [self.imageView setImage:(UIImage *)asset];
    } else {
        [self.imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    }
    
    _tapAssetView.disabled =! [selectionFilter evaluateWithObject:asset];
    _tapAssetView.selected = isSeleced;
}

- (void)isSeleced:(BOOL)isSeleced {
    _tapAssetView.selected = isSeleced;
}

@end
