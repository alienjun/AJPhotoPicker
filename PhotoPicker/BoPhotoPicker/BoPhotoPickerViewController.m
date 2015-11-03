//
//  BoPhotoPickerViewController.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoPhotoPickerViewController.h"
#import "BoPhotoGroupView.h"
#import "BoPhotoListView.h"
#import "Masonry.h"
#import "MacroDefine.h"

@interface BoPhotoPickerViewController()<BoPhotoGroupViewProtocol,BoPhotoListProtocol>

@property (nonatomic,weak) BoPhotoGroupView *photoGroupView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *navBar;
@property (weak, nonatomic) UIView *bgMaskView;
@property (weak, nonatomic) BoPhotoListView *photoListView;
@property (weak, nonatomic) UIImageView *selectTip;
@property (nonatomic) BOOL isNotAllowed;
@end

@implementation BoPhotoPickerViewController

#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

#pragma mark - lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //没有相册访问权限通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNotAllowed)
                                                 name:@"NotAllowedPhoto"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setup];
    
    [self setupGroupView];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}


#pragma mark - 界面初始化
-(void)setup{

    if (!self.multipleSelection) {
        self.minimumNumberOfSelection = 1;
        self.maximumNumberOfSelection = 1;
    }else{
        if (self.maximumNumberOfSelection == 0) {
            self.maximumNumberOfSelection = 20;
            self.minimumNumberOfSelection = 1;
        }
    }
    
    BoPhotoListView *collectionView = [[BoPhotoListView alloc] init];
    collectionView.my_delegate = self;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64);
        make.bottom.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
    }];
    self.photoListView = collectionView;
    
    //界面组件
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = mRGBToColor(0xec4243);
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
    [okBtn setTitle:@"发布" forState:UIControlStateNormal];
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
    
}


#pragma mark - 相册view
-(void)setupGroupView{
    BoPhotoGroupView *photoGroupView = [[BoPhotoGroupView alloc] init];
    photoGroupView.assetsFilter = self.assetsFilter;
    photoGroupView.showEmptyGroups = self.showEmptyGroups;
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
    
    [photoGroupView setupGroup];
}

-(void)selectGroupAction:(UIButton *)sender{
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
    }else{
        [self hidenGroupView];
    }
}

-(void)hidenGroupView{
    [self.bgMaskView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.photoGroupView.transform = CGAffineTransformIdentity;
        self.selectTip.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.photoGroupView.hidden = YES;
    }];
}


#pragma mark - BoPhotoGroupViewProtocol
-(void)didSelectGroup:(ALAssetsGroup *)assetsGroup{
    self.photoListView.assetsGroup = assetsGroup;
    self.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self hidenGroupView];
    
}

#pragma mark - BoPhotoListProtocol
-(void)tapAction:(ALAsset *)asset{
    if ([asset isKindOfClass:[UIImage class]] && _delegate && [_delegate respondsToSelector:@selector(photoPickerTapAction:)]) {
        [_delegate photoPickerTapAction:self];
    }
}


#pragma mark - Action
-(void)cancelBtnAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(photoPickerDidCancel:)]) {
        [_delegate photoPickerDidCancel:self];
    }
}

-(void)okBtnAction:(UIButton *)sender{
    if (self.minimumNumberOfSelection > self.indexPathsForSelectedItems.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(photoPickerDidMinimum:)]) {
            [_delegate photoPickerDidMinimum:self];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAssets:)]) {
            [_delegate photoPicker:self didSelectAssets:self.indexPathsForSelectedItems];
        }
    }
}


#pragma mark - 遮罩背景
-(UIView *)bgMaskView{
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

-(void)tapBgMaskView:(UITapGestureRecognizer *)sender{
    if (!self.photoGroupView.hidden) {
        [self hidenGroupView];
    }
}

#pragma mark - 没有访问权限提示
-(void)showNotAllowed{
    //没有权限时隐藏部分控件
    self.isNotAllowed = YES;
    self.selectTip.hidden = YES;
    self.titleLabel.text = @"无权限访问相册";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请先允许访问相册"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"前往", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - getter/setter
-(NSMutableArray *)indexPathsForSelectedItems{
    if (!_indexPathsForSelectedItems) {
        _indexPathsForSelectedItems = [[NSMutableArray alloc] init];
    }
    return _indexPathsForSelectedItems;
}
@end
