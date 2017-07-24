//
//  CollectionViewController.m
//  RRSwipeCell
//
//  Created by Moch Xiao on 7/23/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
@import RRSwipeCell;

@interface CollectionViewController () <RRSwipeActionDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)dealloc {
    NSLog(@"~~~~~~~~~~~%s~~~~~~~~~~~", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RRSwipeCell";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = UIColor.blackColor;
    self.collectionView.rr_swipeActionDelegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    
    // Do any additional setup after loading the view.
 
    NSString *str = @"The team continues buckling down on its Super Glue Gun project. Felix brings together a custom-designed motor control circuit that will be used for extruding the glue. Meanwhile, Ben cuts up the perfb...";
    _data = [@[str, str, str, str, str, str, str, str, str, str, str, str, str] mutableCopy];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLael.text = [NSString stringWithFormat:@"%@: %@", @(indexPath.item), self.data[indexPath.item]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - RRSwipeActionDelegate

- (nullable NSArray<RRSwipeAction *> *)rr_collectionView:(UICollectionView *)collectionView swipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.item) {
        return nil;
    }
    __weak typeof(self) weak_self = self;
    RRSwipeAction *remove = [[RRSwipeAction alloc] initWithTitle:@"Remove" titleColor:UIColor.whiteColor backgroundColor:UIColor.redColor handler:^{
        __strong typeof(weak_self) strong_self = weak_self;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure rmove this?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *yep = [UIAlertAction actionWithTitle:@"Yep" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"delete: %@-%@",@(indexPath.section), @(indexPath.item));
            [strong_self.data removeObjectAtIndex:indexPath.item];
            [strong_self.collectionView performBatchUpdates:^{
                [strong_self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished) {
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:yep];
        [actionSheet addAction:cancel];
        [strong_self presentViewController:actionSheet animated:YES completion:nil];
        NSLog(@"remove");
    }];
    RRSwipeAction *mark = [[RRSwipeAction alloc] initWithTitle:@"Mark" titleColor:UIColor.whiteColor backgroundColor:UIColor.lightGrayColor handler:^{
        NSLog(@"mark");
        [weak_self.collectionView rr_hideSwipeActions];
    }];
    if (indexPath.item % 2) {
        return @[remove, mark];
    }
    return @[remove];
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath: %@-%@",@(indexPath.section), @(indexPath.item));
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
