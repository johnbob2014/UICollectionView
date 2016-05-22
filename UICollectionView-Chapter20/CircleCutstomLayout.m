//
//  CircleCutstomLayout.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/22.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CircleCutstomLayout.h"

#define kItemSize 50.0

@implementation CircleCutstomLayout{
    NSInteger cellCount;
    CGPoint center;
    CGFloat radius;
}

-(CGSize)collectionViewContentSize{
    return self.collectionView.bounds.size;
}

-(void)prepareLayout{
    [super prepareLayout];
    cellCount=[self.collectionView numberOfItemsInSection:0];
    CGSize size=self.collectionView.bounds.size;
    center=CGPointMake(size.width/2.0, size.height/2.0);
    radius=MIN(size.width, size.height)/2.5;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //生成空白的attributes对象，其中只记录了类型是cell以及对应的位置是indexPath
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //配置attributes到圆周上
    attributes.size=CGSizeMake(kItemSize, kItemSize);
    CGFloat radians=indexPath.item / cellCount * 2 * M_PI;
    attributes.center=CGPointMake(center.x + radius * cosf(radians), center.y + radius * sinf(radians));
    
    return attributes;
}

//用来在一开始给出一套UICollectionViewLayoutAttributes
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributesMA=[NSMutableArray array];
    
    for (NSInteger i=0 ; i < cellCount; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesMA addObject:attributes];
    }
    
    return [NSArray arrayWithArray:attributesMA];
}

//插入前，cell在圆心位置，全透明
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha=0.0;
    attributes.center=CGPointMake(center.x, center.y);
    return attributes;
}

//删除时，cell在圆心位置，全透明，且只有原来的1/10大
-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha=0.0;
    attributes.center=CGPointMake(center.x, center.y);
    attributes.transform3D=CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end
