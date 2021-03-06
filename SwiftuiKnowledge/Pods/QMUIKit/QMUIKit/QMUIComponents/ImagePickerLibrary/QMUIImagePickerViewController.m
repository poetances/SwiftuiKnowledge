/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  QMUIImagePickerViewController.m
//  qmui
//
//  Created by QMUI Team on 15/5/2.
//

#import "QMUIImagePickerViewController.h"
#import "QMUICore.h"
#import "QMUIImagePickerCollectionViewCell.h"
#import "QMUIButton.h"
#import "QMUINavigationButton.h"
#import "QMUIAssetsManager.h"
#import "QMUIAlertController.h"
#import "QMUIImagePickerHelper.h"
#import "QMUIImagePickerHelper.h"
#import "UICollectionView+QMUI.h"
#import "UIScrollView+QMUI.h"
#import "CALayer+QMUI.h"
#import "UIView+QMUI.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "QMUIEmptyView.h"
#import "UIViewController+QMUI.h"
#import "QMUILog.h"
#import "QMUIAppearance.h"

static NSString * const kVideoCellIdentifier = @"video";
static NSString * const kImageOrUnknownCellIdentifier = @"imageorunknown";


#pragma mark - QMUIImagePickerViewController (UIAppearance)

@implementation QMUIImagePickerViewController (UIAppearance)

+ (instancetype)appearance {
    return [QMUIAppearance appearanceForClass:self];
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initAppearance];
    });
}

+ (void)initAppearance {
    QMUIImagePickerViewController.appearance.minimumImageWidth = 75;
}

@end

#pragma mark - QMUIImagePickerViewController

@interface QMUIImagePickerViewController ()

@property(nonatomic, strong) QMUIImagePickerPreviewViewController *imagePickerPreviewViewController;
@property(nonatomic, assign) BOOL isImagesAssetLoaded;// ??????????????????????????????https://github.com/Tencent/QMUI_iOS/issues/219
@property(nonatomic, assign) BOOL hasScrollToInitialPosition;
@property(nonatomic, assign) BOOL canScrollToInitialPosition;// ????????????????????????????????????
@end

@implementation QMUIImagePickerViewController

- (void)didInitialize {
    [super didInitialize];
    
    [self qmui_applyAppearance];
    
    _allowsMultipleSelection = YES;
    _maximumSelectImageCount = INT_MAX;
    _minimumSelectImageCount = 0;
    _shouldShowDefaultLoadingView = YES;
}

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    [self.view addSubview:self.collectionView];
    if (self.allowsMultipleSelection) {
        [self.view addSubview:self.operationToolBarView];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"??????" target:self action:@selector(handleCancelPickerImage:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ???????????????????????? selectedImageAssetArray ??? property?????????????????????????????????
    // ?????? viewWillAppear ??????????????????????????????????????????????????? collectionView
    if (self.allowsMultipleSelection) {
        // ?????????????????????????????????????????????????????????????????????????????????????????????
        NSInteger selectedImageCount = [self.selectedImageAssetArray count];
        if (selectedImageCount > 0) {
            // ????????????????????????????????????????????????????????????????????????????????????????????????????????????
            self.previewButton.enabled = YES;
            self.sendButton.enabled = YES;
            self.imageCountLabel.text = [NSString stringWithFormat:@"%@", @(selectedImageCount)];
            self.imageCountLabel.hidden = NO;
        } else {
            // ???????????????????????????????????????????????????????????????????????????????????????????????????????????? Label
            self.previewButton.enabled = NO;
            self.sendButton.enabled = NO;
            self.imageCountLabel.hidden = YES;
        }
    }
    [self.collectionView reloadData];
}

- (void)showEmptyView {
    [super showEmptyView];
    self.emptyView.backgroundColor = self.view.backgroundColor; // ????????????????????? collectionView??????????????????????????????????????????????????? collectionView ????????????????????????????????????????????????
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat operationToolBarViewHeight = 0;
    if (self.allowsMultipleSelection) {
        operationToolBarViewHeight = ToolBarHeight;
        CGFloat toolbarPaddingHorizontal = 12;
        self.operationToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - operationToolBarViewHeight, CGRectGetWidth(self.view.bounds), operationToolBarViewHeight);
        self.previewButton.frame = CGRectSetXY(self.previewButton.frame, toolbarPaddingHorizontal, CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.bounds) - SafeAreaInsetsConstantForDeviceWithNotch.bottom, CGRectGetHeight(self.previewButton.frame)));
        self.sendButton.frame = CGRectMake(CGRectGetWidth(self.operationToolBarView.bounds) - toolbarPaddingHorizontal - CGRectGetWidth(self.sendButton.frame), CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.frame) - SafeAreaInsetsConstantForDeviceWithNotch.bottom, CGRectGetHeight(self.sendButton.frame)), CGRectGetWidth(self.sendButton.frame), CGRectGetHeight(self.sendButton.frame));
        CGSize imageCountLabelSize = CGSizeMake(18, 18);
        self.imageCountLabel.frame = CGRectMake(CGRectGetMinX(self.sendButton.frame) - imageCountLabelSize.width - 5, CGRectGetMinY(self.sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.sendButton.frame), imageCountLabelSize.height), imageCountLabelSize.width, imageCountLabelSize.height);
        self.imageCountLabel.layer.cornerRadius = CGRectGetHeight(self.imageCountLabel.bounds) / 2;
        operationToolBarViewHeight = CGRectGetHeight(self.operationToolBarView.frame);
    }
    
    if (!CGSizeEqualToSize(self.collectionView.frame.size, self.view.bounds.size)) {
        self.collectionView.frame = self.view.bounds;
    }
    UIEdgeInsets contentInset = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator, self.collectionView.safeAreaInsets.left, MAX(operationToolBarViewHeight, self.collectionView.safeAreaInsets.bottom), self.collectionView.safeAreaInsets.right);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.collectionView.contentInset, contentInset)) {
        self.collectionView.contentInset = contentInset;
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(contentInset.top, 0, contentInset.bottom, 0);
        // ?????????????????????????????????????????? refreshWithAssetsGroup ?????? completion ?????????????????????????????????????????? scollToInitialPosition ????????????????????????????????????????????????????????????
        [self scrollToInitialPositionIfNeeded];
    }
}

- (void)refreshWithAssetsGroup:(QMUIAssetsGroup *)assetsGroup {
    _assetsGroup = assetsGroup;
    if (!self.imagesAssetArray) {
        _imagesAssetArray = [[NSMutableArray alloc] init];
        _selectedImageAssetArray = [[NSMutableArray alloc] init];
    } else {
        [self.imagesAssetArray removeAllObjects];
        // ???????????? remove ?????????????????????????????????????????????
//        [self.selectedImageAssetArray removeAllObjects];
    }
    // ?????? QMUIAssetsGroup ?????????????????????????????? QMUIAsset???????????????????????????
    QMUIAlbumSortType albumSortType = QMUIAlbumSortTypePositive;
    // ??? delegate ??????????????????????????????????????????????????????????????? delegate???????????? QMUIAlbumSortType ????????????????????????????????????????????????
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(albumSortTypeForImagePickerViewController:)]) {
        albumSortType = [self.imagePickerViewControllerDelegate albumSortTypeForImagePickerViewController:self];
    }
    // ?????????????????????????????????????????????????????????????????????????????????????????? Loading
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerWillStartLoading:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewControllerWillStartLoading:self];
    }
    if (self.shouldShowDefaultLoadingView) {
        [self showEmptyViewWithLoading];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [assetsGroup enumerateAssetsWithOptions:albumSortType usingBlock:^(QMUIAsset *resultAsset) {
            // ??????????????? UI ??????????????????????????????????????????
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultAsset) {
                    self.isImagesAssetLoaded = NO;
                    [self.imagesAssetArray addObject:resultAsset];
                } else {
                    // result ??? nil?????????????????????????????????
                    self.isImagesAssetLoaded = YES;// ?????????????????????????????? https://github.com/Tencent/QMUI_iOS/issues/219
                    [self.collectionView reloadData];
                    [self.collectionView performBatchUpdates:^{
                    } completion:^(BOOL finished) {
                        [self scrollToInitialPositionIfNeeded];
                        if (self.shouldShowDefaultLoadingView) {
                          [self hideEmptyView];
                        }
                        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerDidFinishLoading:)]) {
                            [self.imagePickerViewControllerDelegate imagePickerViewControllerDidFinishLoading:self];
                        }
                    }];
                }
            });
        }];
    });
}

- (void)initPreviewViewControllerIfNeeded {
    if (!self.imagePickerPreviewViewController) {
        self.imagePickerPreviewViewController = [self.imagePickerViewControllerDelegate imagePickerPreviewViewControllerForImagePickerViewController:self];
        self.imagePickerPreviewViewController.maximumSelectImageCount = self.maximumSelectImageCount;
        self.imagePickerPreviewViewController.minimumSelectImageCount = self.minimumSelectImageCount;
    }
}

- (CGSize)referenceImageSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat collectionViewContentSpacing = collectionViewWidth - UIEdgeInsetsGetHorizontalValue(self.collectionView.contentInset) - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset);
    NSInteger columnCount = floor(collectionViewContentSpacing / self.minimumImageWidth);
    CGFloat referenceImageWidth = self.minimumImageWidth;
    BOOL isSpacingEnoughWhenDisplayInMinImageSize = (self.minimumImageWidth + self.collectionViewLayout.minimumInteritemSpacing) * columnCount - self.collectionViewLayout.minimumInteritemSpacing <= collectionViewContentSpacing;
    if (!isSpacingEnoughWhenDisplayInMinImageSize) {
        // ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
        columnCount -= 1;
    }
    referenceImageWidth = floor((collectionViewContentSpacing - self.collectionViewLayout.minimumInteritemSpacing * (columnCount - 1)) / columnCount);
    return CGSizeMake(referenceImageWidth, referenceImageWidth);
}

- (void)setMinimumImageWidth:(CGFloat)minimumImageWidth {
    _minimumImageWidth = minimumImageWidth;
    [self referenceImageSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)scrollToInitialPositionIfNeeded {
    if (_collectionView.qmui_visible && self.isImagesAssetLoaded && !self.hasScrollToInitialPosition) {
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(albumSortTypeForImagePickerViewController:)] && [self.imagePickerViewControllerDelegate albumSortTypeForImagePickerViewController:self] == QMUIAlbumSortTypeReverse) {
            [_collectionView qmui_scrollToTop];
        } else {
            [_collectionView qmui_scrollToBottom];
        }
        self.hasScrollToInitialPosition = YES;
    }
}

- (void)willPopInNavigationControllerWithAnimated:(BOOL)animated {
    self.hasScrollToInitialPosition = NO;
}

#pragma mark - Getters & Setters

@synthesize collectionViewLayout = _collectionViewLayout;
- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat inset = PixelOne * 2; // no why, just beautiful
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
        _collectionViewLayout.minimumLineSpacing = _collectionViewLayout.sectionInset.bottom;
        _collectionViewLayout.minimumInteritemSpacing = _collectionViewLayout.sectionInset.left;
    }
    return _collectionViewLayout;
}

@synthesize collectionView = _collectionView;
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.isViewLoaded ? self.view.bounds : CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.backgroundColor = UIColorClear;
        [_collectionView registerClass:[QMUIImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kVideoCellIdentifier];
        [_collectionView registerClass:[QMUIImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kImageOrUnknownCellIdentifier];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

@synthesize operationToolBarView = _operationToolBarView;
- (UIView *)operationToolBarView {
    if (!_operationToolBarView) {
        _operationToolBarView = [[UIView alloc] init];
        _operationToolBarView.backgroundColor = UIColorWhite;
        _operationToolBarView.qmui_borderPosition = QMUIViewBorderPositionTop;
        
        [_operationToolBarView addSubview:self.sendButton];
        [_operationToolBarView addSubview:self.previewButton];
        [_operationToolBarView addSubview:self.imageCountLabel];
    }
    return _operationToolBarView;
}

@synthesize sendButton = _sendButton;
- (QMUIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[QMUIButton alloc] init];
        _sendButton.enabled = NO;
        _sendButton.titleLabel.font = UIFontMake(16);
        _sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendButton setTitleColor:UIColorMake(124, 124, 124) forState:UIControlStateNormal];
        [_sendButton setTitleColor:UIColorGray forState:UIControlStateDisabled];
        [_sendButton setTitle:@"??????" forState:UIControlStateNormal];
        _sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -20, -12, -20);
        [_sendButton sizeToFit];
        [_sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@synthesize previewButton = _previewButton;
- (QMUIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [[QMUIButton alloc] init];
        _previewButton.enabled = NO;
        _previewButton.titleLabel.font = self.sendButton.titleLabel.font;
        [_previewButton setTitleColor:[self.sendButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[self.sendButton titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
        [_previewButton setTitle:@"??????" forState:UIControlStateNormal];
        _previewButton.qmui_outsideEdge = UIEdgeInsetsMake(-12, -20, -12, -20);
        [_previewButton sizeToFit];
        [_previewButton addTarget:self action:@selector(handlePreviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewButton;
}

@synthesize imageCountLabel = _imageCountLabel;
- (UILabel *)imageCountLabel {
    if (!_imageCountLabel) {
        _imageCountLabel = [[UILabel alloc] init];
        _imageCountLabel.userInteractionEnabled = NO;// ???????????? sendButton ?????????
        _imageCountLabel.backgroundColor = ButtonTintColor;
        _imageCountLabel.textColor = UIColorWhite;
        _imageCountLabel.font = UIFontMake(12);
        _imageCountLabel.textAlignment = NSTextAlignmentCenter;
        _imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _imageCountLabel.layer.masksToBounds = YES;
        _imageCountLabel.hidden = YES;
    }
    return _imageCountLabel;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    if (self.isViewLoaded) {
        if (_allowsMultipleSelection) {
            [self.view addSubview:self.operationToolBarView];
        } else {
            [_operationToolBarView removeFromSuperview];
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagesAssetArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self referenceImageSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    
    NSString *identifier = nil;
    if (imageAsset.assetType == QMUIAssetTypeVideo) {
        identifier = kVideoCellIdentifier;
    } else {
        identifier = kImageOrUnknownCellIdentifier;
    }
    QMUIImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell renderWithAsset:imageAsset referenceSize:[self referenceImageSize]];
    
    [cell.checkboxButton addTarget:self action:@selector(handleCheckBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectable = self.allowsMultipleSelection;
    if (cell.selectable) {
        // ?????????????????? QMUIAsset ?????????????????????????????????????????????????????????????????????
        cell.checked = [self.selectedImageAssetArray containsObject:imageAsset];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QMUIAsset *imageAsset = self.imagesAssetArray[indexPath.item];
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didSelectImageWithImagesAsset:afterImagePickerPreviewViewControllerUpdate:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didSelectImageWithImagesAsset:imageAsset afterImagePickerPreviewViewControllerUpdate:self.imagePickerPreviewViewController];
    }
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerPreviewViewControllerForImagePickerViewController:)]) {
        [self initPreviewViewControllerIfNeeded];
        if (!self.allowsMultipleSelection) {
            // ??????????????????
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:@[imageAsset].mutableCopy
                                                                        selectedImageAssetArray:nil
                                                                              currentImageIndex:0
                                                                                singleCheckMode:YES];
        } else {
            // cell ??????????????????????????????????????????
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:self.imagesAssetArray
                                                                        selectedImageAssetArray:self.selectedImageAssetArray
                                                                              currentImageIndex:indexPath.item
                                                                                singleCheckMode:NO];
        }
        [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
    }
}

#pragma mark - ??????????????????

- (void)handleSendButtonClick:(id)sender {
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingImageWithImagesAssetArray:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didFinishPickingImageWithImagesAssetArray:self.selectedImageAssetArray];
    }
    [self.selectedImageAssetArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handlePreviewButtonClick:(id)sender {
    [self initPreviewViewControllerIfNeeded];
    // ??????????????????????????????
    [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:[self.selectedImageAssetArray copy]
                                                                selectedImageAssetArray:self.selectedImageAssetArray
                                                                      currentImageIndex:0
                                                                        singleCheckMode:NO];
    [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
}

- (void)handleCancelPickerImage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^() {
        if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerDidCancel:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewControllerDidCancel:self];
        }
        [self.selectedImageAssetArray removeAllObjects];
    }];
}

- (void)handleCheckBoxButtonClick:(UIButton *)checkboxButton {
    NSIndexPath *indexPath = [_collectionView qmui_indexPathForItemAtView:checkboxButton];
    
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:shouldCheckImageAtIndex:)] && ![self.imagePickerViewControllerDelegate imagePickerViewController:self shouldCheckImageAtIndex:indexPath.item]) {
        return;
    }
    
    QMUIImagePickerCollectionViewCell *cell = (QMUIImagePickerCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (cell.checked) {
        // ??????????????????
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:willUncheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self willUncheckImageAtIndex:indexPath.item];
        }
        
        cell.checked = NO;
        [self.selectedImageAssetArray removeObject:imageAsset];
        
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didUncheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self didUncheckImageAtIndex:indexPath.item];
        }
        
        // ??????????????????????????????????????????????????? enable????????????????????????????????????
        [self updateImageCountAndCheckLimited];
    } else {
        // ???????????????
        if ([self.selectedImageAssetArray count] >= _maximumSelectImageCount) {
            if (!_alertTitleWhenExceedMaxSelectImageCount) {
                _alertTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"?????????????????????%@?????????", @(_maximumSelectImageCount)];
            }
            if (!_alertButtonTitleWhenExceedMaxSelectImageCount) {
                _alertButtonTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"????????????"];
            }
            
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:_alertTitleWhenExceedMaxSelectImageCount message:nil preferredStyle:QMUIAlertControllerStyleAlert];
            [alertController addAction:[QMUIAlertAction actionWithTitle:_alertButtonTitleWhenExceedMaxSelectImageCount style:QMUIAlertActionStyleCancel handler:nil]];
            [alertController showWithAnimated:YES];
            return;
        }
        
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:willCheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self willCheckImageAtIndex:indexPath.item];
        }
        
        cell.checked = YES;
        [self.selectedImageAssetArray addObject:imageAsset];
        
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didCheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self didCheckImageAtIndex:indexPath.item];
        }
        
        // ??????????????????????????????????????????????????? enable????????????????????????????????????
        [self updateImageCountAndCheckLimited];
        
        // ?????????????????????????????????????????? iCloud?????????????????????????????????????????????????????????????????? id????????????????????????
        [self requestImageWithIndexPath:indexPath];
    }
}

- (void)updateImageCountAndCheckLimited {
    NSInteger selectedImageCount = [self.selectedImageAssetArray count];
    if (selectedImageCount > 0 && selectedImageCount >= _minimumSelectImageCount) {
        self.previewButton.enabled = YES;
        self.sendButton.enabled = YES;
        self.imageCountLabel.text = [NSString stringWithFormat:@"%@", @(selectedImageCount)];
        self.imageCountLabel.hidden = NO;
        [QMUIImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:self.imageCountLabel];
    } else {
        self.previewButton.enabled = NO;
        self.sendButton.enabled = NO;
        self.imageCountLabel.hidden = YES;
    }
}

#pragma mark - Request Image

- (void)requestImageWithIndexPath:(NSIndexPath *)indexPath {
    // ?????????????????????????????????????????? iCloud?????????????????????????????????????????????????????????????????? id????????????????????????
    QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    QMUIImagePickerCollectionViewCell *cell = (QMUIImagePickerCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    imageAsset.requestID = [imageAsset requestOriginImageWithCompletion:^(UIImage *result, NSDictionary *info) {
        
        BOOL downloadSucceed = (result && !info) || (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        
        if (downloadSucceed) {
            // ??????????????????????????????????????????
            [imageAsset updateDownloadStatusWithDownloadResult:YES];
            cell.downloadStatus = QMUIAssetDownloadStatusSucceed;
            
        } else if ([info objectForKey:PHImageErrorKey] ) {
            // ????????????
            [imageAsset updateDownloadStatusWithDownloadResult:NO];
            cell.downloadStatus = QMUIAssetDownloadStatusFailed;
        }
        
    } withProgressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        imageAsset.downloadProgress = progress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.collectionView qmui_itemVisibleAtIndexPath:indexPath]) {
                
                QMUILogInfo(@"QMUIImagePickerLibrary", @"Download iCloud image, current progress is : %f", progress);
                
                if (cell.downloadStatus != QMUIAssetDownloadStatusDownloading) {
                    cell.downloadStatus = QMUIAssetDownloadStatusDownloading;
                    // ???????????????????????????????????????
                    self.imagePickerPreviewViewController.downloadStatus = QMUIAssetDownloadStatusDownloading;
                }
                if (error) {
                    QMUILog(@"QMUIImagePickerLibrary", @"Download iCloud image Failed, current progress is: %f", progress);
                    cell.downloadStatus = QMUIAssetDownloadStatusFailed;
                }
            }
        });
    }];
}

@end
