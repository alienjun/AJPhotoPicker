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
