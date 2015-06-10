//
//  FaceScroller.h
//  FaceView
//  加载FaceView

//  Created by Sundy on 14-3-12.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@protocol FaceVIewItemClickDelegate <NSObject>

- (void)faceViewItemClick:(NSString *)faceName;

@end

@interface FaceScroller : UIView<UIScrollViewDelegate,FaceViewDelegate>
{
    UIScrollView        *faceScroller;
    UIPageControl       *facePage;
    FaceView            *faceView;
}

@property (strong, nonatomic) id<FaceVIewItemClickDelegate>faceViewClickDelegate;

@end
