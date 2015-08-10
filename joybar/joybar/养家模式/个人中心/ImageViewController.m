//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "BuyerFilterViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
@interface ImageViewController ()<BuyerFilterDelgeate>
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong ,nonatomic) UIImage *imageNew;
@property (strong ,nonatomic)UIView *hideView;
@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.image = image;
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
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    设置image的尺寸
    CGSize imagesize = _imageNew.size;
    imagesize.height =kScreenWidth;
    imagesize.width =kScreenWidth;
    //对图片大小进行压缩--
    _imageNew = [self imageCompressForSize:self.image targetSize:imagesize];
    
    self.view.backgroundColor =[UIColor blackColor];
    self.imageView=[[UIImageView alloc]initWithImage:self.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    CGFloat hideViewH =kScreenHeight-64-70-kScreenWidth;
    _hideView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenWidth+64, kScreenWidth, hideViewH)];
    _hideView.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
    [self.view addSubview:_hideView];
    
    UIView *hview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    
    hview.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.6];
    [self.view addSubview:hview];
    
    CGFloat btnY =  (kScreenHeight-70);
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10, btnY, 70, 70)];
    [btn setTitle:@"重拍" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    
    
     UIButton *btn1= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, btnY, 80, 70)];
    [btn1 setTitle:@"使用照片" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.imageView.frame = self.view.contentBounds;
    self.hideView.frame =CGRectMake(0, kScreenWidth+64, kScreenWidth, kScreenHeight-64-70-kScreenWidth);

}

-(void)btnClick{
    
    [self.delegate dismissCamrea:nil andDataArray:nil];
}

- (void)btn1Click
{
    NSString * ctype =[Common getUserDefaultKeyName:@"backPhone"];
     //如果选择，关闭相机。传代理，不选择，跳到下一个
    if ([ctype isEqualToString:@"1"]||[ctype isEqualToString:@"3"] ) {
        
        BuyerFilterViewController *issue=[[BuyerFilterViewController alloc]initWithImg:_imageNew];
        issue.delegate =self;
        [self.navigationController pushViewController:issue animated:YES];
    }else{
        
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:andDataArray:)]) {
            [self.delegate dismissCamrea:_imageNew andDataArray:nil];
        }
    }
}

-(void)choose:(UIImage *)image andImgs:(NSMutableDictionary *)array
{
    NSString *back =[Common getUserDefaultKeyName:@"backPhone"];
    if (![back isEqualToString:@"1"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:andDataArray:)]) {
            [self.delegate dismissCamrea:image andDataArray:array];
        }
    }
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
