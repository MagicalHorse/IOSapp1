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
    
    [self addNavBarViewAndTitle:@"邀请好友"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //改变索引的颜色
    self.tableView.sectionIndexColor = [UIColor blueColor];
    //改变索引选中的背景颜色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor orangeColor];
    //索引数组
    _dataSource = [[NSMutableArray alloc] init] ;
    //tableview 数据源
    _dataBase = [[NSMutableArray alloc] init] ;
        
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
    lab.font = [UIFont fontWithName:@"youyuan" size:14];
    lab.textColor = [UIColor grayColor];
    [bottomView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sureBtn.frame = CGRectMake(kScreenWidth-80, 7, 70, 35);
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:15];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = [UIColor orangeColor];
    [sureBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    sureBtn.selected = NO;
    [bottomView addSubview:sureBtn];
    
    [self getCityData];
}

-(void)getCityData
{
    [HttpTool postWithURL:@"Common/GetCityList" params:nil success:^(id json) {
        NSLog(@"%@",json);
        
        self.dataBase = [json objectForKey:@"data"];
        
        for (int i=0; i<self.dataBase.count; i++)
        {
            NSString *key = [[self.dataBase objectAtIndex:i] objectForKey:@"key"];
            [self.dataSource addObject:key];
            
            NSArray *arr = [[self.dataBase objectAtIndex:i] objectForKey:@"cities"];
            NSMutableArray *array = [NSMutableArray array];
            for (int j=0; j<arr.count; j++)
            {
                [array addObject:@"0"];
            }
            
            [self.isSelectArr addObject:array];
        }
        
        NSLog(@"%@",self.isSelectArr);
        
        
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _dataSource;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    for(NSString *character in _dataSource)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}


//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_dataSource count];
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_dataSource objectAtIndex:section];
}

//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.dataBase objectAtIndex:section] objectForKey:@"cities"] count];
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
    
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, 17, 18, 18)];
    selectImage.tag = indexPath.row+1000+10*indexPath.section;
    if([[[self.isSelectArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        selectImage.image = [UIImage imageNamed:@"圈icon"];
    }
    else
    {
        selectImage.image = [UIImage imageNamed:@"对号icon"];
    }
    [cell.contentView addSubview:selectImage];
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(selectImage.right+10, 5, 45, 45)];
    headerImage.backgroundColor = [UIColor orangeColor];
    headerImage.layer.cornerRadius = headerImage.width/2;
    [cell.contentView addSubview:headerImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+10, 17, 170, 20)];
    nameLab.text = [[[[self.dataBase objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    nameLab.font = [UIFont fontWithName:@"youyuan" size:14];
    [cell.contentView addSubview:nameLab];
    
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:indexPath.row+1000+10*indexPath.section];
    
    NSString *str = [[self.isSelectArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"0"])
    {
        [[self.isSelectArr objectAtIndex:indexPath.section] setObject:@"1" atIndexedSubscript:indexPath.row];
        img.image = [UIImage imageNamed:@"对号icon"];
    }
    else
    {
        img.image = [UIImage imageNamed:@"圈icon"];

        [[self.isSelectArr objectAtIndex:indexPath.section] setObject:@"0" atIndexedSubscript:indexPath.row];
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
    
}

@end
