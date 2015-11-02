//
//  BoPhotoListView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoPhotoListView.h"
#import "BoPhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BoPhotoListView()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *assets;
@end

@implementation BoPhotoListView
#pragma mark - lifecycle
-(instancetype)init{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [[BoPhotoListView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(void)initCommon{
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[BoPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setAssetsGroup:(ALAssetsGroup *)assetsGroup{
    _assetsGroup = assetsGroup;
    [self setupAssets];
}

- (void)setupAssets{
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset){
            [self.assets addObject:asset];
            
//            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
//            if ([type isEqual:ALAssetTypePhoto])
//                self.numberOfPhotos ++;
//            if ([type isEqual:ALAssetTypeVideo])
//                self.numberOfVideos ++;
        }else if (self.assets.count > 0){
            [self reloadData];
            [self scrollsToTop];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    BoPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    if (cell == nil) {
//        cell = [[BoPhotoListCell alloc] init];
    }
    
    [cell bind:self.assets[indexPath.row] selectionFilter:self.selectionFilter];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wh = (collectionView.bounds.size.width - 20)/3.0;
    
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
