//
//  CusCircleDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCircleDetailViewController.h"
#import "CusInviteFriendViewController.h"
#import "CircleDetailData.h"
#import "CircleDetailUser.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "CusHomeStoreViewController.h"
@interface CusCircleDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    OSSData *osData;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *tempView;

@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,strong) UIButton *cancleBtn;

@property (nonatomic ,assign) BOOL hiddenDeleteBtn;

@property (nonatomic ,assign) BOOL selectJianBtn;

//@property (nonatomic ,strong) NSMutableArray *userArr;

@property (nonatomic ,strong) CircleDetailData *circleData;
@end

@implementation CusCircleDetailViewController
{
    UILabel *circleNumLab;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 248);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    [self addNavBarViewAndTitle:@""];
    self.hiddenDeleteBtn=YES;
    self.selectJianBtn = NO;
    [self addTitleView];
    [self getCircleDetailData];

//    [self addBigView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)getCircleDetailData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.circleId forKey:@"groupid"];
    [self hudShow:@"获取圈子信息..."];
    [HttpTool postWithURL:@"Community/GetGroupDetail" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            self.circleData = [CircleDetailData objectWithKeyValues:[json objectForKey:@"data"]];
            circleNumLab.text = [NSString stringWithFormat:@"%@人",self.circleData.MemberCount];
            [self.tableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self textHUDHiddle];
    } failure:^(NSError *error) {
    }];
}

-(void)addTitleView
{
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.center = CGPointMake(kScreenWidth/2, 32);
    nameLab.bounds = CGRectMake(0, 0, 200, 20);
    nameLab.text = @"圈子信息";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:17];
    [self.navView addSubview:nameLab];
    
    circleNumLab = [[UILabel alloc] init];
    circleNumLab.center = CGPointMake(kScreenWidth/2, nameLab.bottom+10);
    circleNumLab.bounds = CGRectMake(0, 0, 100, 20);
    circleNumLab.textColor = [UIColor lightGrayColor];
    circleNumLab.font = [UIFont systemFontOfSize:12];
    circleNumLab.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:circleNumLab];
    
}
//
//-(void)addBigView
//{
//    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    _tempView.hidden = YES;
//    _tempView.alpha = 0;
//    _tempView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_tempView];
//    
//    _bgView = [[UIView alloc] init];
//    _bgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
//    _bgView.bounds = CGRectMake(0, 0, kScreenWidth-50, (kScreenWidth-50)*1.35);
//    _bgView.layer.cornerRadius = 4;
//    _bgView.backgroundColor = kCustomColor(245, 246, 247);
//    _bgView.hidden = YES;
//    _bgView.userInteractionEnabled = YES;
//    [self.view addSubview:_bgView];
//    
//    _cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    _cancleBtn.center = CGPointMake(kScreenWidth-25, _bgView.top);
//    _cancleBtn.bounds = CGRectMake(0, 0, 50, 50);
//    _cancleBtn.hidden = YES;
//    [_cancleBtn setImage:[UIImage imageNamed:@"叉icon"] forState:(UIControlStateNormal)];
//    [_cancleBtn addTarget:self action:@selector(didClickHiddenView:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:_cancleBtn];
//    
//    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
//    headerImage.backgroundColor = [UIColor orangeColor];
//    headerImage.layer.cornerRadius = headerImage.width/2;
//    [_bgView addSubview:headerImage];
//    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, headerImage.top+10, _bgView.width-100, 20)];
//    titleLab.text = @"啊实打实女包";
//    titleLab.font = [UIFont fontWithName:@"youyuan" size:16];
//    [_bgView addSubview:titleLab];
//    
//    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+5, titleLab.bottom+2, _bgView.width-100, 20)];
//    numLab.text = @"成员: 123123人";
//    numLab.font = [UIFont fontWithName:@"youyuan" size:14];
//    numLab.textColor = [UIColor darkGrayColor];
//    [_bgView addSubview:numLab];
//    
//    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, headerImage.bottom+10, _bgView.width-70, _bgView.width-70)];
//    codeImage.backgroundColor = [UIColor orangeColor];
//    [_bgView addSubview:codeImage];
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, codeImage.bottom+10, _bgView.width, 20)];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"点击分享给你的朋友吧";
//    lab.textColor = [UIColor grayColor];
//    lab.font = [UIFont fontWithName:@"youyuan" size:13];
//    [_bgView addSubview:lab];
//    
//    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    shareBtn.center = CGPointMake(_bgView.width/2, lab.bottom+20);
//    shareBtn.bounds = CGRectMake(0, 0, 80, 30);
//    [shareBtn setTitle:@"分享" forState:(UIControlStateNormal)];
//    [shareBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    shareBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
//    shareBtn.layer.cornerRadius = 3;
//    shareBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    shareBtn.layer.borderWidth = 0.5;
//    
//    [shareBtn addTarget:self action:@selector(didClickShareBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [_bgView addSubview:shareBtn];
//}



#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }

    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kCustomColor(245, 246, 247);
    if (section==0)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
        lab.text = @"圈子成员";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:15];
        [header addSubview:lab];
    }
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if (indexPath.section==0)
    {
        NSInteger count;
        if ([self.circleData.IsOwer boolValue])
        {
            count=self.circleData.Users.count+2;
        }
        else
        {
            count=self.circleData.Users.count;
        }
        for (int i=0; i<count; i++)
        {
            CGFloat width = (kScreenWidth-20)/4;
            CGFloat height = width+20;
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(i%4*width+10, i/4*height, width, height);
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(didClickHeaderImage:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.tag = 1000+i;
            [cell.contentView addSubview:btn];
            
            UIImageView *img = [[UIImageView alloc] init];
            img.center = CGPointMake(btn.width/2, btn.height/2-5);
            img.bounds = CGRectMake(0, 0, btn.width-12, btn.width-12);
            img.layer.cornerRadius = img.width/2;
            img.clipsToBounds = YES;
            [btn addSubview:img];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom, btn.width, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor darkGrayColor];
            lab.font = [UIFont systemFontOfSize:12];
            [btn addSubview:lab];
            
            if (i<self.circleData.Users.count)
            {
                img.userInteractionEnabled = YES;

                CircleDetailUser *circleUser = [self.circleData.Users objectAtIndex:i];
                [img sd_setImageWithURL:[NSURL URLWithString:circleUser.Logo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                lab.text = circleUser.NickName;
                img.tag = 1000+i;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickUserHeaderImage:)];
                [img addGestureRecognizer:tap];
                
                if (i>0)
                {
                    UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                    deleteBtn.frame = CGRectMake(img.width-18, 5, 27, 27);
                    deleteBtn.backgroundColor = [UIColor clearColor];
                    
                    [deleteBtn addTarget:self action:@selector(didClickDeleteUser:) forControlEvents:(UIControlEventTouchUpInside)];

                    if (self.hiddenDeleteBtn==YES)
                    {
                        deleteBtn.hidden = YES;
                    }
                    else
                    {
                        deleteBtn.hidden = NO;
                    }
                    [deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:(UIControlStateNormal)];
                    
                    deleteBtn.tag = 100+i;
                    [btn addSubview:deleteBtn];
                }

            }
            else
            {
                img.userInteractionEnabled = NO;

                if (i==self.circleData.Users.count+1)
                {
                    img.backgroundColor = [UIColor clearColor];
                    img.image = [UIImage imageNamed:@"jian"];
                    lab.text = @"删除好友";
                }
                else if (i==self.circleData.Users.count)
                {
                    img.backgroundColor = [UIColor clearColor];
                    img.image = [UIImage imageNamed:@"jia"];
                    lab.text = @"邀请好友";
                }
            }
        }
    }
    if (indexPath.section==1)
    {
        NSArray *arr = @[@"圈子名称",@"圈子头像"];
        if (indexPath.row<2)
        {
//            if (indexPath.row==0)
//            {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                
//                UIImageView *orCode = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-80, 5, 40, 40)];
//                orCode.backgroundColor = [UIColor orangeColor];
//                [cell.contentView addSubview:orCode];
//            }
            if (indexPath.row==0)
            {
                //圈子名称
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-210, 15, 200, 20)];
                lab.text = self.circleData.GroupName;
                lab.textColor = [UIColor grayColor];
                lab.font = [UIFont systemFontOfSize:14];
                lab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:lab];
            }
            if (indexPath.row==1)
            {
                UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
                NSString * temp =[NSString stringWithFormat:@"%@",self.circleData.GroupPic];
                headerImage.layer.cornerRadius = headerImage.width/2;
                headerImage.clipsToBounds =YES;
                [headerImage sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [cell.contentView addSubview:headerImage];
            }
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
            lab.text = [arr objectAtIndex:indexPath.row];
            lab.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:lab];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 1)];
            line.backgroundColor = kCustomColor(240, 240, 240);
            [cell.contentView addSubview:line];
        }
        else
        {
            cell.backgroundColor = kCustomColor(245, 246, 248);
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(15, 20, kScreenWidth-30, 50);
            btn.backgroundColor = kCustomColor(253, 162, 41);
            btn.layer.cornerRadius = 3;
            if (![self.circleData.IsMember boolValue])
            {
                [btn setTitle:@"加入圈子" forState:(UIControlStateNormal)];
            }
            else
            {
                if ([self.circleData.IsOwer boolValue])
                {
                    [btn setTitle:@"删除并退出" forState:(UIControlStateNormal)];
                }
                else
                {
                    [btn setTitle:@"退出圈子" forState:(UIControlStateNormal)];
                }
            }
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn addTarget:self action:@selector(didClickExitCircle:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:btn];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0&&indexPath.row==0)
    {
        if ([self.circleData.IsOwer boolValue])
        {
            if((self.circleData.Users.count+2)%4==0)
            {
                return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count+2)/4)+5;
            }
            else
            {
                return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count+2)/4+1)+5;
            }
        }

        if((self.circleData.Users.count)%4==0)
        {
            return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count)/4)+5;
        }
        else
        {
            return ((kScreenWidth-20)/4+20)*((self.circleData.Users.count)/4+1)+5;
        }
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==2)
        {
            return 90;
        }
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.circleData.IsOwer boolValue]) {
        if (indexPath.section==1&&indexPath.row==0) //修改圈子名称
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"修改圈子名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            UITextField *nameField = [alert textFieldAtIndex:0];
            nameField.text = self.circleData.GroupName;
            [alert show];

            
        }else if(indexPath.section ==1 &&indexPath.row ==1){//修改圈子头像
            UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            
            [action showInView:self.view];

        
        }

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        UITextField *nameField = [alertView textFieldAtIndex:0];
        if (nameField.text.length==0) {
            [self showHudFailed:@"请填写圈子名称"];
            return;
        }
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        [dict setObject:self.circleId forKey:@"groupid"];//圈子编号
        [dict setObject:nameField.text forKey:@"name"];//圈子名称

        [HttpTool postWithURL:@"Community/RenameGroup" params:dict isWrite:YES success:^(id json) {
            
            BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
            if (isSuccessful) {
                
                [self.tableView reloadData];
                self.circleData.GroupName =nameField.text;
                
            }else{
                [self showHudFailed:@"修改失败"];
            }
            
        } failure:^(NSError *error) {
            [self showHudFailed:@"服务器正在维护,请稍后再试"];
        }];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
        if (buttonIndex ==0) {
            [self LoaclCamera];
            
        }else if(buttonIndex ==1){
            [self LocalPhoto];
        }
    
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
                [dict setObject:self.circleId forKey:@"groupid"];
                [dict setObject:temp forKey:@"logo"];
                [HttpTool postWithURL:@"Community/ChangeGroupLogo" params:dict isWrite:YES success:^(id json) {
                    BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
                    if (isSuccessful) {
                        
                        NSString *logo= [[json objectForKey:@"data"]objectForKey:@"logo"];
                        self.circleData.GroupPic=logo;
                        [self.tableView reloadData];
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
//点叉
//-(void)didClickHiddenView:(UIButton *)btn
//{
//    
//    btn.hidden = YES;
//
//    _bgView.transform = CGAffineTransformMakeScale(1, 1);
//    
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         _bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//                         _bgView.alpha = 0.6;
//                     }completion:^(BOOL finish){
//                         _tempView.hidden = YES;
//                         _bgView.hidden = YES;
//                     }];
//
//}

//分享
-(void)didClickShareBtn
{
    
}

-(void)didClickHeaderImage:(UIButton *)btn
{
    
    //减
    if (btn.tag-1000==self.circleData.Users.count+1)
    {
        if (self.selectJianBtn ==NO)
        {
            self.hiddenDeleteBtn = NO;
            self.selectJianBtn = YES;
        }
        else
        {
            self.hiddenDeleteBtn = YES;
            self.selectJianBtn = NO;
        }
        
        [self.tableView reloadData];
    }
    
    //加
    if (btn.tag-1000==self.circleData.Users.count)
    {
        CusInviteFriendViewController *VC = [[CusInviteFriendViewController alloc] init];
        VC.circleId = self.circleId;
        [self.navigationController pushViewController:VC animated:YES];
    }

}

//删除圈子用户
-(void)didClickDeleteUser:(UIButton *)btn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.circleId forKey:@"groupid"];
    
    CircleDetailUser *user = [self.circleData.Users objectAtIndex:btn.tag-100];
    [dic setObject:user.UserId forKey:@"userid"];
    [self hudShow:@"正在删除"];
    [HttpTool postWithURL:@"Community/RemoveGroupMember" params:dic isWrite:YES success:^(id json) {
        
        [self textHUDHiddle];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            [self getCircleDetailData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self textHUDHiddle];
    }];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//退出圈子
-(void)didClickExitCircle:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"加入圈子"])
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.circleId forKey:@"groupid"];
        [HttpTool postWithURL:@"Community/JoinGroup" params:dic isWrite:YES success:^(id json) {
            if([[json objectForKey:@"isSuccessful"] boolValue])
            {
                [self getCircleDetailData];
            }
            else
            {
                [self showHudFailed:[json objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
        }];
    }else if([btn.titleLabel.text isEqualToString:@"删除并退出"])
    {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.circleId forKey:@"groupid"];
        [HttpTool postWithURL:@"Community/DeleteGroup" params:dic isWrite:YES success:^(id json) {
            
            if ([[json objectForKey:@"isSuccessful"] boolValue])
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else
            {
                [self showHudFailed:[json objectForKey:@"message"]];
            }
            [self textHUDHiddle];
            
        } failure:^(NSError *error) {
            
            [self textHUDHiddle];
            [self showHudFailed:@"请求失败"];
        }];
        
        
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.circleId forKey:@"groupid"];
        [HttpTool postWithURL:@"Community/ExitGroup" params:dic isWrite:YES success:^(id json) {
            if([[json objectForKey:@"isSuccessful"] boolValue])
            {
                [self getCircleDetailData];
            }
            else
            {
                [self showHudFailed:[json objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
        }];

    }
}

-(void)didClickUserHeaderImage:(UITapGestureRecognizer *)tap
{
    CircleDetailUser *user = [self.circleData.Users objectAtIndex:tap.view.tag-1000];
    CusHomeStoreViewController *VC = [[CusHomeStoreViewController alloc] init];
    VC.userId = user.UserId;
    VC.userName = user.NickName;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
