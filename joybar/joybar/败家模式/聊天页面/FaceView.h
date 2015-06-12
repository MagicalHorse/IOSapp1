//
//  FaceView.h
//  FaceView
//  加载表情图片的View,画上去

//  Created by Sundy on 14-3-12.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

- (void)faceViewClickItem:(NSString *)faceName;

@end

@interface FaceView : UIView
{
@private
    NSMutableArray *items;
    UIImageView *bigImageView;
//    最后一页的表情个数
    NSInteger lastPageCount;
}

@property (assign, nonatomic) id<FaceViewDelegate>faceViewDelegate;

@property (nonatomic ,assign) NSInteger pageNumber;

@property (copy, nonatomic) NSString *selectedFaceName;

//@property (strong, nonatomic) NSMutableDictionary *faceDict;

@end
