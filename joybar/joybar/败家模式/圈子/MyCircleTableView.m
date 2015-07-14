//
//  MyCircleTableView.m
//  joybar
//
//  Created by 123 on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MyCircleTableView.h"
#import "CusMyCircleTableViewCell.h"
#import "CusCircleDetailViewController.h"
#import "CusChatViewController.h"
@implementation MyCircleTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusMyCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CusMyCircleTableViewCell" owner:self options:nil] lastObject];
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
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *circleId = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"Id"];
    NSString *circleName = [[self.dataArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    CusChatViewController *VC = [[CusChatViewController alloc] initWithUserId:circleId AndTpye:2 andUserName:circleName];
    VC.circleId = circleId;
    VC.isFrom = isFromGroupChat;
    [self.viewController.navigationController pushViewController:VC animated:YES];

}

@end
