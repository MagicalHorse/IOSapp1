//
//  FaceView.m
//  FaceView
//
//  Created by Sundy on 14-3-12.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import "FaceView.h"
#import "UIViewExt.h"

#define item_width      42
#define item_height     45

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.faceDict = [NSMutableDictionary dictionary];
        
        //        加载数据
        [self initWithData];
        
        //    共多少页
        self.pageNumber = items.count;
    }
    return self;
}

- (void)initWithData
{
    items = [NSMutableArray array];
    
    NSString *emojPath = [[NSBundle mainBundle]pathForResource:@"FaceList" ofType:@"plist"];
    
    NSArray *emojItem = [NSArray arrayWithContentsOfFile:emojPath];
    
    //将表情的名称以及对应的图片存入字典,方便使用.
//    for (NSDictionary *dict in emojItem) {
//        NSString *face_Image = [dict objectForKey:@"png"];
//        NSString *faceName = [dict objectForKey:@"chs"];
//        [self.faceDict setObject:face_Image forKey:faceName];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:self.faceDict forKey:@"faceInfo"];
    
//    计算最后一页剩几个
    lastPageCount = emojItem.count%28;
    
    NSMutableArray *item2D = nil;
//    ------------整理表情，整理成一个二维数组------------
    for (int i = 0; i < emojItem.count; i++) {
        NSMutableDictionary *item = [emojItem objectAtIndex:i];
        if (i % 28 == 0) {
            item2D = [NSMutableArray arrayWithCapacity:28];
            [items addObject:item2D];
        }
        [item2D addObject:item];
    }
//    设置尺寸
    self.width = items.count * kScreenWidth;
    self.height = 4 * item_height;
    
    bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
    bigImageView.image = [UIImage imageNamed:@"EmoticonTips_ios7.png"];
    bigImageView.hidden = YES;
    bigImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:bigImageView];
    
//    表情视图
    UIImageView *faceImage = [[UIImageView alloc]initWithFrame:CGRectMake((64-30)/2, 18, 30, 30)];
    faceImage.tag = 2014;
    faceImage.backgroundColor = [UIColor clearColor];
    [bigImageView addSubview:faceImage];
}

//将表情画上去
- (void)drawRect:(CGRect)rect
{
//    定义行列
    int row = 0, colum = 0;
    for (int i = 0; i < items.count; i++) {
        NSArray *item2d = [items objectAtIndex:i];
        
        for (int k = 0; k < item2d.count; k++) {
            NSDictionary *item = [item2d objectAtIndex:k];
            //拿到图片名称
            NSString *imageName = [item objectForKey:@"png"];
            
            UIImage *image = [UIImage imageNamed:imageName];
            //考虑页数，需要加上前几页的宽度
            CGRect frame = CGRectMake(colum*(kScreenWidth/7)+15, row*item_height+15, 30, 30);
            
            float x = frame.origin.x + (kScreenWidth * i);
            frame.origin.x = x;
            
            //画上去
            [image drawInRect:frame];
            
           //更新列与行
            colum ++;
            if (colum % 7 == 0) {
                row ++;
                colum = 0;
            }
            if (row % 4 == 0) {
                row = 0;
            }
        }
    }
}

- (void)touchFace:(CGPoint)tPoint
{
//    当前页
    int page = tPoint.x/kScreenWidth;
    float x = tPoint.x-(page*kScreenWidth)-10;
    float y = tPoint.y-10;
    
//    计算列与行
    int colum = x / (kScreenWidth/7);
    int row = y / item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    
    if (colum < 0) {
        colum = 0;
    }
    
    if (row > 3) {
        row = 3;
    }
    
    if (row < 0) {
        row = 0;
    }
    
//    计算选中表情的索引
    int index = colum + (row * 7);
//    需要计算每一页的表情个数
//    if (index >= lastPageCount && page == self.pageNumber-1) {
//        self.selectedFaceName = nil;
//        return;
//    }else
//    {
        NSArray *item2D = [items objectAtIndex:page];
        NSDictionary *item = [item2D objectAtIndex:index];
        //    拿到表情的图片/名称
        NSString *faceName = [item objectForKey:@"chs"];
        
        //    记下触摸的表情
        if (![self.selectedFaceName isEqualToString:faceName] || self.selectedFaceName == nil) {
            self.selectedFaceName = faceName;
            
            NSString *face_Image = [item objectForKey:@"png"];
            NSLog(@"faceName = %@",faceName);
            
            //    放大镜显示表情
            UIImageView *faceImage = (UIImageView *)[bigImageView viewWithTag:2014];
            faceImage.backgroundColor = [UIColor clearColor];
            faceImage.image = [UIImage imageNamed:face_Image];
            
            //    修改放大镜的坐标
            bigImageView.left = (page * kScreenWidth)+colum*(kScreenWidth/7)-3;
            bigImageView.bottom = row * item_height+50;
        }
//    }
}

//touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    bigImageView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint tPoint = [touch locationInView:self];
    [self touchFace:tPoint];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroller = (UIScrollView *)self.superview;
        scroller.scrollEnabled = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    bigImageView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroller = (UIScrollView *)self.superview;
        scroller.scrollEnabled = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tPoint = [touch locationInView:self];
    [self touchFace:tPoint];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroller = (UIScrollView *)self.superview;
        scroller.scrollEnabled = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    bigImageView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroller = (UIScrollView *)self.superview;
        scroller.scrollEnabled = YES;
    }
    
    if ([self.faceViewDelegate respondsToSelector:@selector(faceViewClickItem:)]) {
        [self.faceViewDelegate faceViewClickItem:self.selectedFaceName];
    }
}

@end
