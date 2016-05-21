//
//  DecorationFlowLayout.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "DecorationFlowLayout.h"
#import "DecorationCollectionReusableView.h"

#define kDecorationYAdjustment 13.0
#define kDecorationHeight 25.0

@interface DecorationFlowLayout ()
@property (nonatomic,strong) NSDictionary *rowDecorationRects;
@end

@implementation DecorationFlowLayout

-(instancetype)init{
    self=[super init];
    if (self) {
        self.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.itemSize=CGSizeMake(60, 60);
        self.sectionInset=UIEdgeInsetsMake(10, 26, 10, 26);
        self.headerReferenceSize=CGSizeMake(300, 50);
        self.minimumLineSpacing=20;
        self.minimumInteritemSpacing=40;
        
        //注册DecorationView
        [self registerClass:[DecorationCollectionReusableView class] forDecorationViewOfKind:[DecorationCollectionReusableView kind]];
    }
    return self;
}

//Tells the layout object to update the current layout.
-(void)prepareLayout{
    [super prepareLayout];
    
    //获取collectionView的section个数
    NSInteger sectionCount=[self.collectionView numberOfSections];
    //计算可视宽度
    CGFloat availableWidth=self.collectionViewContentSize.width-(self.sectionInset.left+self.sectionInset.right);
    //计算每行的单元格数,取小于结果的最大整数
    //floorf(float x),round to largest integral value not greater than x
    NSInteger cellsPerRow=floorf((availableWidth+self.minimumInteritemSpacing)/(self.itemSize.width+self.minimumInteritemSpacing));
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    //初始化y位置并开始循环迭代
    CGFloat yPosition=0;
    for(NSInteger sectionIndex=0;sectionIndex < sectionCount;sectionIndex++){
        //开始一个section中的循环
        //加上section header的高度和section的top偏移量
        yPosition+=self.headerReferenceSize.height;
        yPosition+=self.sectionInset.top;
        //获取当前section中的单元格数
        NSInteger cellCount=[self.collectionView numberOfItemsInSection:sectionIndex];
        //计算行数=当前section中的单元格数/每行的单元格数,取大于结果的最小整数
        //ceilf(float x),round to smallest integral value not less than x
        NSInteger rows=ceilf(cellCount/(CGFloat)cellsPerRow);
        for (int row=0; row < rows; row++) {
            //开始一行的循环
            //加上单元格的高度
            yPosition += self.itemSize.height;
            //计算decoration的frame
            CGRect decorationFrame=CGRectMake(0, yPosition-kDecorationYAdjustment, self.collectionViewContentSize.width, kDecorationHeight);
            //获取indexPath
            NSIndexPath *decorationIndexPath=[NSIndexPath indexPathForItem:row inSection:sectionIndex];
            //将{key:indexPath,value:frame}存入字典
            dic[decorationIndexPath]=[NSValue valueWithCGRect:decorationFrame];
            //如果不是最后一行，加上行距
            if (row < rows -1) {
                yPosition+=self.minimumLineSpacing;
            }
        }
        //加上section的bottom偏移量和section footer的高度
        yPosition+=self.sectionInset.bottom;
        yPosition+=self.footerReferenceSize.height;
    }
    self.rowDecorationRects=[NSDictionary dictionaryWithDictionary:dic];
}

//Returns the layout attributes for all of the cells and views in the specified rectangle.
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray <UICollectionViewLayoutAttributes *> *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    //将原有视图的zIndex设置为1,在上层
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.zIndex=1;
    }];
    
    NSMutableArray *newLayoutAttributes=[layoutAttributes mutableCopy];
    [self.rowDecorationRects enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *decorationFrameValue, BOOL * _Nonnull stop) {
        //获取指定indexPath处的属性
        //Creates and returns a layout attributes object that represents the specified decoration view.
        UICollectionViewLayoutAttributes *attributes=[UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[DecorationCollectionReusableView kind] withIndexPath:indexPath];
        attributes.frame=[decorationFrameValue CGRectValue];
        //将decoration的zIndex设置为0，在下层
        attributes.zIndex=0;
        //添加新属性
        [newLayoutAttributes addObject:attributes];
    }];
    
    layoutAttributes=[NSArray arrayWithArray:newLayoutAttributes];
    return layoutAttributes;
}
@end
