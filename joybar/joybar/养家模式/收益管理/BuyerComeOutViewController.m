//
//  BuyerComeOutViewController.m
//  joybar
//
//  Created by joybar on 15/6/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerComeOutViewController.h"
#import "BuyerComeInSubmitViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface BuyerComeOutViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic ,strong)UIView *bgView;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong)UIButton *cancleBtn;
@property (nonatomic ,strong) UIImageView *codeImage;

@end

@implementation BuyerComeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kCustomColor(241, 241, 241);
    NSString *temp;
    if (self.price.length>0) {
        temp =self.price;
    }else{
        self.price =@"0.00";
    }
    self.priceLable.text = [NSString stringWithFormat:@"可提现的收益%@元",temp];
    [self addNavBarViewAndTitle:@"申请提现"];
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if (self.priceField.text.length==0) {
        [self showHudFailed:@"请输入金额"];
        return;
    }
    [self hudShow:@"正在提取"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.priceField.text forKey:@"Amount"];
    [HttpTool postWithURL:@"Assistant/Income_Request_RedPack" params:dict isWrite:YES success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            
            BuyerComeInSubmitViewController * sb=[[BuyerComeInSubmitViewController alloc]init];
            [self.navigationController pushViewController:sb animated:YES];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
        
    } failure:^(NSError *error) {
        [self textHUDHiddle];
        [self showHudFailed:@"服务器异常,请稍后再试"];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.priceField resignFirstResponder];
}
@end
