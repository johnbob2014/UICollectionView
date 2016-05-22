//
//  LineCollectionVC.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/22.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "LineCollectionVC.h"
#import "LineFlowLayout.h"

@implementation LineCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    LineFlowLayout *layout=[[LineFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    
}
@end
