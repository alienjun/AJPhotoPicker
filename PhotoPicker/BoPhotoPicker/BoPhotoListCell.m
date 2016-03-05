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
#import "AJGradientView.h"

@interface BoPhotoListCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) BoTapAssetView *tapAssetView;
@property (strong, nonatomic) ALAsset *asset;
@property (weak, nonatomic) AJGradientView *gradientView;
@end

@implementation BoPhotoListCell

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced {
    self.asset = asset;
    if (self.imageView == nil) {
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.equalTo(self.contentView);
        }];
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imageView.layer.cornerRadius = 3;
        self.imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.tapAssetView) {
        BoTapAssetView *tapView = [BoTapAssetView new];
        [self.contentView addSubview:tapView];
        self.tapAssetView = tapView;
        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.equalTo(self.contentView);
        }];
    }
    
    if ([asset isKindOfClass:[UIImage class]]) {
        [self.imageView setImage:(UIImage *)asset];
    } else {
        [self.imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
        if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
            if (!self.gradientView) {
                AJGradientView *gradientView = [AJGradientView new];
                [self.contentView insertSubview:gradientView aboveSubview:self.imageView];
                self.gradientView = gradientView;
                [self.gradientView setupCAGradientLayer:@[(id)[[UIColor clearColor] colorWithAlphaComponent:0.0f].CGColor, (id)[[UIColor colorWithRed:23.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1.0] colorWithAlphaComponent:0.8f].CGColor] locations:@[@0.8f,@1.0f]];
                [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(self.contentView);
                    make.top.mas_equalTo(self.contentView);
                    make.trailing.mas_equalTo(self.contentView);
                    make.bottom.mas_equalTo(self.contentView);
                }];
                
                //icon
                UIImageView *videoIcon = [UIImageView new];
                videoIcon.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/AssetsPickerVideo@2x.png"]];
                [self.gradientView addSubview:videoIcon];
                [videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.gradientView).offset(-7);
                    make.width.mas_equalTo(@15);
                    make.height.mas_equalTo(@8);
                    make.leading.mas_equalTo(self.gradientView).offset(5);
                }];
                
                //duration
                UILabel *duration = [UILabel new];
                duration.font = [UIFont systemFontOfSize:12];
                duration.textColor = [UIColor whiteColor];
                [self.gradientView addSubview:duration];
                [duration mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.gradientView).offset(-5);
                    make.height.mas_equalTo(@12);
                    make.trailing.mas_equalTo(self.gradientView).offset(-5);
                }];
                double value = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
                duration.text = [self timeFormatted:value];
            }
        } else {
            [self.gradientView removeFromSuperview];
        }

    }
    
    _tapAssetView.disabled =! [selectionFilter evaluateWithObject:asset];
    _tapAssetView.selected = isSeleced;
}

- (void)isSeleced:(BOOL)isSeleced {
    _tapAssetView.selected = isSeleced;
}


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
