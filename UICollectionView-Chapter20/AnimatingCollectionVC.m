//
//  AnimatingCollectionVC.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "AnimatingCollectionVC.h"
#import "AnimatingFlowLayout.h"

@implementation AnimatingCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    AnimatingFlowLayout *layout=[[AnimatingFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
}

@end
