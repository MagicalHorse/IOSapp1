//
//  BuyerTagViewController.m
//  joybar
//
//  Created by joybar on 15/6/19.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerTagViewController.h"

@interface BuyerTagViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *cTableView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation BuyerTagViewController
-(NSMutableArray *)dataArray{
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kCustomColor(231, 231, 231);
    [self addNavBarViewAndTitle:@"添加标签"];
    self.retBtn.hidden =YES;
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(kScreenWidth-64, 10, 64, 64);
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn setTitleColor :[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:searchBtn];
    
    //textNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:self.tagTextField];

}

-(void)textFiledEditChanged:(NSNotification *)tagText{
    UITextField *textField = (UITextField *)tagText.object;
    [self setData:textField.text];
}

-(void)setData:(NSString *)name{

    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    if (self.cType ==1) {
        [dict setObject:@"0" forKey:@"type"];
    }else{
        [dict setObject:@"1" forKey:@"type"];
    }
    [dict setObject:name forKey:@"name"];

    [HttpTool postWithURL:@"Product/GetProductTag" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            self.dataArray =[json objectForKey:@"data"];
            [self.cTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)searchBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell= [[UITableViewCell alloc]init];
    if (self.dataArray.count>0) {
        cell.textLabel.text = [self.dataArray[indexPath.row]objectForKey:@"Name"];
    }
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length==0) {
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedTag:AndPoint:AndSourceId:AndSourceType:)]) {
        [self.delegate didSelectedTag:textField.text AndPoint:self.cpoint AndSourceId:@"0" AndSourceType:@"50"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text =[self.dataArray[indexPath.row]objectForKey:@"Name"];
    NSString *Id =[[self.dataArray[indexPath.row]objectForKey:@"Id"]stringValue];

    if ([self.delegate respondsToSelector:@selector(didSelectedTag:AndPoint:AndSourceId:AndSourceType:)]) {
        [self.delegate didSelectedTag:text AndPoint:self.cpoint AndSourceId:Id AndSourceType:@"51"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
