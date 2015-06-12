//
//  CircleTableView.m
//  joybar
//
//  Created by 123 on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CircleTableView.h"
#import "CircleTableViewCell.h"
@implementation CircleTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
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
    CircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CircleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count>0)
    {
        NSRange range = NSMakeRange(indexPath.row*2, 2);
        if (self.dataArr.count%2==1 && (indexPath.row == self.dataArr.count/2 + self.dataArr.count%2 - 1)) {
            range = NSMakeRange(indexPath.row*2, 1);
        }
        NSArray *arr  =[self.dataArr subarrayWithRange:range];
        [cell setData:arr];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kScreenWidth-60)/2+81;
}

@end
