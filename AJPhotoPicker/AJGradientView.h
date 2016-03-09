//
//  AJGradientView.h
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/4/28.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@interface AJGradientView : UIView

- (void)setupCAGradientLayer:(NSArray *)colors locations:(NSArray *)locations;

@end
