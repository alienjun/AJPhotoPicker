//
//  AJPhotoListCellTapView.m
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoListCellTapView.h"

@interface AJPhotoListCellTapView()
@property(nonatomic,strong)UIImageView *selectIcon;
@end

@implementation AJPhotoListCellTapView
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
        
        _selectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - checkedIcon.size.width - 5, frame.size.height-checkedIcon.size.height - 5, checkedIcon.size.width, checkedIcon.size.height)];
        [self addSubview:_selectIcon];
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
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected {
    if (_disabled) {
        self.backgroundColor = disabledColor;
        [_selectIcon setImage:nil];
        return;
    }
    
    _selected = selected;
    if (_selected) {
        self.backgroundColor = selectedColor;
        [_selectIcon setImage:checkedIcon];
    } else {
        self.backgroundColor = [UIColor clearColor];
        [_selectIcon setImage:nil];
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
