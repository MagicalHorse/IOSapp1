//
//  MessageTableView.m
//  joybar
//
//  Created by 123 on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MessageTableView.h"
#import "CusMessageTableViewCell.h"
#import "CusChatViewController.h"
@implementation MessageTableView


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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusMessageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count>0)
    {
        [cell setData:[self.dataArr objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *roomId = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"RoomId"];
    NSString *userId = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"Id"];
    NSString *userName = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"Name"];

    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:userId AndTpye:2 andUserName:userName];
    VC.isFrom = isFromPrivateChat;
    [self.viewController.navigationController pushViewController:VC animated:YES];
}

@end
