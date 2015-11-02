//
//  DemoView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "DemoView.h"

@implementation DemoView


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:self];
    
    CALayer *clickLayer = [CALayer layer];
    clickLayer.backgroundColor = [UIColor redColor].CGColor;
    clickLayer.masksToBounds = YES;
    clickLayer.cornerRadius = 10;
    clickLayer.frame = CGRectMake(0, 0, 20, 20);
    clickLayer.position = clickPoint;
    clickLayer.opacity = 0.5;
    [self.layer addSublayer:clickLayer];
    
    
    
    CABasicAnimation* zoom = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoom.toValue = [NSNumber numberWithDouble:8.5];
    zoom.duration = .2;
    
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeout.toValue=[NSNumber numberWithFloat:0.0];
    fadeout.duration=.2;
    fadeout.fillMode = kCAFillModeForwards;
    fadeout.removedOnCompletion = NO;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.duration=0.2;
    [group setAnimations:@[zoom,fadeout]];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [clickLayer addAnimation:group forKey:nil];
    
//    [UIView animateWithDuration:1.5 animations:^{
//        clickLayer.affineTransform = CGAffineTransformMakeScale(3.0, 3.0);
//    } completion:^(BOOL finished) {
////        [clickLayer removeFromSuperlayer];
//    }];
    
    //动画
//    [UIView beginAnimations:@"transform.scale" context:NULL];
//    [UIView setAnimationDuration:0.5];
//    clickLayer.affineTransform = CGAffineTransformMakeScale(3.0, 3.0);
//    
//    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    
}

@end
