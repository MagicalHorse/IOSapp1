//
//  BuyerTagViewController.m
//  joybar
//
//  Created by joybar on 15/6/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTagViewController.h"

@interface BuyerTagViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation BuyerTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kCustomColor(231, 231, 231);
    [self addNavBarViewAndTitle:@"添加标签"];
    self.retBtn.hidden =YES;
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-64, 10, 64, 64);
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font =[UIFont fontWithName:@"youyuan" size:15];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
}
-(void)searchBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell= [[UITableViewCell alloc]init];
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length==0) {
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedTag:AndPoint:)]) {
        [self.delegate didSelectedTag:textField.text AndPoint:self.cpoint];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}



@end
