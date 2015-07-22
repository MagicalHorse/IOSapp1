//
//  BuyerCameraViewController.m
//  joybar
//
//  Created by joybar on 15/6/2.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerCameraViewController.h"
#import "LLSimpleCamera.h"
#import "ImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "BuyerFilterViewController.h"


@interface BuyerCameraViewController ()<LLSimpleCameraDelegate,CameraDelgeate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    int btype;
}
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong ,nonatomic) ImageViewController *imageController;
@property (strong ,nonatomic) UIButton * chooseBtn;
@end


@implementation BuyerCameraViewController
-(instancetype)initWithType:(int)type{
    if (self =[super init]) {
        btype =type;
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self.camera start];


}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto];
    [self.camera attachToViewController:self withDelegate:self];
    self.camera.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenWidth);
    self.camera.fixOrientationAfterCapture = NO;
    
    // snap button to capture image
    
    CGFloat btnY =  (kScreenWidth+64 +70);
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10,btnY, 70, 70)];
    [btn setImage:[UIImage imageNamed:@"shanchu1"] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _chooseBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80,btnY, 70, 70)];
    [_chooseBtn setTitle:@"相册" forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_chooseBtn addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    

    
    self.snapButton = [[UIButton alloc]init];
    self.snapButton.frame = CGRectMake((kScreenWidth-70)*0.5,btnY, 70.0f, 70.0f);
    [self.snapButton setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(10, 20, 16.0f + 20.0f, 24.0f + 20.0f);
    [self.flashButton setImage:[UIImage imageNamed:@"shanguang"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"shanguanghuang"] forState:UIControlStateSelected];
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(kScreenWidth-49, 20, 29.0f + 20.0f, 22.0f + 20.0f);
    [self.switchButton setImage:[UIImage imageNamed:@"xiangjibai"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
   
}
//关闭相机
-(void)closeBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//打开本地相册
-(void)chooseClick{
    [self LocalPhoto];
}



/* camera buttons */
- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}
- (void)flashButtonPressed:(UIButton *)button {
    
    CameraFlash flash = [self.camera toggleFlash];
    if(flash == CameraFlashOn) {
        self.flashButton.selected = YES;
    }
    else {
        self.flashButton.selected = NO;
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    button.userInteractionEnabled =NO;
    [self.camera capture];
}

/* camera delegates */
- (void)cameraViewController:(LLSimpleCamera *)cameraVC didCaptureImage:(UIImage *)image
{
    UIImage *imageNew =image;
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height=kScreenWidth;
    imagesize.width =kScreenWidth;
    //对图片大小进行压缩--
    imageNew = [self imageCompressForSize:imageNew targetSize:imagesize];
    self.imageController = [[ImageViewController alloc] initWithImage:imageNew];
    self.imageController.delegate=self;
    [self.camera stop];
    
    NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
    if ([back isEqualToString:@"1"] ||[back isEqualToString:@"3"]) {
        [self.navigationController pushViewController:self.imageController animated:NO];
    }else
    {
        [self presentViewController:self.imageController animated:NO completion:nil];
    }
   
}

- (void)cameraViewController:(LLSimpleCamera *)cameraVC didChangeDevice:(AVCaptureDevice *)device {
    
    // device changed, check if flash is available
    if(cameraVC.isFlashAvailable) {
        self.flashButton.hidden = NO;
    }
    else {
        self.flashButton.hidden = YES;
    }
    
    self.flashButton.selected = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)dismissCamrea:(UIImage *)image andDataArray:(NSMutableDictionary *)array{

    self.snapButton.userInteractionEnabled =YES;
    //如果有图片，把图片传回代理，没有则返回相机
    if (image !=nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:WithTag:AndDataArray:)]) {
            [self.delegate dismissCamrea:image WithTag:btype AndDataArray:array];
        }
    }else{
        NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
        if ([back isEqualToString:@"2"] ||[back isEqualToString:@"3"]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[picker navigationBar] setTintColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    picker.delegate = self;
    //设置选择后的图片可被编辑
    
    NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
    if ([back isEqualToString:@"2"]) {
        picker.allowsEditing = YES;
    }else{
        picker.allowsEditing = NO;
    }
    
    
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
        NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
        if([back isEqualToString:@"1"] ||[back isEqualToString:@"3"]){
            [picker dismissViewControllerAnimated:NO completion:nil];
            UIImage *imageNew =image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imagesize.height =kScreenWidth;
            imagesize.width =kScreenWidth;
            
            //对图片大小进行压缩--
            imageNew = [self imageCompressForSize:imageNew targetSize:imagesize];
            self.imageController = [[ImageViewController alloc] initWithImage:imageNew];
            self.imageController.delegate=self;
            [self.navigationController pushViewController:self.imageController animated:NO];

        }else{
            [picker dismissViewControllerAnimated:NO completion:nil];
            [self dismissCamrea:image andDataArray:nil];

        }
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.snapButton.userInteractionEnabled=YES;
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

@end
