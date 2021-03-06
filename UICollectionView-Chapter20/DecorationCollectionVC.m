//
//  DecorationCollectionVC.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/20.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "DecorationCollectionVC.h"
#import "DecorationFlowLayout.h"

@implementation DecorationCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    DecorationFlowLayout *layout=[[DecorationFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
}
/*
static NSString * const kCell = @"kCell";
static NSString * const kSupplementaryView = @"kSupplementaryView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    manager=[GCPhotoLibraryManager sharedManager];
    
    DecorationFlowLayout *layout=[[DecorationFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:layout];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCell];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSupplementaryView];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [manager.assetsGroupNameArray count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSArray *sectionAssets=nil;
    if (section < [manager.assetsArray count]) {
        sectionAssets=manager.assetsArray[section];
    }
    return [sectionAssets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    // Configure the cell
    ALAsset *assetForPath=manager.assetsArray[indexPath.section][indexPath.row];
    UIImage *assetThumb=[UIImage imageWithCGImage:[assetForPath thumbnail]];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView setImage:assetThumb];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSupplementaryView forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *sectionTitle=manager.assetsGroupNameArray[indexPath.section];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.text=sectionTitle;
        
        [resuableView addSubview:label];
        
    }else{
        
    }
    return resuableView;
}
*/
@end
