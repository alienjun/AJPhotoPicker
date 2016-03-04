//
//  BoPhotoListView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoPhotoListView.h"
#import "BoPhotoListCell.h"

@implementation BoPhotoListView
#pragma mark - lifecycle
- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [[BoPhotoListView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    if (self) {
        [self registerClass:[BoPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
