//
//  AJPhotoPickerViewController.m
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoPickerViewController.h"
#import "AJPhotoGroupView.h"
#import "AJPhotoListView.h"
#import "AJPhotoListCell.h"
#import "Masonry.h"

@interface AJPhotoPickerViewController()<AJPhotoGroupViewProtocol,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) AJPhotoGroupView *photoGroupView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *navBar;
@property (weak, nonatomic) UIView *bgMaskView;
@property (weak, nonatomic) AJPhotoListView *photoListView;
@property (weak, nonatomic) UIImageView *selectTip;
@property (weak, nonatomic) UIButton *okBtn;
@property (nonatomic) BOOL isNotAllowed;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSIndexPath *lastAccessed;
@end

@implementation AJPhotoPickerViewController

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        _maximumNumberOfSelection = 10;
        _minimumNumberOfSelection = 0;
        _assetsFilter = [ALAssetsFilter allAssets];
        _showEmptyGroups = NO;
        _selectionFilter = [NSPredicate predicateWithValue:YES];
    }
    return self;
}

#pragma mark - lifecycle
- (void)loadView {
    [super loadView];
    //加载控件
    //导航条
    [self setupNavBar];
    
    //列表view
    [self setupPhotoListView];
    
    //相册分组
    [self setupGroupView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //没有相册访问权限通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNotAllowed)
                                                 name:@"NotAllowedPhoto"
                                               object:nil];
    //数据初始化
    [self setupData];
    
    //滑动选中图片
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onPanForSelection:)];
    [self.view addGestureRecognizer:pan];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}


#pragma mark - 界面初始化

/**
 *  头部导航
 */
- (void)setupNavBar {
    //界面组件
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:66.0/255.0 blue:67.0/255.0 alpha:1.0];
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@64);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    self.navBar = navBar;
    
    //cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.leading.mas_equalTo(navBar);
        make.top.mas_equalTo(navBar).offset(20);
        make.width.mas_equalTo(@60);
    }];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navBar);
        make.centerY.mas_equalTo(navBar).offset(10);
    }];
    self.titleLabel = titleLabel;
    UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tapBtn.backgroundColor = [UIColor clearColor];
    [tapBtn addTarget:self action:@selector(selectGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:tapBtn];
    [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleLabel.mas_width).offset(50);
        make.centerX.mas_equalTo(navBar);
        make.centerY.mas_equalTo(navBar).offset(10);
        make.height.mas_equalTo(@44);
    }];
    
    
    //selectTipImageView
    UIImageView *selectTip = [[UIImageView alloc] init];
    selectTip.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/BoSelectGroup_tip@2x.png"]];
    [navBar addSubview:selectTip];
    [selectTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleLabel.mas_trailing).offset(10);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@5);
        make.centerY.mas_equalTo(titleLabel);
    }];
    self.selectTip = selectTip;
    
    //okBtn
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.trailing.mas_equalTo(navBar);
        make.top.mas_equalTo(navBar).offset(20);
        make.width.mas_equalTo(@60);
    }];
    self.okBtn = okBtn;
}

/**
 *  照片列表
 */
- (void)setupPhotoListView {
    AJPhotoListView *collectionView = [[AJPhotoListView alloc] init];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view insertSubview:collectionView atIndex:0];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64);
        make.bottom.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
    }];
    self.photoListView = collectionView;
}

/**
 *  相册
 */
- (void)setupGroupView {
    AJPhotoGroupView *photoGroupView = [[AJPhotoGroupView alloc] init];
    photoGroupView.assetsFilter = self.assetsFilter;
    photoGroupView.my_delegate = self;
    [self.view insertSubview:photoGroupView belowSubview:self.navBar];
    self.photoGroupView = photoGroupView;
    photoGroupView.hidden = YES;
    [photoGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navBar.mas_bottom).offset(-360);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@360);
    }];
}

- (void)setupData {
    [self.photoGroupView setupGroup];
}


#pragma mark - 相册切换
- (void)selectGroupAction:(UIButton *)sender {
    //无权限
    if (self.isNotAllowed) {
        return;
    }
    
    if (self.photoGroupView.hidden) {
        [self bgMaskView];
        self.photoGroupView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, 360);
            self.selectTip.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [self hidenGroupView];
    }
}

- (void)hidenGroupView {
    [self.bgMaskView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.photoGroupView.transform = CGAffineTransformIdentity;
        self.selectTip.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.photoGroupView.hidden = YES;
    }];
}


#pragma mark - BoPhotoGroupViewProtocol
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup {
    [self loadAssets:assetsGroup];
    self.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self hidenGroupView];
}

//加载图片
- (void)loadAssets:(ALAssetsGroup *)assetsGroup {
    [self.indexPathsForSelectedItems removeAllObjects];
    [self.assets removeAllObjects];
    
    //相机cell
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    //默认第一个为相机按钮
    [tempList addObject:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BoPhotoPicker.bundle/images/BoAssetsCamera@2x.png"]]];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            [tempList addObject:asset];
        } else if (tempList.count > 0) {
            //排序
            NSArray *sortedList = [tempList sortedArrayUsingComparator:^NSComparisonResult(ALAsset *first, ALAsset *second) {
                if ([first isKindOfClass:[UIImage class]]) {
                    return NSOrderedAscending;
                }
                id firstData = [first valueForProperty:ALAssetPropertyDate];
                id secondData = [second valueForProperty:ALAssetPropertyDate];
                return [secondData compare:firstData];//降序
            }];
            [self.assets addObjectsFromArray:sortedList];
            
            [self.photoListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            [self.photoListView reloadData];
        }
    };
    
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    AJPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    BOOL isSelected = [self.indexPathsForSelectedItems containsObject:self.assets[indexPath.row]];
    [cell bind:self.assets[indexPath.row] selectionFilter:self.selectionFilter isSelected:isSelected];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AJPhotoListCell *cell = (AJPhotoListCell *)[self.photoListView cellForItemAtIndexPath:indexPath];
    ALAsset *asset = self.assets[indexPath.row];
    
    //相机按钮处理
    if ([asset isKindOfClass:[UIImage class]] && _delegate && [_delegate respondsToSelector:@selector(photoPickerTapCameraAction:)]) {
        [_delegate photoPickerTapCameraAction:self];
        return;
    }
    
    //单选
    if (!self.multipleSelection && self.indexPathsForSelectedItems.count==1) {
        //取消上一个选中
        NSInteger index = [self.assets indexOfObject:self.indexPathsForSelectedItems[0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        AJPhotoListCell *previousCell = (AJPhotoListCell *)[self.photoListView cellForItemAtIndexPath:indexPath];
        [previousCell isSelected:NO];
        [self.indexPathsForSelectedItems removeAllObjects];
        
        //选中当前的
        [self.indexPathsForSelectedItems addObject:asset];
        [cell isSelected:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
            [_delegate photoPicker:self didDeselectAsset:asset];
        return;
    }
    
    //超出最大限制
    if (self.indexPathsForSelectedItems.count >= self.maximumNumberOfSelection && ![self.indexPathsForSelectedItems containsObject:asset]) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidMaximum:)]) {
            [_delegate photoPickerDidMaximum:self];
            return;
        }
    }
    
    //选择过滤
    BOOL selectable = [self.selectionFilter evaluateWithObject:asset];
    if (!selectable) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidSelectionFilter:)]) {
            [_delegate photoPickerDidSelectionFilter:self];
            return;
        }
    }
    
    //取消选中
    if ([self.indexPathsForSelectedItems containsObject:asset]) {
        [self.indexPathsForSelectedItems removeObject:asset];
        [cell isSelected:NO];
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
            [_delegate photoPicker:self didDeselectAsset:asset];
        return;
    }
    
    //选中
    [self.indexPathsForSelectedItems addObject:asset];
    [cell isSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAsset:)])
        [_delegate photoPicker:self didSelectAsset:asset];
}


#pragma mark - Action
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:_photoListView];
    
    for (UICollectionViewCell *cell in _photoListView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            NSIndexPath *indexPath = [_photoListView indexPathForCell:cell];
            if (_lastAccessed != indexPath) {
                [self collectionView:_photoListView didSelectItemAtIndexPath:indexPath];
            }
            _lastAccessed = indexPath;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        _lastAccessed = nil;
    }
}

- (void)cancelBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(photoPickerDidCancel:)]) {
        [_delegate photoPickerDidCancel:self];
    }
}

- (void)okBtnAction:(UIButton *)sender {
    if (self.minimumNumberOfSelection > self.indexPathsForSelectedItems.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidMinimum:)]) {
            [_delegate photoPickerDidMinimum:self];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAssets:)]) {
            [_delegate photoPicker:self didSelectAssets:self.indexPathsForSelectedItems];
        }
    }
}


#pragma mark - 遮罩背景
- (UIView *)bgMaskView {
    if (_bgMaskView == nil) {
        UIView *bgMaskView = [[UIView alloc] init];
        bgMaskView.alpha = 0.4;
        bgMaskView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:bgMaskView aboveSubview:self.photoListView];
        bgMaskView.userInteractionEnabled = YES;
        [bgMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgMaskView:)]];
        [bgMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.leading.mas_equalTo(self.view);
            make.trailing.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        _bgMaskView = bgMaskView;
    }
    return _bgMaskView;
}

- (void)tapBgMaskView:(UITapGestureRecognizer *)sender {
    if (!self.photoGroupView.hidden) {
        [self hidenGroupView];
    }
}

#pragma mark - 没有访问权限提示
- (void)showNotAllowed {
    //没有权限时隐藏部分控件
    self.isNotAllowed = YES;
    self.selectTip.hidden = YES;
    self.titleLabel.text = @"无权限访问相册";
    self.okBtn.hidden = YES;
    UIAlertView *alert;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"请在iPhone的“设置”-“隐私”-“照片”中，找到波波网更改"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"请先允许访问照片"
                                          delegate:self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@"前往", nil];
    }
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
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
