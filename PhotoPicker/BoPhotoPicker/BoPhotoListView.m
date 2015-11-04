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
#import "BoPhotoPickerViewController.h"

@interface BoPhotoListView()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,BoPhotoListCellDelegate>
@property (strong, nonatomic) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;
@end

@implementation BoPhotoListView
#pragma mark - lifecycle
- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [[BoPhotoListView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[BoPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    _assetsGroup = assetsGroup;
    [self setupAssets];
}


//加载图片
- (void)setupAssets {
    
    [self.indexPathsForSelectedItems removeAllObjects];
    [self.assets removeAllObjects];
    [self.assets addObject:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/BoAssetsCamera@2x.png"]]];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset){
            [self.assets addObject:asset];
        }else if (self.assets.count > 0){
            [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            [self reloadData];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    BoPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    BOOL isSeleced = [((BoPhotoPickerViewController *)_my_delegate).indexPathsForSelectedItems containsObject:self.assets[indexPath.row]];
    cell.delegate = self;
    [cell bind:self.assets[indexPath.row] selectionFilter:((BoPhotoPickerViewController *)_my_delegate).selectionFilter isSeleced:isSeleced];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wh = (collectionView.bounds.size.width - 20)/3.0;
    
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

#pragma mark - BoPhotoListCellDelegate
- (BOOL)shouldSelectAsset:(ALAsset*)asset {
    //相机按钮
    if ([asset isKindOfClass:[UIImage class]]) {
        return NO;
    }
    
    BoPhotoPickerViewController *vc = (BoPhotoPickerViewController *)self.my_delegate;
    
    //单选
    if (!vc.multipleSelection && self.indexPathsForSelectedItems.count==1) {
        NSInteger index = [self.assets indexOfObject:self.indexPathsForSelectedItems[0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.indexPathsForSelectedItems removeAllObjects];
        [self reloadItemsAtIndexPaths:@[indexPath]];
    }
    
    BOOL selectable = [vc.selectionFilter evaluateWithObject:asset];
    if (self.indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection && ![vc.indexPathsForSelectedItems containsObject:asset]) {
        if (vc.delegate && [vc.delegate respondsToSelector:@selector(photoPickerDidMaximum:)]) {
            [vc.delegate photoPickerDidMaximum:vc];
        }
    }
    
    return (selectable && self.indexPathsForSelectedItems.count < vc.maximumNumberOfSelection);
}

- (void)didSelectAsset:(ALAsset*)asset {
    [self.indexPathsForSelectedItems addObject:asset];
    
    BoPhotoPickerViewController *vc = (BoPhotoPickerViewController *)self.my_delegate;
    vc.indexPathsForSelectedItems = self.indexPathsForSelectedItems;
    
    if (vc.delegate && [vc.delegate respondsToSelector:@selector(photoPicker:didSelectAsset:)])
        [vc.delegate photoPicker:vc didSelectAsset:asset];
    
}

- (void)didDeselectAsset:(ALAsset*)asset {
    [_indexPathsForSelectedItems removeObject:asset];
    
    BoPhotoPickerViewController *vc = (BoPhotoPickerViewController *)self.my_delegate;
    vc.indexPathsForSelectedItems = self.indexPathsForSelectedItems;
    
    if (vc.delegate && [vc.delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
        [vc.delegate photoPicker:vc didDeselectAsset:asset];
    
}

- (void)tapAction:(ALAsset *)asset {
    if (_my_delegate && [_my_delegate respondsToSelector:@selector(tapAction:)]) {
        [_my_delegate tapAction:asset];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (NSMutableArray *)indexPathsForSelectedItems {
    if (!_indexPathsForSelectedItems) {
        _indexPathsForSelectedItems = [[NSMutableArray alloc] init];
    }
    return _indexPathsForSelectedItems;
}
@end
