//
//  BoTapAssetView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoTapAssetView.h"

@interface BoTapAssetView()
@property(nonatomic,strong)UIImageView *selectView;
@end

@implementation BoTapAssetView
static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

#pragma mark - init
+ (void)initialize {
    checkedIcon = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/BoAssetsPickerChecked@2x.png"]];
    selectedColor = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor = [UIColor colorWithWhite:1 alpha:0.8];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _selectView = [UIImageView new];
        [self addSubview:_selectView];
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.height.equalTo(@(checkedIcon.size.height));
            make.width.equalTo(@(checkedIcon.size.width));
            make.bottom.equalTo(self).offset(-5);
        }];
    }
    return self;
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
    //执行触摸动画
    [self touchAnimation:touches];
}

#pragma mark - setter
- (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
    if (_disabled) {
        self.backgroundColor = disabledColor;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected {
    if (_disabled) {
        self.backgroundColor = disabledColor;
        [_selectView setImage:nil];
        return;
    }
    
    _selected = selected;
    if (_selected) {
        self.backgroundColor = selectedColor;
        [_selectView setImage:checkedIcon];
    }else{
        self.backgroundColor = [UIColor clearColor];
        [_selectView setImage:nil];
    }
}

//触摸动作的相关过程动画
- (void)touchAnimation:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:self];
    
    CALayer *clickLayer = [CALayer layer];
    clickLayer.backgroundColor = [UIColor whiteColor].CGColor;
    clickLayer.masksToBounds = YES;
    clickLayer.cornerRadius = 3;
    clickLayer.frame = CGRectMake(0, 0, 6, 6);
    clickLayer.position = clickPoint;
    clickLayer.opacity = 0.3;
    clickLayer.name = @"clickLayer";
    [self.layer addSublayer:clickLayer];
    
    CABasicAnimation* zoom = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoom.toValue = @38.0;
    zoom.duration = .4;
    
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeout.toValue = @0.0;
    fadeout.duration = .4;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.4;
    [group setAnimations:@[zoom,fadeout]];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [clickLayer addAnimation:group forKey:@"animationKey"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        for (int i = 0; i < self.layer.sublayers.count; i++) {
            CALayer *obj = self.layer.sublayers[i];
            if (obj.name != nil && [@"clickLayer" isEqualToString:obj.name] && [obj animationForKey:@"animationKey"] == anim) {
                [obj removeFromSuperlayer];
            }
        }
    }
}

@end
