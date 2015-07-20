//
//  CusInviteFriendViewController.m
//  joybar
//
//  Created by 123 on 15/5/26.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusInviteFriendViewController.h"

@interface CusInviteFriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray * dataSource, * dataBase;

//判断是不是选中状态
@property (nonatomic ,strong) NSMutableArray *isSelectArr;

@property (nonatomic ,strong) UIButton *allSelectBtn;

@end

@implementation CusInviteFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isSelectArr = [NSMutableArray array];
    
    _dataBase = [[NSMutableArray alloc] init] ;
    [self addNavBarViewAndTitle:@"邀请好友"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    //改变索引的颜色
//    self.tableView.sectionIndexColor = [UIColor blueColor];
//    //改变索引选中的背景颜色
//    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];
//    //索引数组
//    _dataSource = [[NSMutableArray alloc] init] ;
    //tableview 数据源
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.allSelectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.allSelectBtn.frame = CGRectMake(5, 10, 30, 30);
    [self.allSelectBtn setImage:[UIImage imageNamed:@"圈icon"] forState:(UIControlStateNormal)];
    [self.allSelectBtn addTarget:self action:@selector(didClickSelectAllUser:) forControlEvents:(UIControlEventTouchUpInside)];
    self.allSelectBtn.selected = NO;
    [bottomView addSubview:self.allSelectBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.allSelectBtn.right+5, 15, 60, 20)];
    lab.text = @"全选";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor grayColor];
    [bottomView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(kScreenWidth-80, 7, 70, 35);
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = [UIColor orangeColor];
    [sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    sureBtn.selected = NO;
    [bottomView addSubview:sureBtn];
    
    [self getCityData];
}

-(void)getCityData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.circleId forKey:@"groupid"];
    [self hudShow];
    [HttpTool postWithURL:@"Community/GetValidFansListToGroup" params:dic success:^(id json) {
        NSLog(@"%@",json);
        
        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr =[json objectForKey:@"data"];
            [self.dataBase addObjectsFromArray:arr];
            
//            NSMutableArray *array = [NSMutableArray array];
            for (int j=0; j<arr.count; j++)
            {
                [self.isSelectArr addObject:@"0"];
            }
            
//            [self.isSelectArr addObjectsFromArray:array];
            
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        [self hiddleHud];
    }];
    
}
//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataBase.count;
}

//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.dataBase.count>0)
    {
        NSDictionary *dic = [self.dataBase objectAtIndex:indexPath.row];
        UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, 17, 18, 18)];
        selectImage.tag = indexPath.row+1000;
        if([[self.isSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
        {
            selectImage.image = [UIImage imageNamed:@"圈icon"];
        }
        else
        {
            selectImage.image = [UIImage imageNamed:@"对号icon"];
        }
        [cell.contentView addSubview:selectImage];
        
        UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(selectImage.right+10, 5, 45, 45)];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"UserLogo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        headerImage.clipsToBounds = YES;
        headerImage.layer.cornerRadius = headerImage.width/2;
        [cell.contentView addSubview:headerImage];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+10, 17, 170, 20)];
        nameLab.text = [dic objectForKey:@"UserName"];
        nameLab.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLab];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
    
    NSString *str = [self.isSelectArr objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"0"])
    {
        [self.isSelectArr setObject:@"1" atIndexedSubscript:indexPath.row];
        img.image = [UIImage imageNamed:@"对号icon"];
    }
    else
    {
        img.image = [UIImage imageNamed:@"圈icon"];

        [self.isSelectArr setObject:@"0" atIndexedSubscript:indexPath.row];
    }
}

//选择全部
-(void)didClickSelectAllUser:(UIButton *)btn
{
    if (btn.selected==YES)
    {
        for (int i=0; i<self.isSelectArr.count; i++)
        {
            for (int j=0; j<[[self.isSelectArr objectAtIndex:i]count]; j++)
            {
                [[self.isSelectArr objectAtIndex:i] setObject:@"0" atIndexedSubscript:j];
                [btn setImage:[UIImage imageNamed:@"圈icon"] forState:(UIControlStateNormal)];
                btn.selected = NO;
            }
        }
    }
    else
    {
        for (int i=0; i<self.isSelectArr.count; i++)
        {
            for (int j=0; j<[[self.isSelectArr objectAtIndex:i]count]; j++)
            {
                [[self.isSelectArr objectAtIndex:i] setObject:@"1" atIndexedSubscript:j];
                [btn setImage:[UIImage imageNamed:@"对号icon"] forState:(UIControlStateNormal)];
                btn.selected = YES;
            }
        }
    }
    [self.tableView reloadData];
}

//确定
-(void)didClickSureBtn:(UIButton *)btn
{
    
    NSLog(@"asdasdasdasda");
    NSMutableString *selectStr = [NSMutableString string];
    for (int i=0; i<self.dataBase.count; i++)
    {
        if ([[self.isSelectArr objectAtIndex:i] isEqualToString:@"1"])
        {
            NSMutableDictionary *dic = [self.dataBase objectAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"%@,",[dic objectForKey:@"UserId"]];
            
            NSLog(@"%@",str);
            
            [selectStr appendString:str];
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.circleId forKey:@"groupId"];
    [dic setObject:selectStr forKey:@"useridstr"];
    [HttpTool postWithURL:@"Community/AddFansToGroup" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self showHudSuccess:@"邀请成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
