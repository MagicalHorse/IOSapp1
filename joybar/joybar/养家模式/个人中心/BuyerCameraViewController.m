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
#import "BuyerIssueViewController.h"




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
    self.camera.view.frame = CGRectMake(0, 80, kScreenWidth, kScreenHeight-200);
    self.camera.fixOrientationAfterCapture = NO;
    
    // snap button to capture image
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-90, 70, 70)];
    [btn setImage:[UIImage imageNamed:@"shanchu1"] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _chooseBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, kScreenHeight-90, 70, 70)];
    [_chooseBtn setTitle:@"相册" forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:18];
    [_chooseBtn addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    

    
    self.snapButton = [[UIButton alloc]init];
    self.snapButton.frame = CGRectMake((kScreenWidth-70)*0.5, kScreenHeight-90, 70.0f, 70.0f);
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

-(void)closeBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
        [self.camera capture];
}

/* camera delegates */
- (void)cameraViewController:(LLSimpleCamera *)cameraVC didCaptureImage:(UIImage *)image
{
    UIImage *imageNew =image;
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height =kScreenHeight-200;
    imagesize.width =kScreenWidth;
    
    //对图片大小进行压缩--
    imageNew = [self imageCompressForSize:imageNew targetSize:imagesize];
    
    self.imageController = [[ImageViewController alloc] initWithImage:imageNew];
    self.imageController.delegate=self;
    [self.camera stop];
    
    NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
    if ([back isEqualToString:@"1"]) {
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
-(void)dismissCamrea:(UIImage *)image{
    [self dismissViewControllerAnimated:NO completion:nil];

    if (image !=nil) {
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:WithTag:)]) {
            [self.delegate dismissCamrea:image WithTag:btype];
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
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
//        [self.chooseBtn setImage:image forState:UIControlStateNormal];
        NSString *back= [Common getUserDefaultKeyName:@"backPhone"];
        if([back isEqualToString:@"1"]){
            [picker dismissViewControllerAnimated:NO completion:nil];

            [self.navigationController pushViewController:[[BuyerIssueViewController alloc]initWithImg:image] animated:NO];

        }else{
            [picker dismissViewControllerAnimated:NO completion:nil];
            [self dismissCamrea:image];

        }
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

@end
