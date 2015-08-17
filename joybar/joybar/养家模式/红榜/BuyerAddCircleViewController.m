//
//  BuyerAddCircleViewController.m
//  joybar
//
//  Created by joybar on 15/7/3.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerAddCircleViewController.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"

@interface BuyerAddCircleViewController ()<UIActionSheetDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    OSSData *osData;
}
@property (weak, nonatomic) IBOutlet UIButton *circleImg;
@property (weak, nonatomic) IBOutlet UITextField *circleField;
@property (nonatomic,strong)UIImage  *imageNew;
- (IBAction)circleClick:(UIButton *)sender;
- (IBAction)circleImgClick:(UIButton *)sender;

@end

@implementation BuyerAddCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"创建圈子"];
    self.view.backgroundColor =kCustomColor(231, 231, 231);
}
- (IBAction)circleClick:(UIButton *)sender {
    
   
    
    if (_imageNew==nil) {
        [self showHudFailed:@"请设置圈子头像"];
        return;
    }
    if (self.circleField.text.length==0) {
        [self showHudFailed:@"请填写圈子昵称"];
        return;
    }
    
    [self hudShow:@"正在创建"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmsss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *temp=[NSString stringWithFormat:@"%@.png",locationString];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
    osData = [[OSSData alloc] initWithBucket:bucket withKey:temp];
    NSData *data = UIImagePNGRepresentation(_imageNew);
    [osData setData:data withType:@"image/png"];
    [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSMutableDictionary *dict= [NSMutableDictionary dictionary];
            [dict setObject:self.circleField.text forKey:@"name"];
            [dict setObject:temp forKey:@"logo"];
            [HttpTool postWithURL:@"Community/CreateGroup" params:dict success:^(id json) {
                BOOL  isSuccessful =[[json objectForKey:@"isSuccessful"] boolValue];
                if (isSuccessful) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self showHudFailed:@"创建失败"];
                }
                [self textHUDHiddle];
                
            } failure:^(NSError *error) {
                [self showHudFailed:@"创建失败"];
                [self textHUDHiddle];
            }];
            [self textHUDHiddle];
        }else{
            [self textHUDHiddle];
            [self showHudFailed:@"创建失败"];
        }
    } withProgressCallback:^(float progress) {
//        NSLog(@"%f",progress);
    }];
    
  
    
}

- (IBAction)circleImgClick:(UIButton *)sender {
    UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    
    [action showInView:self.view];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
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
        _imageNew = [self imageCompressForSize:image targetSize:imagesize];
        [picker dismissViewControllerAnimated:YES completion:^{
        
            [self.circleImg setImage:_imageNew forState:UIControlStateNormal];
            self.circleImg .layer.cornerRadius = 57/2;
            self.circleImg.layer.masksToBounds = YES;
            self.circleImg.layer.borderWidth = 0.5;
            
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
//        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end
