//
//  BoPhotoGroupView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "AJPhotoGroupView.h"
#import "AJPhotoGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AJPhotoPickerViewController.h"

@interface AJPhotoGroupView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation AJPhotoGroupView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[AJPhotoGroupCell class] forCellReuseIdentifier:@"cell"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}

- (void)setupGroup {
    [self.groups removeAllObjects];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:self.assetsFilter];
            if (group.numberOfAssets > 0 || ((AJPhotoPickerViewController *)_my_delegate).showEmptyGroups){
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos){
                    [self.groups insertObject:group atIndex:0];
                } else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupPhotoStream && self.groups.count > 0){
                    [self.groups insertObject:group atIndex:1];
                } else {
                    [self.groups addObject:group];
                }
            }
        } else {
            [self dataReload];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //没权限
        [self showNotAllowed];
    };
    
    //显示的相册
    NSUInteger type = ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream |
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces  ;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - Reload Data
- (void)dataReload {
    if (self.groups.count == 0)
        //没有图片
        [self showNoAssets];
    
    if (self.groups.count >0 && [_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:self.groups[0]];
    }
    [self reloadData];
}

#pragma mark - Not allowed / No assets
- (void)showNotAllowed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotAllowedPhoto" object:nil];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:nil];
    }
}

- (void)showNoAssets {
    NSLog(@"%s",__func__);
}


#pragma mark - uitableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    AJPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    if(cell == nil){
        cell = [[AJPhotoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    if (indexPath.row == self.selectIndex) {
        cell.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self reloadData];
    ALAssetsGroup *group = [self.groups objectAtIndex:indexPath.row];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:group];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

#pragma mark - ALAssetsLibrary
- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        static dispatch_once_t pred = 0;
        static ALAssetsLibrary *library = nil;
        dispatch_once(&pred, ^{
            library = [[ALAssetsLibrary alloc] init];
        });
        _assetsLibrary = library;
    }
    return _assetsLibrary;
}

@end
