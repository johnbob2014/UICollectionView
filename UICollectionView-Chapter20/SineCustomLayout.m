//
//  SineCustomLayout.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "SineCustomLayout.h"

#define kCellSize   50.0 //assumes square cell
#define kHorizontalInset    10.0 //on the left and right
#define kVerticalSpace  10.0  //vertical space between cells
#define kSectionHeight  20.0
#define kCenterXPosition    160.0
#define kMaxAmplitude   125.0

@interface SineCustomLayout ()
@property (nonatomic, strong) NSMutableDictionary *centerPointsForCells;
@property (nonatomic, strong) NSMutableArray *rectsForSectionHeaders;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation SineCustomLayout

-(CGFloat)calculateSineXPositionForY:(CGFloat)yPosition{
    CGFloat currentTime = yPosition / self.collectionView.bounds.size.height;
    CGFloat xPosition= kMaxAmplitude*sinf(2*M_PI*currentTime) + kCenterXPosition;
    return xPosition;
}

-(void)prepareLayout{
    NSInteger sectionCount=[self.collectionView numberOfSections];
    
    CGFloat currentYPosition=0.0;
    self.centerPointsForCells=[[NSMutableDictionary alloc]init];
    self.rectsForSectionHeaders=[[NSMutableArray alloc]init];
    
    for (NSInteger sectionIndex=0; sectionIndex < sectionCount; sectionIndex++) {
        CGRect rectForNextSection=CGRectMake(0, currentYPosition, self.collectionView.bounds.size.width, kSectionHeight);
        self.rectsForSectionHeaders[sectionIndex]=[NSValue valueWithCGRect:rectForNextSection];
        currentYPosition+=kSectionHeight + kVerticalSpace + kCellSize /2;
        
        NSInteger itemCount=[self.collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < itemCount; itemIndex++) {
            CGFloat xPosition=[self calculateSineXPositionForY:currentYPosition];
            CGPoint itemCenterPoint=CGPointMake(xPosition, currentYPosition);
            NSIndexPath *itemIndexPath=[NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            self.centerPointsForCells[itemIndexPath]=[NSValue valueWithCGPoint:itemCenterPoint];
            currentYPosition+=kCellSize+kVerticalSpace;
        }
    }
    
    self.contentSize=CGSizeMake(self.collectionView.bounds.size.width, currentYPosition+kVerticalSpace);
}

-(CGSize)collectionViewContentSize{
    return self.contentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size=CGSizeMake(kCellSize, kCellSize);
    attributes.center=[(NSValue *)self.centerPointsForCells[indexPath] CGPointValue];
    
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    CGRect viewRect=[(NSValue *)self.rectsForSectionHeaders[indexPath.section] CGRectValue];
    attributes.size=CGSizeMake(viewRect.size.width, viewRect.size.height);
    attributes.center=CGPointMake(CGRectGetMidX(viewRect), CGRectGetMidY(viewRect));
    
    return attributes;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributesArray=[NSMutableArray array];
    
    [self.rectsForSectionHeaders enumerateObjectsUsingBlock:^(NSValue *sectionRectValue, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, sectionRectValue.CGRectValue)) {
            NSIndexPath *sectionIndexPath=[NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
            [attributesArray addObject:attributes];
        }
    }];
    
    [self.centerPointsForCells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *centerPointValue, BOOL * _Nonnull stop) {
        CGPoint center=centerPointValue.CGPointValue;
        CGRect cellRect=CGRectMake(center.x-kCellSize/2, center.y-kCellSize/2, kCellSize, kCellSize);
        
        if (CGRectIntersectsRect(rect, cellRect)) {
            UICollectionViewLayoutAttributes *attributes=[self layoutAttributesForItemAtIndexPath:indexPath];
            [attributesArray addObject:attributes];
        }
    }];
    
    return [NSArray arrayWithArray:attributesArray];
}
@end
