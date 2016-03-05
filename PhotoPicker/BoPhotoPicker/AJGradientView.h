//
//  BoGradientView.h
//  bobohair-iphone
//
//  Created by AlienJunX on 15/4/28.
//  Copyright (c) 2015年 Shanghai Metis IT Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJGradientView : UIView

- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations;

@end
