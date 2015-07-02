//
//  CusAttentionViewController.m
//  joybar
//
//  Created by 123 on 15/5/12.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusAttentionViewController.h"
#import "CusFansTableViewCell.h"
#import "BaseTableView.h"
#import "FansItems.h"
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface CusAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) BaseTableView *tableView;

@property (nonatomic ,strong) NSMutableArray *btnArr;
@property (nonatomic ,strong) NSMutableArray *labArr;

@property (nonatomic ,strong) NSMutableArray *attentionArr;
@property (nonatomic ,assign) NSInteger pageNum;



@end

@implementation CusAttentionViewController
{
    UIImageView *selectImageView;
    FansItems *fansItems;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attentionArr = [NSMutableArray array];
    self.view.backgroundColor = kCustomColor(243, 247, 248);
    
    self.btnArr = [NSMutableArray array];
    self.labArr = [NSMutableArray array];
    
    [self addNavBarViewAndTitle:@"关注"];
    
//    UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    titleBtn.center = CGPointMake(kScreenWidth/2, 64/2+10);
//    titleBtn.bounds = CGRectMake(0, 0, 60, 20);
//    [titleBtn setTitle:@"全部关注" forState:(UIControlStateNormal)];
//    titleBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:15];
//    [titleBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    [titleBtn addTarget:self action:@selector(didClickTitleBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.navView addSubview:titleBtn];
//    
//    UIImageView *jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(titleBtn.right+3, titleBtn.top+5, 12, 12)];
//    jiantouImage.image = [UIImage imageNamed:@"展开"];
//    [self.navView addSubview:jiantouImage];
//    
//    [self addSearchBar];
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak CusAttentionViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        [VC.attentionArr removeAllObjects];
        VC.pageNum = 1;
        [VC getData];

    };
    self.tableView.footerRereshingBlock =^()
    {
        VC.pageNum++;
        [VC getData];

    };
    
    [self getData];
//    [self addSelectImage];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    [dic setValue:@"0" forKey:@"status"];
    [self hudShow];
    [HttpTool postWithURL:@"User/GetUserFavoite" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            fansItems = [FansItems objectWithKeyValues:[json objectForKey:@"data"]];
            
            if (fansItems.items.count<6)
            {
                [self.tableView hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
            }
            [self.attentionArr addObjectsFromArray:fansItems.items];
            [self.tableView reloadData];
            [self.tableView endRefresh];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self hiddleHud];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addSelectImage
{
    selectImageView = [[UIImageView alloc] init];
    selectImageView.center = CGPointMake(kScreenWidth/2, 137);
    selectImageView.bounds = CGRectMake(0, 0, 150, 170);
    selectImageView.image = [UIImage imageNamed:@"展开页"];
    selectImageView.hidden = YES;
    selectImageView.alpha = 0;
    selectImageView.userInteractionEnabled = YES;
    [self.view addSubview:selectImageView];
    
    NSArray *arr = @[@"全部关注",@"好友",@"专柜买手",@"认证买手",@"达人",@"其他"];
    NSArray *labArr = @[@"123",@"345",@"123",@"123",@"123",@"123"];
    for (int i=0; i<6; i++)
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 160/6*i+14, 170, 160/6);
        [button setTitle:[arr objectAtIndex:i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont fontWithName:@"youyuan" size:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(didCLickSelectBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = 1000+i;
        [selectImageView addSubview:button];
        [self.btnArr addObject:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(170-85, 160/6*i+14, 60, 160/6)];
        label.text = [NSString stringWithFormat:@"(%@)",[labArr objectAtIndex:i]];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"youyuan" size:15];
        label.tag = 100+i;
        [selectImageView addSubview:label];
        [self.labArr addObject:label];
        
        if(i==0)
        {
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
            label.textColor = [UIColor orangeColor];
        }
    }
}
-(void)addSearchBar
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5+64, kScreenWidth, 0.5)];
    line.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:line];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.center = CGPointMake(kScreenWidth/2, 64+20);
    bgView.bounds = CGRectMake(0, 0, kScreenWidth-60, 30);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"search.png"];
    [bgView addSubview:imageView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right+5, 0, bgView.width-imageView.width, 30)];
    textField.placeholder = @"请输您要找的人";
    textField.font = [UIFont fontWithName:@"youyuan" size:15];
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    [bgView addSubview:textField];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attentionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    CusFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[CusFansTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FansModel *fan = [fansItems.items objectAtIndex:indexPath.row];
    [cell setData:fan];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)didClickTitleBtn:(UIButton *)btn
{
    
    if (selectImageView.hidden == YES)
    {
        [UIView animateWithDuration:0.4 animations:^{
            selectImageView.hidden = NO;

            selectImageView.alpha = 1;

        } completion:^(BOOL finished) {

        }];

    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            selectImageView.alpha =0 ;
        } completion:^(BOOL finished) {
            selectImageView.hidden = YES;
        }];

    }
}

-(void)didCLickSelectBtn:(UIButton *)btn
{
    UILabel *selectLab = (UILabel *)[selectImageView viewWithTag:btn.tag-1000+100];
    
    for (UILabel *label in self.labArr)
    {
        if (label==selectLab)
        {
            label.textColor = [UIColor orangeColor];
        }
        else
        {
            label.textColor = [UIColor whiteColor];
        }
    }
    
    for (UIButton *button in self.btnArr)
    {
        if (button==btn)
        {
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [ resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //搜索
    return YES;
}

@end
