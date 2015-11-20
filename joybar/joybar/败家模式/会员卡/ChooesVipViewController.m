//
//  ChooesVipViewController.m
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "ChooesVipViewController.h"

@interface ChooesVipViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak ,nonatomic)IBOutlet UITableView *cusTableView;
@end

@implementation ChooesVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"选择优惠券"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 10;
    }else {
        return 0.5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0 ||section==2) {
        return 50;
    }
    return 9.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString * title;
    if (section ==0) {
        title =@"可使用店内优惠券";
    }else{
        title =@"可使用增值券本金";

    }
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth-30, 30)];
    label.text =title;
    [view addSubview:label];
    if (section==0 ||section==2) {
        return view;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0)
    {
        static NSString *iden = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = @"VIP折扣";
        lab.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-215, 15, 200, 20)];
        lab1.textAlignment = NSTextAlignmentRight;
        lab1.text =@"￥0.00";
        [cell.contentView addSubview:lab1];
        
        return cell;
    }else {
        static NSString *iden = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (indexPath.row ==0) {
            UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
            btn.backgroundColor =[UIColor orangeColor];
            [cell.contentView addSubview:btn];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(btn.right+5, 12, 100, 20)];
            lab.textColor = [UIColor grayColor];
            lab.text = @"80.0000元";
            lab.adjustsFontSizeToFitWidth =YES;
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];

            
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-40, 15, 20, 20)];
            lab1.text = @"元";
            lab1.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab1];
            NSLog(@"%f",lab1.left);
            UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(lab.right, 5, lab1.left-lab1.width-lab.right, 35)];
            bgView.layer.borderColor = kCustomColor(195, 196, 197).CGColor;
            bgView.layer.borderWidth =1;
            bgView.layer.cornerRadius = 2;
            [cell.contentView addSubview:bgView];
            
            UITextField *textField= [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 170, 35)];
            textField.placeholder =@"输入使用金额";
            textField.font =[UIFont systemFontOfSize:15];
            [bgView addSubview:textField];
            
        }else{
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 20)];
            lab.textColor = [UIColor grayColor];
            lab.text = @"7月12日到期-满200送20女鞋活动";
            lab.adjustsFontSizeToFitWidth=YES;
            lab.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:lab];
        }
        
        
        
        return cell;

    }
    return nil;
}
@end
