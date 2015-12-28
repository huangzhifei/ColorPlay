//
//  CPPageView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPPageView.h"

@interface CPPageView()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray           *pages;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIPageControl     *pageControl;

@end

@implementation CPPageView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame page:(NSArray *)photos
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        _pages = photos;
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
    _scrollView = ({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(self.bounds.size.width * _pages.count, self.bounds.size.height);
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView;
    });
    [self loadScrollViewPage];
    [self addSubview:_scrollView];
    
    _pageControl = ({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                                     self.frame.size.height - 40,
                                                                                     self.frame.size.width,
                                                                                     40)];
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = [_pages count];
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        pageControl;
        
    });
    [self addSubview:_pageControl];
}

- (void)loadScrollViewPage
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSInteger i = 0; i < [self.pages count]; i++)
    {
        UIImage *image = [UIImage imageNamed:self.pages[i]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(i * width, 0, width, height)];
        
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - events

- (void)changePage:(id)sender
{
    UIPageControl *currentControl = (UIPageControl *)sender;
    NSInteger currentPage = currentControl.currentPage;
    _scrollView.contentOffset = CGPointMake(currentPage * self.bounds.size.width, 0);
}

#pragma mark - delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / self.bounds.size.width;
    self.pageControl.currentPage = currentPage;
}

@end
