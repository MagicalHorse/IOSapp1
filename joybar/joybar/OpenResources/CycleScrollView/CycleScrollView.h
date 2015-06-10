//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void) TapActionBlock:(NSInteger)pageIndex;
@end

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger) totalPagesCount;
- (UIView *) fetchContentViewAtIndex:(NSInteger)pageIndex;
@end

@interface CycleScrollView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isHomeVC;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
//@property (nonatomic, copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
//@property (nonatomic, copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
//@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) id<CycleScrollViewDatasource> datasource;
@property (nonatomic, assign) id<CycleScrollViewDelegate> delegate;

- (void)reloadData;

@end