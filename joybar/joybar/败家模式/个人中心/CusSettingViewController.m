//
//  CusSettingViewController.m
//  joybar
//
//  Created by 123 on 15/5/6.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusSettingViewController.h"
#import "ChangePasswordViewController.h"
#import "BuyerOpenMessageViewController.h"
#import "CusAboutViewController.h"
#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "CusBindMobileViewController.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "APService.h"
@interface CusSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    OSSData *osData;
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic ,strong)UIImageView *headImageView;
@end

@implementation CusSettingViewController

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
    
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addNavBarViewAndTitle:@"设置"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindMoblieHandle) name:@"bindMobileNot" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bindMobileNot" object:self];
}


-(void)LoaclCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[picker navigationBar] setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[picker navigationBar] setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //设置image的尺寸
        CGSize imagesize = image.size;
        imagesize.height =57;
        imagesize.width =57;
        
        //对图片大小进行压缩--
        UIImage *imageNew = [self imageCompressForSize:image targetSize:imagesize];
        [picker dismissViewControllerAnimated:YES completion:^{
            self.headImageView.image=imageNew;
        }];
        //上传图片
        [self hudShow:@"正在上传"];
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMddHHmmsss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        NSString *temp=[NSString stringWithFormat:@"%@.png",locationString];
        OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
        osData = [[OSSData alloc] initWithBucket:bucket withKey:temp];
        NSData *data = UIImagePNGRepresentation(imageNew);
        [osData setData:data withType:@"image/png"];
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                
                NSMutableDictionary *dict= [NSMutableDictionary dictionary];
                [dict setObject:temp forKey:@"logo"];
                [HttpTool postWithURL:@"User/ChangeUserLogo" params:dict success:^(id json) {
                    BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
                    if (isSuccessful) {
                        NSString *logo= [[json objectForKey:@"data"]objectForKey:@"logo"];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
                        [dic setObject:logo forKey:@"logo"];
                        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                                          }else{
                        [self showHudFailed:@"上传失败"];
                    }
                    [self textHUDHiddle];
                    
                } failure:^(NSError *error) {
                    [self showHudFailed:@"上传失败"];
                    [self textHUDHiddle];
                }];
                [self textHUDHiddle];
            }else{
                [self textHUDHiddle];
                [self showHudFailed:@"上传失败"];
            }
        } withProgressCallback:^(float progress) {
            NSLog(@"%f",progress);
        }];
        
        
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
//table
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor =kCustomColor(245, 246, 247);
    
    if (section==3)
    {
        UIButton *exitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        exitBtn.frame = CGRectMake(20, 20, kScreenWidth-40, 40);
        [exitBtn setBackgroundColor:kCustomColor(253, 162, 41)];
        [exitBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        exitBtn.layer.cornerRadius = 4;
        [exitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [exitBtn addTarget:self action:@selector(didClickExitBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:exitBtn];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else if (section==3)
    {
        return 180;
    }
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3)
    {
        return 0;
    }
    else if (section==2)
    {
        return 1;
    }
    else if (section==1)
    {
        return 4;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell;
//    if (cell==nil)
//    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
//    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSArray *nameArr = @[@[@"头像",@"昵称"],@[@"账户密码",@"消息免打扰",@"手机号绑定",@"微信绑定"],@[@"关于我们"]];
    cell.textLabel.text = [[nameArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];

    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
           _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 15, 70, 70)];
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:[[Public getUserInfo] objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            _headImageView.clipsToBounds = YES;
            
            _headImageView.layer.cornerRadius = _headImageView.width/2;
            [cell.contentView addSubview:_headImageView];
        }
        else
        {
            _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240, 12.5, 200, 30)];
            _nameLab.textAlignment = NSTextAlignmentRight;
            _nameLab.text =[[Public getUserInfo] objectForKey:@"nickname"];
            _nameLab.font = [UIFont systemFontOfSize:16];
            _nameLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:_nameLab];
        }
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==1) {
            NSDictionary *dict=[Public getUserInfo];
            BOOL IsOpenPush =[[dict objectForKey:@"IsOpenPush"]boolValue];
            cell.accessoryType = UITableViewCellAccessoryNone;
            UISwitch *pSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-60, 13, 80, 50)];
            [pSwitch addTarget:self action:@selector(switchMethod:) forControlEvents:UIControlEventValueChanged];
            pSwitch.on =IsOpenPush;
            [cell.contentView addSubview:pSwitch];
        }
//        if (indexPath.row==2)
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 600)];
//            bgView.backgroundColor = kCustomColor(245, 246, 247);
//            [cell.contentView addSubview:bgView];
//        }
        
        if (indexPath.row==2)
        {
        
            UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17, 50, 20)];
            lab.text = @"已绑定";
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lab];
            if ([[[Public getUserInfo] objectForKey:@"IsBindMobile"] boolValue])
            {
                lab.hidden = NO;
            }
            else
            {
                lab.hidden = YES;
            }
        }
        else if (indexPath.row==3)
        {
            UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17, 50, 20)];
            lab.text = @"已绑定";
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lab];
            
            if ([[[Public getUserInfo] objectForKey:@"IsBindWeiXin"] boolValue])
            {
                lab.hidden = NO;
            }
            else
            {
                lab.hidden = YES;
            }
        }
    }
    return cell;
}

-(void)switchMethod :(UISwitch *)cusSwitch{
    BOOL isButtonOn = [cusSwitch isOn];
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    [dict setObject:@(isButtonOn) forKey:@"state"];
    [HttpTool postWithURL:@"User/ChangePushState" params:dict success:^(id json) {
        BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
        NSString *mssage= [json objectForKey:@"message"];
        if (isSuccessful) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
            [dic setObject:@(isButtonOn) forKey:@"IsOpenPush"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [self showHudFailed:mssage];
        }
        
    } failure:^(NSError *error) {
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 100;
    }
    else if (indexPath.section==3&&indexPath.row==2)
    {
        return 200;
    }
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 &&indexPath.row==0) {
        //修改头像
        UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照", @"从手机相册选择", nil];
        action.tag =101;
        
        [action showInView:self.view];
    
    }else if(indexPath.section ==0 &&indexPath.row==1)
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField *nameField = [alert textFieldAtIndex:0];
        nameField.text = self.nameLab.text;
        [alert show];
    }else if (indexPath.section==1&&indexPath.row==0)
    {
        ChangePasswordViewController *VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if(indexPath.section==1&&indexPath.row==1)
    {
        
//        BuyerOpenMessageViewController * message =[[BuyerOpenMessageViewController alloc]init];
//        [self.navigationController pushViewController:message animated:YES];

    }
    else if (indexPath.section==1&&indexPath.row==2)
    {
        if (![[[Public getUserInfo] objectForKey:@"IsBindMobile"] boolValue])
        {
           //手机号绑定
            CusBindMobileViewController *VC = [[CusBindMobileViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else if (indexPath.section==1&&indexPath.row==3)
    {
          //微信绑定
        if (![[[Public getUserInfo] objectForKey:@"IsBindWeiXin"] boolValue])
        {
            [self bindWX];
        }
    }
    else if(indexPath.section==0&&indexPath.row==0)
    {
        
    }else if(indexPath.section==0&&indexPath.row==1){
        
    }
    else if (indexPath.section==2)
    {
        CusAboutViewController *VC = [[CusAboutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

-(void)didClickExitBtn:(UIButton *)btn
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出" otherButtonTitles: nil];
    [action showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==101) {
        if (buttonIndex ==0) {
            [self LoaclCamera];
            
        }else if(buttonIndex ==1){
            [self LocalPhoto];
        }
        
    }else{
        if (buttonIndex==0)
        {
            //        [Public showLoginVC:self];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [APService setAlias:@"" callbackSelector:nil object:self];
            
            AppDelegate *ad= (AppDelegate *)[UIApplication sharedApplication].delegate;
            CusTabBarViewController *tab = [[CusTabBarViewController alloc] init];
            ad.window.rootViewController =tab;
        }
    }
}

//微信登陆
-(void)bindWX
{
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:nil];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            [self hudShow:@"正在绑定..."];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",snsAccount.accessToken,snsAccount.openId]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self WXLogin:str1];
            }];
            
        }
    });
}

-(void)WXLogin:(NSString *)str
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"json"];
    [dic setObject:APP_ID forKey:@"appid"];
    [HttpTool postWithURL:@"User/BindOutSideUser" params:dic success:^(id json) {
        
        [self textHUDHiddle];
        if([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
            [dic setObject:@"1" forKey:@"IsBindWeiXin"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self showHudSuccess:@"绑定成功"];
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    
}

-(void)bindMoblieHandle
{
    [self.tableView reloadData];
}
#pragma mark alertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        UITextField *nameField = [alertView textFieldAtIndex:0];
        if (nameField.text.length==0) {
            [self showHudFailed:@"请填写昵称"];
            return;
        }
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        [dict setObject:nameField.text forKey:@"nickname"];
        [HttpTool postWithURL:@"User/ChangeNickname" params:dict success:^(id json) {
            
            BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
            if (isSuccessful) {
                
                [self.tableView reloadData];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[Public getUserInfo]];
                [dic setObject:nameField.text forKey:@"nickname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                [self showHudFailed:@"修改失败"];
            }
           
        } failure:^(NSError *error) {
            
        }];
    }
    
}

@end
