//
//  GCPhotoLibraryManager.h
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GCPhotoLibraryManager : NSObject

/**
    Assets数组的数组
 */
@property (nonatomic, strong) NSMutableArray *assetsArray;

/**
 AssetsGroup数组
 */
@property (nonatomic, strong) NSMutableArray *assetsGroupArray;

/**
 AssetsGroup名称数组
 */
@property (nonatomic, strong) NSMutableArray *assetsGroupNameArray;

/**
 AssetsLibrary实例
 */
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

/**
 通用实例
 */
+(instancetype)sharedManager;

/**
 更新数据
 */
-(void)updateData;

@end
