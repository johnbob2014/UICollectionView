//
//  CircleCollectionVC.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/22.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CircleCollectionVC.h"
#import "CircleCutstomLayout.h"

static NSString *kCell = @"KCell";

@implementation CircleCollectionVC

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 16;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.text=[NSString stringWithFormat:@"%d",indexPath.item];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:label];
    
    return cell;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCell];
    
    CircleCutstomLayout *layout=[[CircleCutstomLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRAction:)];
    [self.collectionView addGestureRecognizer:tapGR];
    
    
}

/*
 performBatchUpdates:completion:可以用来对collectionView中的元素进行批量的插入，删除，移动等操作，同时将触发collectionView所对应的layout的对应的动画。
 相应的动画由layout中的下列6个方法来定义：
 initialLayoutAttributesForAppearingItemAtIndexPath:
 initialLayoutAttributesForAppearingDecorationElementOfKind:atIndexPath:
 
 finalLayoutAttributesForDisappearingItemAtIndexPath:
 finalLayoutAttributesForDisappearingDecorationElementOfKind:atIndexPath:
 
 */

-(void)tapGRAction:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint=[sender locationInView:self.collectionView];
        NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:tapPoint];
        if (indexPath) {
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
                NSLog(@"Delete");
            }];
        }else{
            NSIndexPath *newItemIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:@[newItemIndexPath]];
            } completion:^(BOOL finished) {
                NSLog(@"Insert");
            }];
        }
    }
}



@end
