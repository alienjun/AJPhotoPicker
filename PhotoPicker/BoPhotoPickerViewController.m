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
@property (weak, nonatomic) BoPhotoListView *photoListView ;
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
    
    [self setup];
    
    [self setupGroupView];
}


-(void)setup{

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
    navBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navBar];
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@64);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
    self.navBar = navBar;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:mRGBToColor(0x9c9c9c) forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.leading.mas_equalTo(navBar);
        make.top.mas_equalTo(navBar).offset(20);
        make.width.mas_equalTo(@60);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGroupView:)]];
    [navBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@200);
        make.centerX.mas_equalTo(navBar);
        make.centerY.mas_equalTo(navBar).offset(10);
    }];
    self.titleLabel = titleLabel;
}

//相册分组
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

-(void)showGroupView:(UITapGestureRecognizer *)sender{
    
    if (self.photoGroupView.hidden) {
        [self bgMaskView];
        self.photoGroupView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, 360);
        }];
    }else{
        [self hidenGroupView];
    }
    
}

-(void)hidenGroupView{
    [self.bgMaskView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, -360);
    }completion:^(BOOL finished) {
        self.photoGroupView.hidden = YES;
    }];
}


#pragma mark - BoPhotoGroupViewProtocol
-(void)didSelectGroup:(ALAssetsGroup *)assetsGroup{
    NSLog(@"%@",assetsGroup);
    self.photoListView.assetsGroup = assetsGroup;
    self.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self hidenGroupView];
    
}

-(void)cancelBtnAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)bgMaskView{
    if (_bgMaskView == nil) {
        UIView *bgMaskView = [[UIView alloc] init];
        bgMaskView.alpha = 0.4;
        bgMaskView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:bgMaskView belowSubview:self.photoGroupView];
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

@end
