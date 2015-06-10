//
//  BuyerHistoryViewController.m
//  joybar
//
//  Created by liyu on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerHistoryViewController.h"
#import "UUChart.h"

@interface BuyerHistoryViewController ()<UUChartDataSource>
@property(nonatomic,strong)UUChart *chartView;
@property(nonatomic,strong)NSArray *array;

@end

@implementation BuyerHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array =@[@"22",@"144",@"15",@"40",@"42"];
    self.chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                                   withSource:self
                                                    withStyle:UUChartLineStyle];
    [self.chartView showInView:self.view];
    
}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    return [self getXTitles:5];
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    return @[self.array];
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    
    return CGRangeMake(200, 10);
    
}

#pragma mark 折线图专享功能


//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}


@end
