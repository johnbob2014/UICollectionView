//
//  DecorationCollectionReusableView.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/20.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "DecorationCollectionReusableView.h"

const NSString *kDecorationReusabelViewKind=@"kDecorationReusabelViewKind";

@implementation DecorationCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

+(NSString *)kind{
    return (NSString *)kDecorationReusabelViewKind;
}

-(void)drawRect:(CGRect)rect{
    CGRect frame=CGRectMake(0, 0, 320, 25);
    CGFloat xMinX=CGRectGetMinX(frame);
    CGFloat yMinY=CGRectGetMinY(frame);
    
    //梯形曲线（上窄下宽）
    UIBezierPath *bezierPath=[UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(xMinX+3.5,yMinY+16.5)];
    [bezierPath addLineToPoint:CGPointMake(xMinX+13.8, yMinY+8.5)];
    [bezierPath addLineToPoint:CGPointMake(xMinX+303.73, yMinY+8.5)];
    [bezierPath addLineToPoint:CGPointMake(xMinX+315.5, yMinY+16.5)];
    [bezierPath addLineToPoint:CGPointMake(xMinX+3.5, yMinY+16.5)];
    [bezierPath closePath];
    
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* fillColor = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    UIColor* shadowColor=strokeColor;
    CGSize shadowOffset=CGSizeMake(0.1, 3.1);
    CGFloat shadowBlurRadius=5;
    
    //设置阴影，填充曲线
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
    [fillColor setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    //描边曲线
    bezierPath.lineWidth=1;
    [fillColor setStroke];
    [bezierPath stroke];
}
@end
