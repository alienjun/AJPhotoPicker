//
//  BoGradientView.m
//  bobohair-iphone
//
//  Created by AlienJunX on 15/4/28.
//  Copyright (c) 2015年 Shanghai Metis IT Co.,Ltd. All rights reserved.
//

#import "AJGradientView.h"

@implementation AJGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations {
    CAGradientLayer *gradient=(CAGradientLayer*)self.layer;
    gradient.colors = colors;
    gradient.locations = locations;
}

@end
