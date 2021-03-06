//
//  BuyerInComeViewController.m
//  joybar
//
//  Created by liyu on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerInComeViewController.h"
#import "ComeIn.h"
#import "UILabel+FlickerNumber.h"
#import "BuyerInComeDetailsViewController.h"
#import "BuyerComeOutViewController.h"
#import "BuyerComeInDscViewController.h"


@interface BuyerInComeViewController (){

    ComeIn * come;

}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *todayInComeLable;
@property (weak, nonatomic) IBOutlet UILabel *availAmountLable;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLable;
- (IBAction)btnClick;

- (IBAction)detailBtnClick:(UIButton *)sender;
- (IBAction)comeOutBtnClick:(UIButton *)sender;

@end

@implementation BuyerInComeViewController


-(BuyerInComeViewController *)initWithComeIn:(ComeIn *)comeIn{

    if (self = [super init]) {
        come=comeIn;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    [self.todayInComeLable dd_setNumber:@(come.today_income) formatter:nil];
    [self.totalAmountLable dd_setNumber:@(come.total_income) formatter:nil];
    self.availAmountLable.text = [@(come.avail_amout) stringValue] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"收益管理"];
    self.view.backgroundColor = kCustomColor(241, 241, 241);
}




- (IBAction)btnClick {
    
    BuyerInComeDetailsViewController * detail=[[BuyerInComeDetailsViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (IBAction)detailBtnClick:(UIButton *)sender {
    BuyerComeInDscViewController *dsc =[[BuyerComeInDscViewController alloc]init];
    
    [self.navigationController pushViewController:dsc animated:YES];

}

- (IBAction)comeOutBtnClick:(UIButton *)sender {
    
    BuyerComeOutViewController * comeOut=[[BuyerComeOutViewController alloc]init];
    [self.navigationController pushViewController:comeOut animated:YES];
}
@end
