//
//  MessageMoreView.m
//  FaceView
//
//  Created by Sundy on 14-4-5.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import "MessageMoreView.h"
#import "CusProLinkViewController.h"
//#import "PECropViewController.h"

@implementation MessageMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, kScreenHeight-164, kScreenWidth, 164);
    self.btnTitle = [NSMutableArray arrayWithObjects:@"拍照",@"照片",@"链接",@"收藏", nil];
    self.imageArray = [NSMutableArray arrayWithObjects:@"拍照icon",@"图片icon",@"链接icon",@"收藏icon", nil];
    //创建功能按钮
    [self _initWithView];
}

//创建功能按钮
- (void)_initWithView
{
    for (int i = 0; i<self.btnTitle.count; i++) {
//        CGRect frame;
//        int y = i%4;
//        int x = i/4;
//        frame.origin.x = ((kScreenWidth-53*4)/5)+y*53+((kScreenWidth-53*4)/5)*y + 50;
//        if(i ==1){
//            frame.origin.x = ((kScreenWidth-53*4)/5)+y*53+((kScreenWidth-53*4)/5)*y + 80;
//        }
//        frame.origin.y = (self.height-53*3)/3+x*53+x*5 + 10;
//        frame.size.width = 53;
//        frame.size.height = 53;
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:frame];
//        btn.tag = 2008+i;
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(73,-btn.imageView.size.width, 0.0,0.0)];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.titleLabel.height, 0.0,0.0, -btn.titleLabel.bounds.size.width+2)];
//        [btn setTitle:[self.btnTitle objectAtIndex:i] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:[self.imageArray objectAtIndex:i]] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//        [btn setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(kScreenWidth/4*i, 10, kScreenWidth/4, kScreenWidth/4);
        [btn setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:i]] forState:(UIControlStateNormal)];
        btn.tag =2008+i;
        [btn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.center = CGPointMake(btn.width/2, btn.width+5);
        lab.bounds = CGRectMake(0, 0, btn.width, 20);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [self.btnTitle objectAtIndex:i];
        lab.font = [UIFont fontWithName:@"youyuan" size:13];
        [btn addSubview:lab];
    }
}

#pragma mark - Action
- (void)moreBtnAction:(UIButton *)button
{
    NSInteger tag = button.tag - 2008;
    switch (tag) {
        case 0:
//            相册
            [self imagePickerViewController:@"1"];
            break;
        case 1:
//            拍照
            [self imagePickerViewController:@"0"];

            break;
        case 2:
//            链接
        {
            CusProLinkViewController *VC = [[CusProLinkViewController alloc] init];
            VC.titleStr = @"发送链接";
            [self.viewController.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
//            收藏
        {
            CusProLinkViewController *VC = [[CusProLinkViewController alloc] init];
            VC.titleStr = @"我的收藏";
            [self.viewController.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerViewController:(NSString *)type
{
    UIImagePickerControllerSourceType sourceType;
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    if ([type isEqualToString:@"0"])
    {
//    相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if([type isEqualToString:@"1"])
    {
//    拍照
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        BOOL isSource = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }else
        {
            if (isSource) {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
//                DLog(@"模拟器无法打开相机");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"模拟器无法打开相机" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
        }
    }
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self.viewController presentViewController:picker animated:YES completion:^{
        
    }];
}

//名片
- (void)initWithMyCardAction
{
    
}

//位置
- (void)initWithMyLocationAction
{
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    //使用第三方PE
//    [picker dismissViewControllerAnimated:NO completion:^{
//        PECropViewController *controller = [[PECropViewController alloc] init];
//        controller.delegate = self;
//        controller.image = image;
//        
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//        [self.viewController presentViewController:navigationController animated:NO completion:nil];
//    }];
    
    UIImage *selectImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(selectImg, 0.1);
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendImage" object:data];
}

//- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
//{
//    if ([self.messageMoreDelegate respondsToSelector:@selector(reCreatNewNotification)]) {
//        [self.messageMoreDelegate reCreatNewNotification];
//    }
//    [controller dismissViewControllerAnimated:YES completion:NULL];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendImage" object:croppedImage];
//}

//- (void)cropViewControllerDidCancel:(PECropViewController *)controller
//{
//    if ([self.messageMoreDelegate respondsToSelector:@selector(reCreatNewNotification)]) {
//        [self.messageMoreDelegate reCreatNewNotification];
//    }
//    [controller dismissViewControllerAnimated:YES completion:NULL];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self.messageMoreDelegate respondsToSelector:@selector(reCreatNewNotification)]) {
        [self.messageMoreDelegate reCreatNewNotification];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
