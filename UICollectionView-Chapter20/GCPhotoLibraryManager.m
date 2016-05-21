//
//  GCPhotoLibraryManager.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "GCPhotoLibraryManager.h"

@implementation GCPhotoLibraryManager

+(instancetype)sharedManager{
    static id manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[GCPhotoLibraryManager alloc]init];
    });
    
    return manager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.assetsArray=[[NSMutableArray alloc]init];
        self.assetsGroupArray=[[NSMutableArray alloc]init];
        self.assetsGroupNameArray=[[NSMutableArray alloc]init];
        self.assetsLibrary=[[ALAssetsLibrary alloc]init];
        [self updateData];
    }
    return self;
}

-(void)updateData{
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          if (group) {
                                              NSString *name=[group valueForProperty:ALAssetsGroupPropertyName];
                                              NSInteger count=[group numberOfAssets];
                                              NSString *title=[NSString stringWithFormat:@"%@ - %ld",name,(long)count];
                                              [self.assetsGroupArray addObject:group];
                                              [self.assetsGroupNameArray addObject:title];
                                              [self enumerateGroupAssetsForGroup:group];
                                          }else{
                                              //NSLog(@"no group");
                                          }
                                          
                                      } failureBlock:^(NSError *error) {
                                          NSLog(@"%@",[error localizedDescription]);
                                      }];

}

- (void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group{
    NSInteger lastIndex=[group numberOfAssets] - 1;
    __block NSMutableArray *groupAssetsArray=[[NSMutableArray alloc]init];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [groupAssetsArray addObject:result];
        }
        
        if (index == lastIndex) {
            [self.assetsArray addObject:groupAssetsArray];
        }
    }];
}

@end
