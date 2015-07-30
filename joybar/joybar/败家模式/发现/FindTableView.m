//
//  FindTableView.m
//  joybar
//
//  Created by 123 on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "FindTableView.h"
#import "CusFindTableViewCell.h"
@implementation FindTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count/2+self.dataArr.count%2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusFindTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count>0)
    {
        NSRange range = NSMakeRange(indexPath.row*2, 2);
        if (self.dataArr.count%2==1 && (indexPath.row == self.dataArr.count/2 + self.dataArr.count%2 - 1))
        {
            range = NSMakeRange(indexPath.row*2, 1);
        }
        NSArray *arr  =[self.dataArr subarrayWithRange:range];
        [cell setData:arr];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-15)/2*0.618+5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
