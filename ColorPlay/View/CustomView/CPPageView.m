//
//  CPPageView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//  http://www.wugaojun.com/blog/2015/06/06/uiscrollviewji-xian-you-hua-liang-ge-imageviewxun-huan-li-yong/
//

#import "CPPageView.h"

@interface CPPageView()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray           *imagePages;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIPageControl     *pageControl;
@property (assign, nonatomic) NSInteger         currentIndex;
/**
 *  可重用视图
 */
@property (strong, nonatomic) NSMutableSet      *reusedImageViews;
/**
 *  可见视图
 */
@property (strong, nonatomic) NSMutableSet      *visibleImageViews;

@end

@implementation CPPageView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame page:(NSArray *)photos
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        self.imagePages = photos;
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame page:nil];
}

- (void)commonInit
{
    self.currentIndex = 0;
    
    self.scrollView = ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(self.bounds.size.width * self.imagePages.count, self.bounds.size.height);
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView;
    });
    [self showImageViewAtIndex:0];
    [self addSubview:self.scrollView];
    
    self.pageControl = ({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                                     self.frame.size.height - 40,
                                                                                     self.frame.size.width,
                                                                                     40)];
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = [self.imagePages count];
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        pageControl;
        
    });
    [self addSubview:self.pageControl];
    
    
    //设置单击手势
    [self addTapGesture];
}

- (void)showImageViewAtIndex:(NSInteger)index
{
    UIImageView *imageView = [self.reusedImageViews anyObject];
    if (imageView)
    {
        [self.reusedImageViews removeObject:imageView];
    }
    else
    {
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    CGRect bounds = self.scrollView.bounds;
    CGRect imageViewFrame = bounds;
    imageViewFrame.origin.x = CGRectGetWidth(bounds) * index;
    imageView.tag = index;
    imageView.frame = imageViewFrame;
    imageView.image = ({
    
        NSString *path = [[NSBundle mainBundle] pathForResource:self.imagePages[index] ofType:@".png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        image;
        
    });
    
    [self.visibleImageViews addObject:imageView];
    [self.scrollView addSubview:imageView];
}

#pragma mark - gesture

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //tap.numberOfTouchesRequired = 1;
    //tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
}

#pragma mark - events

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if( self.currentIndex < self.imagePages.count-1 )
    {
        [self.scrollView setContentOffset:CGPointMake((self.currentIndex+1) * self.bounds.size.width, 0) animated:YES];
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(didClickPage:atIndex:)] )
    {
        [self.delegate didClickPage:self atIndex:self.currentIndex];
    }
}

- (void)changePage:(id)sender
{
    UIPageControl *currentControl = (UIPageControl *)sender;
    self.currentIndex = currentControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex * self.bounds.size.width, 0) animated:YES];
}

#pragma mark - delegate
/**
 *  second 在滑动结束减速时调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollEnd %@", scrollView);
    //NSInteger currentPage = scrollView.contentOffset.x / self.bounds.size.width;
    //self.pageControl.currentPage = currentPage;
}

/**
 *  first ,在这里面实现复用uiimageview优化,
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = self.scrollView.contentOffset.x / self.bounds.size.width;
    self.pageControl.currentPage = self.currentIndex;
    NSLog(@"scroll %@ %ld", scrollView, (long)self.currentIndex);
    
    CGRect visibleBounds = self.scrollView.bounds;
    CGFloat minX = CGRectGetMinX(visibleBounds);
    CGFloat maxX = CGRectGetMaxX(visibleBounds);
    CGFloat width = CGRectGetWidth(visibleBounds);
    
    NSInteger firstIndex = (NSInteger)floorf(minX / width);
    NSInteger lastIndex  = (NSInteger)floorf(maxX / width);
    
    if (firstIndex < 0)
    {
        firstIndex = 0;
    }
    
    if (lastIndex >= [self.imagePages count])
    {
        lastIndex = [self.imagePages count] - 1;
    }
    
    NSInteger imageViewIndex = 0;
    for (UIImageView *imageView in self.visibleImageViews)
    {
        imageViewIndex = imageView.tag;

        if (imageViewIndex < firstIndex || imageViewIndex > lastIndex)
        {
            [self.reusedImageViews addObject:imageView];
            [imageView removeFromSuperview];
        }
    }
    
    [self.visibleImageViews minusSet:self.reusedImageViews];
    
    for (NSInteger index = firstIndex; index <= lastIndex; index++)
    {
        BOOL isShow = NO;
        
        for (UIImageView *imageView in self.visibleImageViews)
        {
           
            if (imageView.tag == index)
            {
                isShow = YES;
                break;
            }
        }
        
        if (!isShow)
        {
            [self showImageViewAtIndex:index];
        }
    }
    
    // 测试
    //[self testMemory];
}

#pragma mark - getter

- (NSMutableSet *)visibleImageViews
{
    if (_visibleImageViews == nil)
    {
        _visibleImageViews = [[NSMutableSet alloc] init];
    }
    
    return _visibleImageViews;
}

- (NSMutableSet *)reusedImageViews
{
    if (_reusedImageViews == nil)
    {
        _reusedImageViews = [[NSMutableSet alloc] init];
    }
    
    return _reusedImageViews;
}

#pragma mark - test

- (void)testMemory
{
    NSMutableString *rs = [NSMutableString string];
    NSInteger count = [self.scrollView.subviews count];
    for (UIImageView *imageView in self.scrollView.subviews)
    {
        [rs appendFormat:@"%p - ", imageView];
    }
    [rs appendFormat:@"%ld", (long)count];
    NSLog(@"%@", rs);
}

@end
