//
//  AJPhotoListCell.m
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AJPhotoListCellTapView.h"
#import "AJGradientView.h"

@interface AJPhotoListCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) AJPhotoListCellTapView *tapAssetView;
@property (strong, nonatomic) ALAsset *asset;
@property (weak, nonatomic) AJGradientView *gradientView;
@end

@implementation AJPhotoListCell

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSelected:(BOOL)isSelected {
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
        AJPhotoListCellTapView *tapView = [[AJPhotoListCellTapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:tapView];
        self.tapAssetView = tapView;
    }
    
    if ([asset isKindOfClass:[UIImage class]]) {
        [self.imageView setImage:(UIImage *)asset];
    } else {
        [self.imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
            if (!self.gradientView) {
                AJGradientView *gradientView = [[AJGradientView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                [self.contentView insertSubview:gradientView aboveSubview:self.imageView];
                self.gradientView = gradientView;
                [self.gradientView setupCAGradientLayer:@[(id)[[UIColor clearColor] colorWithAlphaComponent:0.0f].CGColor, (id)[[UIColor colorWithRed:23.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0] colorWithAlphaComponent:0.8f].CGColor] locations:@[@0.8f,@1.0f]];
                
                //icon
                UIImageView *videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.bounds.size.height-15, 15, 8)];
                videoIcon.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/AssetsPickerVideo@2x.png"]];
                [self.gradientView addSubview:videoIcon];
                
                //duration
                UILabel *duration = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(videoIcon.frame), self.bounds.size.height-17, self.bounds.size.width-CGRectGetMaxX(videoIcon.frame)-5, 12)];
                duration.font = [UIFont systemFontOfSize:12];
                duration.textColor = [UIColor whiteColor];
                duration.textAlignment = NSTextAlignmentRight;
                duration.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [self.gradientView addSubview:duration];
                
                double value = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
                duration.text = [self timeFormatted:value];
            }
        } else {
            [self.gradientView removeFromSuperview];
        }
    }
    
    _tapAssetView.disabled = ![selectionFilter evaluateWithObject:asset];
    _tapAssetView.selected = isSelected;
}

- (void)isSelected:(BOOL)isSelected {
    _tapAssetView.selected = isSelected;
}

#pragma mark - Utility
//时间格式化
- (NSString *)timeFormatted:(double)totalSeconds {
    NSTimeInterval timeInterval = totalSeconds;
    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
    int hour = 0;
    int minute = seconds / 60.0f;
    int second = seconds % 60;
    if (minute > 59) {
        hour = minute / 60;
        minute = minute % 60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

@end
