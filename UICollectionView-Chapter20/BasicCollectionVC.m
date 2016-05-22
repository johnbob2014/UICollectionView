//
//  BasicCollectionVC.m
//  UICollectionView-Chapter20
//
//  Created by 张保国 on 16/5/21.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "BasicCollectionVC.h"
#import "GCPhotoLibraryManager.h"

#import "AnimatingFlowLayout.h"
#import "SineCustomLayout.h"

@interface BasicCollectionVC ()
@property (nonatomic, strong) NSIndexPath *pinchedIndexPath;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchIn;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchOut;
@end

@implementation BasicCollectionVC{
    GCPhotoLibraryManager *manager;
}

static NSString * const kCell = @"kCell";
static NSString * const kSupplementaryView = @"kSupplementaryView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager=[GCPhotoLibraryManager sharedManager];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSupplementaryView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSupplementaryView];
    // Do any additional setup after loading the view.
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *randomItem=[[UIBarButtonItem alloc]initWithTitle:@"Random" style:UIBarButtonItemStyleDone target:self action:@selector(randomItemTouched:)];
    UIBarButtonItem *actionItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionItemTouched:)];
    [self.navigationItem setRightBarButtonItems:@[randomItem,actionItem]];
    
    self.pinchIn = [[UIPinchGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(pinchInReceived:)];
    
    self.pinchOut = [[UIPinchGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(pinchOutReceived:)];
    
    [self.collectionView addGestureRecognizer:self.pinchOut];
}

-(void)randomItemTouched:(id)sender{
    NSInteger randomSection=arc4random() % [self.collectionView numberOfSections];
    NSIndexPath *randomIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:randomIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

-(void)actionItemTouched:(id)sender{
    NSString *message = nil;
    
    if ([self.collectionView.indexPathsForSelectedItems count] == 0)
    {
        message = @"There are no selected items.";
    }
    else if ([self.collectionView.indexPathsForSelectedItems count] == 1)
    {
        message = @"There is 1 selected item.";
    }
    else if ([self.collectionView.indexPathsForSelectedItems count] > 1) {
        message = [NSString stringWithFormat:@"There are %d selected items.",[self.collectionView.indexPathsForSelectedItems count]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Items" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [manager.assetsGroupArray count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *sectionAssets = nil;
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
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView setImage:assetThumb];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSupplementaryView forIndexPath:indexPath];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *sectionTitle=manager.assetsGroupNameArray[indexPath.section];
        label.text=sectionTitle;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        label.text=[NSString stringWithFormat:@"Footer: %d",indexPath.section + 1];
    }
    
    [resuableView addSubview:label];
    
    return resuableView;
}

#pragma mark <UICollectionViewDelegate>


 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }



 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }


/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

#pragma mark - Gesture methods

- (void)pinchInReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan )
    {
        CGPoint pinchPoint =
        [pinchRecognizer locationInView:self.collectionView];
        
        self.pinchedIndexPath =
        [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.collectionView removeGestureRecognizer:self.pinchIn];
        SineCustomLayout *customLayout = [[SineCustomLayout alloc] init];
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchOut = self.pinchOut;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        void (^finishedBlock)(BOOL) = ^(BOOL finished) {
            
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath
                                       atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                               animated:YES];
            
            [weakCollectionView addGestureRecognizer:weakPinchOut];
        };
        
        [self.collectionView setCollectionViewLayout:customLayout
                                            animated:YES
                                          completion:finishedBlock];
    }
}

- (void)pinchOutReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pinchPoint =
        [pinchRecognizer locationInView:self.collectionView];
        
        self.pinchedIndexPath =
        [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchOut];
        
        UICollectionViewFlowLayout *individualLayout =
        [[AnimatingFlowLayout alloc] init];
        
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchIn = self.pinchIn;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        void (^finishedBlock)(BOOL) = ^(BOOL finished) {
            
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath
                                       atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                               animated:YES];
            
            [weakCollectionView addGestureRecognizer:weakPinchIn];
        };
        [self.collectionView setCollectionViewLayout:individualLayout
                                            animated:YES
                                          completion:finishedBlock];
    }
}

@end
