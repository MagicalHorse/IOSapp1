//
//  FaceScroller.m
//  FaceView
//
//  Created by Sundy on 14-3-12.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import "FaceScroller.h"
#import "UIViewExt.h"

@implementation FaceScroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:240/255.0f green:245/255.0f blue:246/255.0f alpha:1.0f];
        [self initWithFaceView];
        
    }
    return self;
}

- (void)initWithFaceView
{    
    faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    faceView.backgroundColor = [UIColor clearColor];
    faceView.faceViewDelegate = self;
    faceScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, faceView.height)];
    faceScroller.pagingEnabled = YES;
    faceScroller.backgroundColor = [UIColor clearColor];
    faceScroller.showsHorizontalScrollIndicator = NO;
    faceScroller.showsVerticalScrollIndicator = NO;
    faceScroller.clipsToBounds = NO;
    faceScroller.delegate = self;
    faceScroller.contentSize = CGSizeMake(faceView.width, faceView.height);
    [faceScroller addSubview:faceView];
    
    facePage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, faceScroller.height, kScreenWidth,40)];
    facePage.backgroundColor = [UIColor clearColor];
    facePage.numberOfPages = faceView.pageNumber;
    facePage.currentPage = 0;
    [self addSubview:facePage];
    
    [self addSubview:faceScroller];
    
    self.height = faceScroller.height + facePage.height;
    self.width = faceScroller.width;
}

- (void)drawRect:(CGRect)rect
{
//    设置view的背景
//    UIImage *bg = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
//    [bg drawInRect:rect];
}

#pragma mark - 
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kScreenWidth;
    facePage.currentPage = page;
}

#pragma mark - FaceViewDelegate
- (void)faceViewClickItem:(NSString *)faceName
{
    if ([self.faceViewClickDelegate respondsToSelector:@selector(faceViewItemClick:)]) {
        [self.faceViewClickDelegate faceViewItemClick:faceName];
    }
}

@end
