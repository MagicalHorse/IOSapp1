//
//  CusCircleDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCircleDetailViewController.h"
#import "CusInviteFriendViewController.h"
#import "CircleDetailData.h"
#import "CircleDetailUser.h"
@interface CusCircleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *tempView;

@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,strong) UIButton *cancleBtn;

@property (nonatomic ,assign) BOOL hiddenDeleteBtn;

@property (nonatomic ,assign) BOOL selectJianBtn;

//@property (nonatomic ,strong) NSMutableArray *userArr;

@property (nonatomic ,strong) CircleDetailData *circleData;
@end

@implementation CusCircleDetailViewController
{
    UILabel *circleNumLab;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 248);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self addNavBarViewAndTitle:@""];
    self.hiddenDeleteBtn=YES;
    self.selectJianBtn = NO;
    [self addTitleView];

//    [self addBigView];
    [self getCircleDetailData];
}

-(void)getCircleDetailData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.circleId forKey:@"groupid"];
    [HttpTool postWithURL:@"Community/GetBuyerGroupDetail" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"IsSuccess"] boolValue])
        {
            self.circleData = [CircleDetailData objectWithKeyValues:[json objectForKey:@"data"]];
            circleNumLab.text = [NSString stringWithFormat:@"%@人",self.circleData.MemberCount];
            [self.tableView reloadData];
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}


-(void)addTitleView
{
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.center = CGPointMake(kScreenWidth/2, 32);
    nameLab.bounds = CGRectMake(0, 0, 200, 20);
    nameLab.text = @"圈子信息";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont fontWithName:@"youyuan" size:17];
    [self.navView addSubview:nameLab];
    
    circleNumLab = [[UILabel alloc] init];
    circleNumLab.center = CGPointMake(kScreenWidth/2, nameLab.bottom+10);
    circleNumLab.bounds = CGRectMake(0, 0, 100, 20);
//    circleNumLab.text = @"10000人";
    circleNumLab.textColor = [UIColor lightGrayColor];
    circleNumLab.font = [UIFont fontWithName:@"youyuan" size:12];
    circleNumLab.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:circleNumLab];
    
}
//
//-(void)addBigView
//{
//    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    _tempView.hidden = YES;
//    _tempView.alpha = 0;
//    _tempView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_tempView];
//    
//    _bgView = [[UIView alloc] init];
//    _bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
//    _bgView.bounds = CGRectMake(0, 0, kScreenWidth-50, (kScreenWidth-50)*1.35);
//    _bgView.layer.cornerRadius = 4;
//    _bgView.backgroundColor = kCustomColor(245, 246, 247);
//    _bgView.hidden = YES;
//    _bgView.userInteractionEnabled = YES;
//    [self.view addSubview:_bgView];
//    
//    _cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _cancleBtn.center = CGPointMake(kScreenWidth-25, _bgView.top);
//    _cancleBtn.bounds = CGRectMake(0, 0, 50, 50);
//    _cancleBtn.hidden = YES;
//    [_cancleBtn setImage:[UIImage imageNamed:@"叉icon"] forState:(UIControlStateNormal)];
//    [_cancleBtn addTarget:self action:@selector(didClickHiddenView:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:_cancleBtn];
//    
//    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
//    headerImage.backgroundColor = [UIColor orangeColor];
//    headerImage.layer.cornerRadius = headerImage.width/2;
//    [_bgView addSubview:headerImage];
//    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, headerImage.top+10, _bgView.width-100, 20)];
//    titleLab.text = @"啊实打实女包";
//    titleLab.font = [UIFont fontWithName:@"youyuan" size:16];
//    [_bgView addSubview:titleLab];
//    
//    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, titleLab.bottom+2, _bgView.width-100, 20)];
//    numLab.text = @"成员: 123123人";
//    numLab.font = [UIFont fontWithName:@"youyuan" size:14];
//    numLab.textColor = [UIColor darkGrayColor];
//    [_bgView addSubview:numLab];
//    
//    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, headerImage.bottom+10, _bgView.width-70, _bgView.width-70)];
//    codeImage.backgroundColor = [UIColor orangeColor];
//    [_bgView addSubview:codeImage];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, codeImage.bottom+10, _bgView.width, 20)];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"点击分享给你的朋友吧";
//    lab.textColor = [UIColor grayColor];
//    lab.font = [UIFont fontWithName:@"youyuan" size:13];
//    [_bgView addSubview:lab];
//    
//    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    shareBtn.center = CGPointMake(_bgView.width/2, lab.bottom+20);
//    shareBtn.bounds = CGRectMake(0, 0, 80, 30);
//    [shareBtn setTitle:@"分享" forState:(UIControlStateNormal)];
//    [shareBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    shareBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
//    shareBtn.layer.cornerRadius = 3;
//    shareBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    shareBtn.layer.borderWidth = 0.5;
//    
//    [shareBtn addTarget:self action:@selector(didClickShareBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [_bgView addSubview:shareBtn];
//}

#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kCustomColor(245, 246, 247);
    if (section==0)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
        lab.text = @"圈子成员";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [header addSubview:lab];
    }
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section==0)
    {
        for (int i=0; i<self.circleData.Users.count+2; i++)
        {
        
            
            CGFloat width = (kScreenWidth-20)/4;
            CGFloat height = width+20;
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(i%4*width+10, i/4*height, width, height);
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(didClickHeaderImage:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.tag = 1000+i;
            [cell.contentView addSubview:btn];
            
            UIImageView *img = [[UIImageView alloc] init];
            img.center = CGPointMake(btn.width/2, btn.height/2-5);
            img.bounds = CGRectMake(0, 0, btn.width-12, btn.width-12);
            img.layer.cornerRadius = img.width/2;
            img.clipsToBounds = YES;
            [btn addSubview:img];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom, btn.width, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor darkGrayColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:12];
            [btn addSubview:lab];
            
            if (i<self.circleData.Users.count)
            {
                CircleDetailUser *circleUser = [self.circleData.Users objectAtIndex:i];
                [img sd_setImageWithURL:[NSURL URLWithString:circleUser.Logo] placeholderImage:nil];
                lab.text = circleUser.NickName;
                
                UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                deleteBtn.frame = CGRectMake(img.width-18, 5, 27, 27);
                deleteBtn.backgroundColor = [UIColor clearColor];
                
                [deleteBtn addTarget:self action:@selector(didClickDeleteUser:) forControlEvents:(UIControlEventTouchUpInside)];
                if (self.hiddenDeleteBtn==YES)
                {
                    deleteBtn.hidden = YES;
                }
                else
                {
                    deleteBtn.hidden = NO;
                }
                [deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:(UIControlStateNormal)];
                
                deleteBtn.tag = 100+i;
                [btn addSubview:deleteBtn];

            }
            else
            {
                if (i==self.circleData.Users.count+1)
                {
                    img.backgroundColor = [UIColor clearColor];
                    img.image = [UIImage imageNamed:@"jian"];
                    lab.text = @"删除好友";
                }
                else if (i==self.circleData.Users.count)
                {
                    img.backgroundColor = [UIColor clearColor];
                    img.image = [UIImage imageNamed:@"jia"];
                    lab.text = @"邀请好友";
                }
            }
        }
    }
    if (indexPath.section==1)
    {
        NSArray *arr = @[@"圈子名称",@"圈子头像"];
        if (indexPath.row<2)
        {
//            if (indexPath.row==0)
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                
//                UIImageView *orCode = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-80, 5, 40, 40)];
//                orCode.backgroundColor = [UIColor orangeColor];
//                [cell.contentView addSubview:orCode];
//            }
            if (indexPath.row==0)
            {
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-210, 15, 200, 20)];
                lab.text = self.circleData.GroupName;
                lab.textColor = [UIColor grayColor];
                lab.font = [UIFont fontWithName:@"youyuan" size:14];
                lab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:lab];
            }
            if (indexPath.row==1)
            {
                UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
                NSString *imageURL = [NSString stringWithFormat:@"%@_100x100.jpg",self.circleData.GroupPic];
                [headerImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
                [cell.contentView addSubview:headerImage];
            }
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
            lab.text = [arr objectAtIndex:indexPath.row];
            lab.font = [UIFont fontWithName:@"youyuan" size:16];
            [cell.contentView addSubview:lab];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 1)];
            line.backgroundColor = kCustomColor(240, 240, 240);
            [cell.contentView addSubview:line];
        }
        else
        {
            cell.backgroundColor = kCustomColor(245, 246, 248);
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(15, 20, kScreenWidth-30, 50);
            btn.backgroundColor = kCustomColor(253, 162, 41);
            btn.layer.cornerRadius = 3;
            [btn setTitle:@"删除并退出" forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:17];
            [cell.contentView addSubview:btn];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0&&indexPath.row==0)
    {
        return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count+1)/4+1)+5;

//        if((self.circleData.Users.count)%4==0)
//        {
//        }
//        else
//        {
//            return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count+1)/4+1)+5;
//        }
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==2)
        {
            return 90;
        }
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==1&&indexPath.row==0)
//    {
//        _tempView.hidden = NO;
//        _bgView.hidden = NO;
//        [UIView animateWithDuration:0.15 animations:^{
//            _tempView.alpha = 0.6;
//
//        }];
//        
//        _bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//        
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             _bgView.transform = CGAffineTransformMakeScale(1, 1);
//                             _bgView.alpha = 1;
//
//                         }completion:^(BOOL finish){
//                             _cancleBtn.hidden = NO;
//                         }];
//
//    }
}

//点叉
//-(void)didClickHiddenView:(UIButton *)btn
//{
//    
//    btn.hidden = YES;
//
//    _bgView.transform = CGAffineTransformMakeScale(1, 1);
//    
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         _bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//                         _bgView.alpha = 0.6;
//                     }completion:^(BOOL finish){
//                         _tempView.hidden = YES;
//                         _bgView.hidden = YES;
//                     }];
//
//}

//分享
-(void)didClickShareBtn
{
    
}

-(void)didClickHeaderImage:(UIButton *)btn
{
    
    //减
    if (btn.tag-1000==self.circleData.Users.count+1)
    {
        if (self.selectJianBtn ==NO)
        {
            self.hiddenDeleteBtn = NO;
            self.selectJianBtn =YES;
        }
        else
        {
            self.hiddenDeleteBtn = YES;
            self.selectJianBtn =NO;
        }
        
        [self.tableView reloadData];
    }
    
    //加
    if (btn.tag-1000==self.circleData.Users.count)
    {
        CusInviteFriendViewController *VC = [[CusInviteFriendViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }

}

//删除圈子用户
-(void)didClickDeleteUser:(UIButton *)btn
{
    [self.circleData.Users removeObjectAtIndex:btn.tag-100];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
