//
//  AnimatingFlowLayout.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "AnimatingFlowLayout.h"

#define kZoomDistance 150
#define kZoomAmount 0.8

@implementation AnimatingFlowLayout

-(instancetype)init{
    self=[super init];
    if (self) {
        self.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.itemSize=CGSizeMake(60, 60);
        self.sectionInset=UIEdgeInsetsMake(10, 26, 10, 26);
        self.headerReferenceSize=CGSizeMake(300, 50);
        self.minimumLineSpacing=40;
        self.minimumInteritemSpacing=20;
    }
    return self;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attributesArray=[super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin=self.collectionView.contentOffset;
    visibleRect.size=self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        if (attributes.representedElementCategory==UICollectionElementCategoryCell && CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distanceFromCenter=CGRectGetMidY(visibleRect)-attributes.center.y;
            CGFloat distancePercentFromCenter=distanceFromCenter / kZoomDistance;
            
            if (ABS(distanceFromCenter) < kZoomDistance) {
                CGFloat zoom=1 + kZoomAmount * (1 - ABS(distancePercentFromCenter));
                attributes.transform3D=CATransform3DMakeScale(zoom, zoom, 1.0);
            }else{
                attributes.transform3D=CATransform3DIdentity;
            }
        }
    }
    
    return attributesArray;
}

@end
