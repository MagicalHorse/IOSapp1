//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

@synthesize delegate;
@synthesize datasource;

- (id) initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        
        UIImageView *pageBg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 160, 292, 20)];
        pageBg.userInteractionEnabled = YES;
//        pageBg.image = [PublicFunction getImgByLocal:@"md_banneryinying.png"];
        [self addSubview:pageBg];
        
    }
    return self;
}

- (void) reloadData
{
    
    if(!self.pageControl)
    {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.center = CGPointMake(kScreenWidth/2, kScreenWidth/2-20);
        self.pageControl.bounds = CGRectMake(0, 0, kScreenWidth, 20);
    }
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageControl];
    
    if (datasource && [datasource respondsToSelector:@selector(totalPagesCount)])
    {
        _totalPageCount = [datasource totalPagesCount];
    }
    if (_totalPageCount==1)
    {
        self.scrollView.scrollEnabled = NO;
    }
    if (_totalPageCount>1)
    {
        self.pageControl.numberOfPages = _totalPageCount;
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews)
    {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource {
    
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (datasource && [datasource respondsToSelector:@selector(fetchContentViewAtIndex:)])
    {
        [self.contentViews addObject:[datasource fetchContentViewAtIndex:previousPageIndex]];
        [self.contentViews addObject:[datasource fetchContentViewAtIndex:_currentPageIndex]];
        [self.contentViews addObject:[datasource fetchContentViewAtIndex:rearPageIndex]];
    }
}

- (NSInteger) getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex
{
    
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.animationTimer pauseTimer];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self reloadData];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self reloadData];
    }
    
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

- (void) animationTimerDidFired:(NSTimer *)timer {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void) contentViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (delegate && [delegate respondsToSelector:@selector(TapActionBlock:)]) {
        [delegate TapActionBlock:self.currentPageIndex];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
