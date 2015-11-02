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
@property (strong, nonatomic) BoTapAssetView *tapAssetView;
@end

@implementation BoPhotoListCell


-(void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter{
    if (self.imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
    
    [self.imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
}
@end
