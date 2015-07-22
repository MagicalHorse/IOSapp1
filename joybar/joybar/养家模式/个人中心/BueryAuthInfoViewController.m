//
//  BueryAuthInfoViewController.m
//  joybar
//
//  Created by joybar on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BueryAuthInfoViewController.h"
#import "BueryAuthFinishViewController.h"

@interface BueryAuthInfoViewController ()<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
    NSArray *imageNames;
    BOOL isUpdate;
}
@property (nonatomic,strong)UIScrollView *customScrollView;
@property (nonatomic,strong)UIButton * customButton;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSMutableArray *dataArray1;
@property (nonatomic,strong)NSMutableArray *dataArray2;
@property (nonatomic,strong)NSMutableArray *dataArray3;
@property (nonatomic,strong)NSMutableArray *dataArray4;


@property (nonatomic,strong)UILabel * cityLable;
@property (nonatomic,copy)NSMutableDictionary * cityText;
@property (nonatomic,copy)NSMutableDictionary * cityKey;
@property (nonatomic,strong)UILabel * field1;
@property (nonatomic,strong)UITextField * field2;
@property (nonatomic,strong)UITextField * field3;
@property (nonatomic,strong)UITextField * field4;
@property (nonatomic,strong)UITextView *dscText;

//pickerView
@property (strong ,nonatomic) UIView * topView;
@property (strong ,nonatomic) UIView * footView;


@end

@implementation BueryAuthInfoViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(instancetype)initWithImgNames:(NSArray *)arrayNames{
    if (self =[super init]) {
        imageNames =arrayNames;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"身份材料认证"];
    [self settingView];

    
}
-(NSMutableDictionary*)cityText{
    if (_cityText ==nil) {
        _cityText =[[NSMutableDictionary alloc]init];
    }
    return _cityText;
}
-(NSMutableDictionary*)cityKey{
    if (_cityKey ==nil) {
        _cityKey =[[NSMutableDictionary alloc]init];
    }
    return _cityKey;
}

-(NSMutableArray *)dataArray1{
    if (_dataArray1 ==nil) {
        _dataArray1 =[[NSMutableArray alloc]init];
    }
    return _dataArray1;
}
-(NSMutableArray *)dataArray2{
    if (_dataArray2 ==nil) {
        _dataArray2 =[[NSMutableArray alloc]init];
    }
    return _dataArray2;
}
-(NSMutableArray *)dataArray3{
    if (_dataArray3 ==nil) {
        _dataArray3 =[[NSMutableArray alloc]init];
    }
    return _dataArray3;
}
-(NSMutableArray *)dataArray4{
    if (_dataArray4 ==nil) {
        _dataArray4 =[[NSMutableArray alloc]init];
    }
    return _dataArray4;
}
-(void)setData1{
//    [self hudShow:@"正在加载中..."];
    [HttpTool postWithURL:@"Buyer/GetStoreList" params:nil success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            self.dataArray4 =[json objectForKey:@"data"];
            [self.pickerView reloadAllComponents];
        }else{
            [self showHudFailed:@"数据加载失败"];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setData:(NSString *)parentId WithType:(int)type{
//    [self hudShow:@"正在加载中..."];
    NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
    [dict setObject:parentId forKey:@"parentId"];
    [HttpTool postWithURL:@"Common/GetCityListByParentId" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            if (type==1) {
                self.dataArray1 =[json objectForKey:@"data"];
                [self setData: [[self.dataArray1 objectAtIndex:0] objectForKey:@"Id"] WithType:2];
                [self.cityKey setObject:[self.dataArray1[0] objectForKey:@"Id"] forKey:@"1"];


            }else if(type ==2){
                self.dataArray2 =[json objectForKey:@"data"];
                 [self setData: [[self.dataArray2 objectAtIndex:0] objectForKey:@"Id"] WithType:3];
                [self.pickerView reloadComponent:1];
                [self.cityKey setObject:[self.dataArray2[0] objectForKey:@"Id"] forKey:@"2"];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                
            }else if(type ==3){
                self.dataArray3 =[json objectForKey:@"data"];
                [self.cityKey setObject:[self.dataArray3[0] objectForKey:@"Id"] forKey:@"3"];

                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
            }

            [self.pickerView reloadAllComponents];
//            [self textHUDHiddle];
        }else{
            [self showHudFailed:@"数据加载失败"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

-(UIView *)bgView:(CGFloat)rectY
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, rectY, kScreenWidth-20, 1)];
    view.backgroundColor = kCustomColor(241, 241, 241);
    return view;
}
-(UIImageView *)bgImg:(CGFloat)rectY{
    UIImageView * img = [[UIImageView alloc]init] ;
    img.frame =CGRectMake(13, rectY, 19, 19);
    img.image =[UIImage imageNamed:@"重点"];
    return img;
}
-(UITextField *)customField :(CGFloat)rectY andPlaceholder:(NSString *)str{

    UITextField * field =[[UITextField alloc]initWithFrame:CGRectMake(35, rectY, kScreenWidth-35, 40)];
    field.delegate =self;
    field.placeholder=str;
    return field;
}

- (void)settingView {
    CGFloat scX =0;
    CGFloat scY =64;
    CGFloat scW = kScreenWidth;
    CGFloat scH = kScreenHeight -scY-50;
    _customScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(scX, scY, scW, scH)];
    [self.view addSubview:_customScrollView];
    _customScrollView.delegate =self;
    _customScrollView.backgroundColor =kCustomColor(241, 241, 241);
    
    UIView * storeInfo= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 163)];
    storeInfo.backgroundColor =[UIColor whiteColor];
    [_customScrollView addSubview:storeInfo];
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    lable.text =@"商场专柜信息";

    lable.font = [UIFont systemFontOfSize:16];
    [storeInfo addSubview:lable];
    
    UIView * view = [self bgView:lable.bottom+10];
    [storeInfo addSubview:view];
    

    _field1 = [[UILabel alloc]initWithFrame:CGRectMake( 35, view.bottom, kScreenWidth-60, 40)];
    _field1.text =@"商场名称";
    _field1.font =[UIFont systemFontOfSize:15];

    [storeInfo addSubview:_field1];
    storeInfo.tag =1000;
    [storeInfo addSubview:[self bgView:_field1.bottom]];
    [storeInfo addSubview:[self bgImg:view.bottom+12]];
    
    UIImageView *labelImg=[[UIImageView alloc]initWithFrame:CGRectMake(_field1.right, _field1.center.y-3, 12, 12)];
    labelImg.image =[UIImage imageNamed:@"展开"];
    [storeInfo addSubview:labelImg];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
    [storeInfo addGestureRecognizer:tap1];
    
    _field2 =[self customField:_field1.bottom+1 andPlaceholder:@"专柜名称"];

    _field2.font =[UIFont systemFontOfSize:15];

    [storeInfo addSubview:_field2];
    [storeInfo addSubview:[self bgView:_field2.bottom]];
    [storeInfo addSubview:[self bgImg:_field1.bottom+12]];

    
    _field3 =[self customField:_field2.bottom+1 andPlaceholder:@"专柜位置（楼层、区号）"];
    _field3.font =[UIFont systemFontOfSize:15];

    [storeInfo addSubview:_field3];
    [storeInfo addSubview:[self bgImg:_field2.bottom+12]];
    
    
    UIView *addressView= [[UIView alloc]initWithFrame:CGRectMake(0, _field3.bottom+15, kScreenWidth, 213)];
    addressView.backgroundColor =[UIColor whiteColor];
    [self.customScrollView addSubview:addressView];
    UILabel * lable1=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    lable1.text =@"商场自提点";
    lable1.font = [UIFont systemFontOfSize:16];
    [addressView addSubview:lable1];

   


        
    UIView * view1 = [self bgView:lable1.bottom+10];
    [addressView addSubview:view1];
    
    UIView * cityView=[[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom, kScreenWidth, 45)];
    [addressView addSubview:cityView];
    [cityView addSubview:[self bgImg:12]];
    
    _cityLable=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, kScreenWidth-100, 45)];
    _cityLable.font =[UIFont systemFontOfSize:15];
    _cityLable.text =@"省、市、区、县（请选择）";
    [cityView addSubview:_cityLable];
    cityView.tag =2000;
    UIImageView *cityImg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-24, 18, 12, 12)];
    cityImg.image =[UIImage imageNamed:@"展开"];
    
    [cityView addSubview:cityImg];
    [cityView addSubview:[self bgView:50]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
    [cityView addGestureRecognizer:tap];
    
    
    UIView *dscView =[[UIView alloc]initWithFrame:CGRectMake(20, addressView.height-100, kScreenWidth-40, 80)];
    dscView.layer.borderWidth= 1.5;
    dscView.layer.borderColor = kCustomColor(196, 194, 190).CGColor;

    UIImageView * img = [[UIImageView alloc]init] ;
    img.frame =CGRectMake(5, 5, 19, 19);
    img.image =[UIImage imageNamed:@"重点"];
    [dscView addSubview:img];
    
    _dscText=[[UITextView alloc]init];
    _dscText.delegate =self;
    _dscText.textColor =kCustomColor(194, 194, 200);
    _dscText.font =[UIFont systemFontOfSize:15];
    _dscText.frame =CGRectMake(img.right, 0, dscView.width-img.width-8, dscView.height-22);
    
    
    _dscText.text =@"详细地址（顾客支付后，到专柜提货的地址，请务必正确填写，否则会影响收款确认）";
    [dscView addSubview:_dscText];

    UILabel *zishu =[[UILabel alloc]initWithFrame:CGRectMake(10, dscView.height-20, dscView.width-18, 15)];
    zishu.textAlignment =NSTextAlignmentRight;
    zishu.text =@"30字";
    zishu.font =[UIFont systemFontOfSize:15];
    zishu.textColor =kCustomColor(194, 194, 200);
    [dscView addSubview:zishu];
    [addressView addSubview:dscView];

    
    _customButton =[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    _customButton.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_customButton];
    
    
    [_customButton addTarget:self action:@selector(customBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_customButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [_customButton setTitleColor:kCustomColor(56,155,234) forState:UIControlStateNormal];
    _customButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _customScrollView.contentSize =CGSizeMake(0, kScreenHeight-64);
    
}
-(void)didSelect:(UITapGestureRecognizer *)tag{
    
    [self resignText];

    isUpdate =NO;
    //添加_pickerView
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 250;
    CGFloat y =[UIScreen mainScreen].bounds.size.height-h;
    CGFloat x =0;
    self.footView=  [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    self.footView.backgroundColor=kCustomColor(241, 241, 241);
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w, [UIScreen mainScreen].bounds.size.height-h)];
    
    self.topView.backgroundColor = [UIColor colorWithRed:0  green:0 blue:0 alpha:0.2];
    [self.view addSubview: self.topView];
    [self.view addSubview:self.footView];
    self.footView.hidden =NO;
    self.topView.hidden=NO;
    
    CGFloat btnNOX =10;
    CGFloat btnNOY=10;
    CGFloat btnNOW =60;
    CGFloat btnNOH =30;
    UIButton *btnNO=   [[UIButton alloc]initWithFrame:CGRectMake(btnNOX, btnNOY, btnNOW, btnNOH)];
    [btnNO setTitle:@"取消" forState:UIControlStateNormal];
    btnNO.titleLabel.font =[UIFont systemFontOfSize:16];
    [btnNO setTitleColor:kCustomColor(56,155,234)forState:UIControlStateNormal];
    [btnNO addTarget:self action:@selector(btnNOCilck:) forControlEvents:UIControlEventTouchDown];
    [self.footView addSubview:btnNO];
    
    
    UIButton *btnYes=   [[UIButton alloc]initWithFrame:CGRectMake(w-btnNOW-5, btnNOY, btnNOW, btnNOH)];
    [btnYes setTitle:@"完成" forState:UIControlStateNormal];
    btnYes.titleLabel.font =[UIFont systemFontOfSize:16];
    [btnYes setTitleColor:kCustomColor(56,155,234) forState:UIControlStateNormal];

    [btnYes addTarget:self action:@selector(btnYesCilck:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.footView addSubview:btnYes];
    self.pickerView=  [[UIPickerView alloc]initWithFrame:CGRectMake(0, btnNOY+btnNOH, w, h-btnNOY-btnNOH)];
    self.pickerView.delegate=self;
    self.pickerView.dataSource = self;
    self.pickerView.tag =tag.view.tag;
    [self.footView addSubview:self.pickerView];
    if (tag.view.tag ==1000) {
        btnYes.tag =10;
        btnNO.tag =101;
        [self setData1];
    }else{
        btnYes.tag =20;
        btnNO.tag =201;
        [self setData:@"0" WithType:1];
    }
}


-(void)btnNOCilck:(UIButton *)btn
{
    self.footView.hidden =YES;
    self.topView.hidden=YES;
}
-(void)btnYesCilck:(UIButton *)btn
{
    self.footView.hidden =YES;
    self.topView.hidden=YES;
    if (btn.tag ==10) {
        if (!isUpdate) {
            self.field1.text =[self.dataArray4[0]objectForKey:@"StoreName"];
            self.field1.tag =[[self.dataArray4[0]objectForKey:@"StoreId"]intValue];
        }
    }else{
        
    }
}

-(void)customBtnClick{
    
    if (self.field2.text.length==0) {
        [self showHudFailed:@"请填写专柜名称"];
        return;
    }else if(self.field3.text.length==0){
        [self showHudFailed:@"请填写专柜位置"];
        return;
    }else if([self.field1.text isEqualToString:@"商场名称"]){
        [self showHudFailed:@"请选择商场名称"];
        return;
    }else if([self.dscText.text isEqualToString:@"详细地址（顾客支付后，到专柜提货的地址，请务必正确填写，否则会影响收款确认）"] ||self.dscText.text.length ==0){
        [self showHudFailed:@"请填写详细地址"];
        return;
    }else if([self.cityLable.text isEqualToString:@"省、市、区、县（请选择）"] ||self.cityLable.text.length ==0){
        [self showHudFailed:@"请选择商场自提点"];
        return;
    }
    [self hudShow:@"正在加载..."];
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    if ([self.cityKey objectForKey:@"1"]) {
        [dict setObject:[self.cityKey objectForKey:@"1"] forKey:@"ProvinceId"];
    }else{
        [dict setObject:[self.dataArray1[0] objectForKey:@"Id"] forKey:@"ProvinceId"];
    }
    if ([self.cityKey objectForKey:@"2"]) {
        [dict setObject:[self.cityKey objectForKey:@"2"] forKey:@"CityId"];
    }else{
        [dict setObject:[self.dataArray2[0] objectForKey:@"Id"] forKey:@"CityId"];
    }
    if ([self.cityKey objectForKey:@"3"]) {
        [dict setObject:[self.cityKey objectForKey:@"3"] forKey:@"DistrictId"];
    }else{
        [dict setObject:[self.dataArray3[0] objectForKey:@"Id"] forKey:@"DistrictId"];
    }
    [dict setObject:self.dscText.text forKey:@"Address"];
    [dict setObject:@(self.field1.tag)  forKey:@"StoreId"];
    [dict setObject:self.field1.text  forKey:@"StoreName"];
    [dict setObject:self.field2.text forKey:@"SectionName"];
    [dict setObject:self.field3.text forKey:@"SectionLocate"];
    [dict setObject:imageNames[0] forKey:@"WorkCard"];
    [dict setObject:imageNames[1]forKey:@"CardBack"];
    [dict setObject:imageNames[2] forKey:@"CardFront"];
    [dict setObject:self.textName forKey:@"Name"];

    [HttpTool postWithURL:@"Buyer/CreateAuthBuyer" params:dict success:^(id json) {
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
            [dic setObject:@"0" forKey:@"AuditStatus"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            BueryAuthFinishViewController * finish =[[BueryAuthFinishViewController alloc]init];
            [self.navigationController pushViewController:finish animated:YES];
        }else{
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
        [self showHudFailed:@"提交失败"];
    }];
    
   }

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag==1000) {
        return 1;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==1000) {
        
        return self.dataArray4.count;
        
    }else{
        if (component ==1) {
            return self.dataArray2.count;
        }else if (component==2) {
            return self.dataArray3.count;
        }else{
            return self.dataArray1.count;
        }
    }
   
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag ==1000) {
        return [self.dataArray4[row] objectForKey:@"StoreName"];
    }else{
        if (component ==1) {
            return [self.dataArray2[row] objectForKey:@"Name"];
        }else if(component==2){
            return [self.dataArray3[row] objectForKey:@"Name"];
        }else{
            return [self.dataArray1[row] objectForKey:@"Name"];
        }
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    isUpdate =YES;
    if (pickerView.tag ==1000) {
        self.field1.text =[self.dataArray4[row]objectForKey:@"StoreName"];
        self.field1.tag =[[self.dataArray4[row]objectForKey:@"StoreId"]intValue];
    }else{
        if (component==0) {
            [self.cityText setValue:[self.dataArray1[row] objectForKey:@"Name"] forKey:@"1"];
            [self.cityKey setValue:[self.dataArray1[row] objectForKey:@"Id"] forKey:@"1"];
            [self setData:[[self.dataArray1[row] objectForKey:@"Id"]stringValue] WithType:2];
            
        }else if(component ==1){
            
            [self.cityText setValue:[self.dataArray2[row] objectForKey:@"Name"] forKey:@"2"];
            [self.cityKey setValue:[self.dataArray2[row] objectForKey:@"Id"] forKey:@"2"];
            [self setData:[[self.dataArray2[row] objectForKey:@"Id"]stringValue] WithType:3];
            
        }else{
            [self.cityText setValue:[self.dataArray3[row] objectForKey:@"Name"] forKey:@"3"];
            [self.cityKey setValue:[self.dataArray3[row] objectForKey:@"Id"] forKey:@"3"];
            
            NSMutableString *temp =[[NSMutableString alloc]init];
            if ([self.cityText objectForKey:@"1"]) {
                [temp appendString:[self.cityText objectForKey:@"1"]];
            }else{
                [temp appendString:[self.dataArray1[0] objectForKey:@"Name"]];
            }
            if ([self.cityText objectForKey:@"2"]) {
                [temp appendString:[self.cityText objectForKey:@"2"]];
                
            }else{
                [temp appendString:[self.dataArray2[0] objectForKey:@"Name"]];
            }
            if ([self.cityText objectForKey:@"3"]) {
                [temp appendString:[self.cityText objectForKey:@"3"]];
                
            }else{
                [temp appendString:[self.dataArray3[0] objectForKey:@"Name"]];
            }
            _cityLable.text =temp;
            _cityText =nil;
        }
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.dscText.text=@"";

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self resignText];
}


-(void)resignText{
    [self.field1 resignFirstResponder];
    [self.field2 resignFirstResponder];
    [self.field3 resignFirstResponder];
    [self.field4 resignFirstResponder];
    if(self.dscText.text.length <1){
        _dscText.text =@"详细地址（顾客支付后，到专柜提货的地址，请务必正确填写，否则会影响收款确认）";
    }
    [self.dscText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = -120;
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
    
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}


@end
