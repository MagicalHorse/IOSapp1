//
//  BueryAuthViewController.m
//  joybar
//
//  Created by joybar on 15/5/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BueryAuthViewController.h"
#import "BueryAuthInfoViewController.h"
#import "BuyerCameraViewController.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"

@interface BueryAuthViewController ()<UIScrollViewDelegate,BuyerCameraDelgeate,UITextFieldDelegate>{
    OSSData *osData;
}
@property (nonatomic,strong)UIScrollView *customScrollView;
@property (nonatomic,strong)UIButton * customButton;
@property (nonatomic,strong)UIButton * btn1;

@property (nonatomic,strong)UIButton * btn2;
@property (nonatomic,strong)UIButton * btn3;
@property (nonatomic,strong)UITextField *nField;
@end

@implementation BueryAuthViewController
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
    [self addNavBarViewAndTitle:@"身份材料认证"];
    [self settingView];
    [self aliyunSet];
    [Common saveUserDefault:@"2" keyName:@"backPhone"];

    
}
-(void)aliyunSet{
    OSSClient *ossclient = [OSSClient sharedInstanceManage];
    [ossclient setGlobalDefaultBucketHostId:AlyBucketHostId];
    [ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:AlySecretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", AlyAccessKey, signature];
        NSLog(@"here signature:%@", signature);
        return signature;
    }];
}

- (void)settingView {
    CGFloat scX =0;
    CGFloat scY =64;
    CGFloat scW = kScreenWidth;
    CGFloat scH = kScreenHeight -scY-50;
    
    _customScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(scX, scY, scW, scH)];
    [self.view addSubview:_customScrollView];
    _customScrollView.delegate =self;
    
    UIView *nameView =[[UIView alloc]initWithFrame:CGRectMake(0, 10, scW, 44)];
    [_customScrollView addSubview:nameView];
    
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 19, 19)];
    image.image =[UIImage imageNamed:@"重点"];
    [nameView addSubview:image];
    
    UILabel *nlable =[[UILabel alloc]initWithFrame:CGRectMake(image.right+2, 10, 80, 24)];
    nlable.text =@"您的姓名:";
    nlable.font = [UIFont fontWithName:@"youyuan" size:17];
    [nameView addSubview:nlable];
     
     _nField= [[UITextField alloc]initWithFrame:CGRectMake(nlable.right+3, 10, kScreenWidth-120-19, 24)];
    _nField.delegate =self;
     _nField.placeholder =@"请输入";
     _nField.font =[UIFont fontWithName:@"youyuan" size:17];
    [nameView addSubview:_nField];
    
    UIView * nview = [[UIView alloc]initWithFrame:CGRectMake(20, _nField.bottom+10, kScreenWidth-40, 1)];
    nview.backgroundColor = kCustomColor(241, 241, 241);
    [nameView addSubview:nview];
    
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(20, nameView.bottom+20, 200, 20)];
    lable.text =@"身份证/护照";
    lable.font = [UIFont fontWithName:@"youyuan" size:18];
    [_customScrollView addSubview:lable];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 50+64, kScreenWidth-40, 1)];
    view.backgroundColor = kCustomColor(241, 241, 241);
    [_customScrollView addSubview:view];
    
    _btn1=[[UIButton alloc]initWithFrame:CGRectMake(20, 61+64, kScreenWidth-40, 200)];
    [_btn1 setTitle:@"＋正面" forState:UIControlStateNormal];
    _btn1.titleLabel.font =[UIFont fontWithName:@"youyuan" size:18];
    [_btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btn1.layer.borderWidth= 2;
    _btn1.layer.borderColor = kCustomColor(169, 200, 234).CGColor;
    [_btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [_customScrollView addSubview:_btn1];
    
    _btn2=[[UIButton alloc]initWithFrame:CGRectMake(20, 271+64, kScreenWidth-40, 200)];
    [_btn2 setTitle:@"＋反面" forState:UIControlStateNormal];
    _btn2.titleLabel.font =[UIFont fontWithName:@"youyuan" size:18];
    [_btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];

    _btn2.layer.borderWidth= 2;
    _btn2.layer.borderColor = kCustomColor(169, 200, 234).CGColor;
    [_customScrollView addSubview:_btn2];
    
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 491+64, kScreenWidth, 10)];
    bgView.backgroundColor =kCustomColor(241, 241, 241);
    [_customScrollView addSubview:bgView];

    UILabel * lableStore=[[UILabel alloc]initWithFrame:CGRectMake(20, 521+64, 200, 20)];
    lableStore.text =@"工牌照片";
    
    lableStore.font = [UIFont fontWithName:@"youyuan" size:18];
    [_customScrollView addSubview:lableStore];

    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 551+64, kScreenWidth-40, 1)];
    view1.backgroundColor = kCustomColor(241, 241, 241);
    [_customScrollView addSubview:view1];

    
    _btn3=[[UIButton alloc]initWithFrame:CGRectMake(20, 562+64, kScreenWidth-40, 200)];
    [_btn3 setTitle:@"＋工牌照片" forState:UIControlStateNormal];
    _btn3.titleLabel.font =[UIFont fontWithName:@"youyuan" size:18];
    [_btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btn3.layer.borderWidth= 2;
    _btn3.layer.borderColor = kCustomColor(169, 200, 234).CGColor;
    [_btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];

    [_customScrollView addSubview:_btn3];

    UIView *bgView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 782+64, kScreenWidth, 10)];
    bgView1.backgroundColor =kCustomColor(241, 241, 241);
    [_customScrollView addSubview:bgView1];

    
    
    
    _customButton =[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    _customButton.backgroundColor =kCustomColor(249, 249, 249);
    [self.view addSubview:_customButton];
    [_customButton addTarget:self action:@selector(customBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_customButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_customButton setTitleColor:kCustomColor(56,155, 234) forState:UIControlStateNormal];
    _customButton.titleLabel.font = [UIFont fontWithName:@"youyuan" size:17];
    
    
    _customScrollView.contentSize =CGSizeMake(0, 792+64);
    _customScrollView.bounces =NO;


}
-(void)customBtnClick{
    
    if (self.btn1.imageView.image==nil ||self.btn2.imageView.image ==nil||self.btn3.imageView.image ==nil ||self.nField.text.length ==0) {
        [self showHudFailed:@"请填写名称，及上传图片"];
        return;
    }
    BueryAuthInfoViewController * finish =[[BueryAuthInfoViewController alloc]initWithImgNames:[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png", nil]];
    finish.textName =self.nField.text;
    [self.navigationController pushViewController:finish animated:YES];
    
}
-(void)btn1Click{
    BuyerCameraViewController * camera= [[BuyerCameraViewController alloc]initWithType:1];
    camera.delegate =self;
    [self presentViewController:camera animated:YES completion:nil];
}
-(void)btn2Click{
    BuyerCameraViewController * camera= [[BuyerCameraViewController alloc]initWithType:2];
    camera.delegate =self;
    [self presentViewController:camera animated:YES completion:nil];
}
-(void)btn3Click{
    BuyerCameraViewController * camera= [[BuyerCameraViewController alloc]initWithType:3];
    camera.delegate =self;
    [self presentViewController:camera animated:YES completion:nil];
}

//-(void)addBtnBg:(CGRect)rect{
//    _btnBgview =[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, 100, rect.size.width, rect.size.height)];
//    _btnBgview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [self.view addSubview:_btnBgview];
//    _btnLable =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,_btnBgview.width , _btnBgview.height)];
//    _btnLable.font =[UIFont fontWithName:@"yoyuan" size:50];
//    _btnLable.textColor =[UIColor redColor];
//    [_btnBgview addSubview:_btnLable];
//   
//}

-(void)dismissCamrea:(UIImage *)image WithTag:(int)type{
    
    UIImage *imageNew =image;
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height =200;
    imagesize.width =kScreenWidth-40;
    
    //对图片大小进行压缩--
    imageNew = [self imageCompressForSize:imageNew targetSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(imageNew,1);
    
    if (type==1) {
        [self hudShow:@"正在上传..."];
        OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
        osData = [[OSSData alloc] initWithBucket:bucket withKey:@"1.png"];
        NSData *data = UIImagePNGRepresentation([UIImage imageWithData:imageData]);
        [osData setData:data withType:@"image/png"];
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                [self.btn1 setImage:imageNew forState:UIControlStateNormal];
                [self textHUDHiddle];
            }else{
                [self showHudFailed:@"上传失败"];
            }
            
        } withProgressCallback:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }else if(type ==2){
        [self hudShow:@"正在上传..."];
        OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
        osData = [[OSSData alloc] initWithBucket:bucket withKey:@"2.png"];
        NSData *data = UIImagePNGRepresentation([UIImage imageWithData:imageData]);
        [osData setData:data withType:@"image/png"];
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                [self.btn2 setImage:imageNew forState:UIControlStateNormal];
                [self textHUDHiddle];
            }else{
                [self showHudFailed:@"上传失败"];
            }
        } withProgressCallback:^(float progress) {
        }];
        
    }else if(type ==3){
        [self hudShow:@"正在上传..."];
        NSData *data = UIImagePNGRepresentation([UIImage imageWithData:imageData]);
        [osData setData:data withType:@"image/png"];
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                [self.btn3 setImage:imageNew forState:UIControlStateNormal];
                [self textHUDHiddle];
            }else{
                [self showHudFailed:@"上传失败"];
            }
        } withProgressCallback:^(float progress) {
            
            //NSLog(@"current get %f", progress);
        }];
    }

}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
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

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.nField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
