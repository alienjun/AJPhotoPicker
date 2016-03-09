//
//  AJPhotoBrowserViewController.m
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoBrowserViewController.h"
#import "AJPhotoZoomingScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Masonry.h"

@interface AJPhotoBrowserViewController()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    //data
    NSUInteger _currentPageIndex;
    NSMutableArray *_photos;
    
    //views
    UIScrollView *_photoScrollView;
    
    //Paging & layout
    NSMutableSet *_visiblePhotoViews,*_reusablePhotoViews;
}
@end

@implementation AJPhotoBrowserViewController

#pragma mark - init

- (instancetype)initWithPhotos:(NSArray *)photos {
    self = [super init];
    if (self) {
        [self commonInit];
        _currentPageIndex = 0;
        [_photos addObjectsFromArray:photos];
    }
    return self;
}

- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index {
    self = [super init];
    if (self) {
        [self commonInit];
        if (index < 0)
            _currentPageIndex = 0;
        if (index > photos.count-1)
            _currentPageIndex = photos.count - 1;
        
        [_photos addObjectsFromArray:photos];
    }
    return self;
}

- (void)commonInit {
    _visiblePhotoViews = [[NSMutableSet alloc] init];
    _reusablePhotoViews = [[NSMutableSet alloc] init];
    _photos = [[NSMutableArray alloc] init];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //initUI
    [self createScrollView];
    
    [self createToolbar];
    
    [self showPhotos];
}

- (void)createScrollView {
    CGRect frame = self.view.bounds;
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = UIColor.clearColor;
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPageIndex * frame.size.width, 0);
}

- (void)createToolbar {
    //toolbar
    UIToolbar *toolBar = [UIToolbar new];
    toolBar.backgroundColor = [UIColor blackColor];
    //fixedSpace
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10;
    UIBarButtonItem *centerFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //完成
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction:)];
    doneBtn.title = @"完成";
    
    //删除
    UIBarButtonItem *delBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(delBtnAction:)];
    delBtn.title = @"删除";
    [toolBar setItems:@[fixedSpace, delBtn, centerFlexibleSpace, doneBtn, fixedSpace]];
    
    [self.view addSubview:toolBar];
    toolBar.tintColor = [UIColor whiteColor];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

//开始显示
- (void)showPhotos {
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = floor((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (firstIndex >= _photos.count) {
        firstIndex = _photos.count - 1;
    }
    if (lastIndex < 0){
        lastIndex = 0;
    }
    if (lastIndex >= _photos.count) {
        lastIndex = _photos.count - 1;
    }
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex = 0;
    for (AJPhotoZoomingScrollView *photoView in _visiblePhotoViews) {
        photoViewIndex = photoView.tag-100;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView prepareForReuse];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

//显示指定索引的图片
- (void)showPhotoViewAtIndex:(NSInteger)index {
    AJPhotoZoomingScrollView *photoView = [self dequeueReusablePhotoView];
    if (photoView == nil) {
        photoView = [[AJPhotoZoomingScrollView alloc] init];
    }
    
    //显示大小处理
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.origin.x = bounds.size.width * index;
    photoView.tag = 100 + index;
    photoView.frame = photoViewFrame;
    
    //显示照片处理
    UIImage *photo = nil;
    id photoObj = _photos[index];
    if ([photoObj isKindOfClass:[UIImage class]]) {
        photo = photoObj;
    } else if ([photoObj isKindOfClass:[ALAsset class]]) {
        CGImageRef fullScreenImageRef = ((ALAsset *)photoObj).defaultRepresentation.fullScreenImage;
        photo = [UIImage imageWithCGImage:fullScreenImageRef];
    }
    
    //show
    [photoView setShowImage:photo];
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
}

//获取可重用的view
- (AJPhotoZoomingScrollView *)dequeueReusablePhotoView {
    AJPhotoZoomingScrollView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

//判断是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSInteger)index {
    for (AJPhotoZoomingScrollView* photoView in _visiblePhotoViews) {
        if ((photoView.tag - 100) == index) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action
- (void)doneBtnAction:(UIBarButtonItem *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didDonePhotos:)]) {
        [_delegate photoBrowser:self didDonePhotos:_photos];
    }
}

- (void)delBtnAction:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    actionSheet.tag = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:deleteWithIndex:)]) {
            [_delegate photoBrowser:self deleteWithIndex:_currentPageIndex];
        }
    }
}

#pragma mark - uiscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    _currentPageIndex = floor((_photoScrollView.contentOffset.x - _photoScrollView.frame.size.width / ([_photos count]+2)) / _photoScrollView.frame.size.width) + 1;
}

- (void)dealloc {
    [_photos removeAllObjects];
    [_reusablePhotoViews removeAllObjects];
    [_visiblePhotoViews removeAllObjects];
}

@end
