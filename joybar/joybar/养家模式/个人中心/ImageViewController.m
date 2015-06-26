//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "BuyerFilterViewController.h"

@interface ImageViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;

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
    self.view.backgroundColor =[UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame =CGRectMake(0, 80, kScreenWidth, kScreenHeight-200);
    self.imageView.image =self.image;
    [self.view addSubview:self.imageView];
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-77, 70, 70)];
    [btn setTitle:@"重拍" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
    
     UIButton *btn1= [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, kScreenHeight-77, 80, 70)];
    [btn1 setTitle:@"使用照片" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:@"youyuan" size:18];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)btnClick{
    [self.delegate dismissCamrea:nil];
}

- (void)btn1Click
{
    NSString * ctype =[Common getUserDefaultKeyName:@"backPhone"];
    if ([ctype isEqualToString:@"1"]) {
        
        BuyerFilterViewController *issue=[[BuyerFilterViewController alloc]initWithImg:self.image];
        issue.imgTag =self.imgTag;
        [self.navigationController pushViewController:issue animated:NO];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(dismissCamrea:)]) {
            [self.delegate dismissCamrea:self.image];
        }
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

@end
