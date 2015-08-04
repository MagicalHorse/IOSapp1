//
//  BuyerFilterViewController.m
//  joybar
//
//  Created by joybar on 15/6/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerFilterViewController.h"
#import "BuyerIssueViewController.h"
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
#import "BuyerTagViewController.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "Tag.h"
#import "Image.h"


@interface BuyerFilterViewController ()<BuyerTagDelegate,UIActionSheetDelegate>
{
    UIImage *cImage;
    CGPoint tagPoint;
    OSSData *osData;
    Image *imgDic;
    int viweTag;
}
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *footerBtn;
@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)NSMutableDictionary *tagArray;
@property (nonatomic,strong)NSMutableArray *tagsArray;
@property (nonatomic,strong)NSString *tempImageName;
@property (nonatomic,strong)BuyerIssueViewController *issue;
@property (nonatomic ,strong)UIScrollView *customScrollView;
@property (nonatomic ,strong)UIImage* getNewImg1;
@property (nonatomic ,strong)UIImage* getNewImg2;
@property (nonatomic ,strong)UIImage* getNewImg3;
@property (nonatomic ,strong)UIImage* getNewImg4;

@end

@implementation BuyerFilterViewController


-(NSMutableArray *)tagsArray{
    if (_tagsArray ==nil) {
        _tagsArray =[[NSMutableArray alloc]init];
    }
    return _tagsArray;
}
-(NSMutableDictionary *)tagArray{
    if (_tagArray ==nil) {
        _tagArray =[[NSMutableDictionary alloc]init];
    }
    return _tagArray;
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
-(instancetype)initWithImg:(UIImage *)image{
    if (self =[super init]) {
        cImage=image;
    }
    return self;
}
-(instancetype)initWithImg:(UIImage *)image andImage :(Image *)dic{
    if (self =[super init]) {
        cImage=image;
        imgDic =dic;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    viweTag=0;
    [self addNavBarViewAndTitle:@"编辑图片"];
    [self setInitView];
}

-(void) setInitView{
    
    _customScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _customScrollView.backgroundColor =kCustomColor(241, 241, 241);
    [self.view addSubview:_customScrollView];
    if (kScreenHeight==480) {
        _customScrollView.contentSize =CGSizeMake(0, kScreenHeight+50);
    }
    
    UIView *titieView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieView.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
   
    _bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    _bgImage.image =cImage;

    if(self.imageDic){
        
        NSArray *tags =[self.imageDic objectForKey:@"Tags"];
        if (tags.count>0) {
            for (int i =0; i<tags.count; i++) {
                
                CGFloat x = [[tags[i]objectForKey:@"PosX"] floatValue];
                CGFloat y = [[tags[i]objectForKey:@"PosY"] floatValue];
                CGPoint point ={x*kScreenWidth,y*kScreenWidth};
                
                [self didSelectedTag:[tags[i]objectForKey:@"Name"] AndPoint:point AndSourceId:[tags[i]objectForKey:@"SourceId"] AndSourceType:[tags[i]objectForKey:@"SourceType"]];
            }
          
        }
    }
    if(imgDic){
        NSMutableArray *tags =imgDic.Tags;
        if (tags.count>0) {
            for (int i =0; i<tags.count; i++) {
                if (![[tags objectAtIndex:i] isKindOfClass:[Tag class]]){
                    CGFloat x = [[tags[i]objectForKey:@"PosX"] floatValue];
                    CGFloat y = [[tags[i]objectForKey:@"PosY"] floatValue];
                    CGPoint point ={x*kScreenWidth,y*kScreenWidth};
                    
                    [self didSelectedTag:[tags[i]objectForKey:@"Name"] AndPoint:point AndSourceId:[tags[i]objectForKey:@"SourceId"] AndSourceType:[tags[i]objectForKey:@"SourceType"]];
                    
                }else{
                    Tag *tag =tags[i];
                    CGFloat x = tag.PosX ;
                    CGFloat y = tag.PosY;
                    CGPoint point ={x*kScreenWidth,y*kScreenWidth};
                    [self didSelectedTag:tag.Name AndPoint:point AndSourceId:[tag.SourceId stringValue] AndSourceType:[tag.SourceType stringValue]];
                }
                
            }
        }
    }
    [_customScrollView addSubview:_bgImage];
    _bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [_bgImage addGestureRecognizer:tap];
    
    UILabel* titieLable= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieLable.font =[UIFont systemFontOfSize:17];
    titieLable.text =@"点击图片任意位置添加标签";
    titieLable.textColor =[UIColor whiteColor];
    titieLable.textAlignment = NSTextAlignmentCenter;
    [titieView addSubview:titieLable];
    [_customScrollView addSubview:titieView];
    
    UIScrollView * tzhiView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _bgImage.bottom, kScreenWidth, 110)];
    tzhiView.contentSize =CGSizeMake(390, 0);
    tzhiView.backgroundColor =[UIColor whiteColor];
    [_customScrollView addSubview:tzhiView];
    

    for (int i=0; i<5; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(60*i+15*(i+1), 15, 60, 60)];
        btn.tag =i+1;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tzhiView addSubview:btn];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(60*i+15*(i+1), btn.bottom+10, kScreenWidth/4-20, 13)];
        label.textAlignment=NSTextAlignmentCenter;
        switch (i) {
            case 0:
                label.text=@"原图";
                [btn setImage:cImage forState:UIControlStateNormal];
                break;
            case 1:
                label.text=@"诺曼底";
                [self getNewImg:cImage AndType:1];
                [btn setImage:self.getNewImg1 forState:UIControlStateNormal];
                break;
            case 2:
                label.text=@"流年";
                [self getNewImg:cImage AndType:2];
                [btn setImage:self.getNewImg2 forState:UIControlStateNormal];
                break;
            case 3:
                label.text=@"琥珀";
                [self getNewImg:cImage AndType:3];
                [btn setImage:self.getNewImg3 forState:UIControlStateNormal];
                break;
            case 4:
                label.text=@"冷绿";
                [self getNewImg:cImage AndType:4];
                [btn setImage:self.getNewImg4 forState:UIControlStateNormal];
                break;

            default:
                break;
        }
        label.font =[UIFont systemFontOfSize:13];
        [tzhiView addSubview:label];
        

    }
    
    //下一步按钮
    _footerBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,self.view.bottom-50, kScreenWidth, 50)];
    [_footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _footerBtn.backgroundColor =[UIColor whiteColor];
    [_footerBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:_footerBtn];
    
}
-(void)btnClick:(UIButton *)btn{
    NSInteger i =btn.tag;
    UIImage *image =cImage;
    switch (i) {
        case 1:
            self.bgImage.image =cImage;
            break;
        case 2:
            [self getNewImg:image AndType:1];
            self.bgImage.image =self.getNewImg1;
            break;
        case 3:
            [self getNewImg:image AndType:2];
            self.bgImage.image =self.getNewImg2;
            break;
        case 4:
            [self getNewImg:image AndType:3];
            self.bgImage.image =self.getNewImg3;
            break;
        case 5:
            [self getNewImg:image AndType:4];
            self.bgImage.image =self.getNewImg4;
            break;
            
        default:
            break;
    }
}
-(void)nextClick{
    
    [self hudShow:@"正在上传"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmsss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *temp=[NSString stringWithFormat:@"%@.png",locationString];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
    osData = [[OSSData alloc] initWithBucket:bucket withKey:temp];
    NSData *data = UIImagePNGRepresentation(self.bgImage.image);
    [osData setData:data withType:@"image/png"];
    self.issue =[[BuyerIssueViewController alloc]init];
    self.issue.image =self.bgImage.image;
    if (self.imageDic) {
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                NSMutableDictionary *dict= [NSMutableDictionary dictionary];
                self.tempImageName =temp;
                [dict setObject:self.tempImageName forKey:@"ImageUrl"];
                [dict setObject:self.tagsArray forKey:@"Tags"];
                
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(pop:AndDic:AndType:)])
                {
                    [self.delegate pop:self.bgImage.image AndDic:dict AndType:_btnType];
                }
            }else{
                [self showHudFailed:[error description]];
            }
            [self textHUDHiddle];
        } withProgressCallback:^(float progress) {
            NSLog(@"%f",progress);
        }];
        
        
        
    }else if(imgDic){ //修改商品
        
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                NSMutableDictionary *dict= [NSMutableDictionary dictionary];
                self.tempImageName =temp;
                [dict setObject:self.tempImageName forKey:@"ImageUrl"];
                [dict setObject:self.tagsArray forKey:@"Tags"];
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(pop:AndDic:AndType:)])
                {
                    [self.delegate pop:self.bgImage.image AndDic:dict AndType:_btnType];
                }
            }else{
                [self showHudFailed:[error description]];
            }
            [self textHUDHiddle];
        } withProgressCallback:^(float progress) {
            NSLog(@"%f",progress);
        }];
       

    }
    else{ //需要上传图片
        
        [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                self.tempImageName =temp;
                [self performSelectorOnMainThread:@selector(pushIssue:)withObject:self.issue waitUntilDone:YES];
            }else{
                [self showHudFailed:[error description]];
            }
            [self textHUDHiddle];
        } withProgressCallback:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }
}
-(void)pushIssue :(BuyerIssueViewController *)issue
{
    
    
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    [dict setObject:self.tempImageName forKey:@"ImageUrl"]; //取到上传图片的名称
    [dict setObject:self.tagsArray forKey:@"Tags"];//取到该图片对应的tags
    
    issue.images =dict;
    [self.navigationController pushViewController:issue animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(choose:andImgs:)])
    {
        [self.delegate choose:self.bgImage.image andImgs:dict];
    }
    
}


-(void)didClickImage:(UITapGestureRecognizer *)tap
{
    tagPoint =[tap locationInView:tap.view];
    //弹框
    UIActionSheet *action= [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"普通标签", @"品牌标签", nil];
    
    // Show the sheet
    [action showInView:self.view];
    
    

}

-(void)panTagImageView:(UIPanGestureRecognizer *)pan
{
    
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateBegan)
    {
        
    }
    
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateChanged)
    {
        NSLog(@"%f---%f",pan.view.frame.origin.x,pan.view.frame.origin.y);
        CGPoint translatedPoint = [pan translationInView:pan.view.superview];
        
        CGFloat x = pan.view.center.x + translatedPoint.x;
        CGFloat y = pan.view.center.y + translatedPoint.y;
        
        CGPoint newcenter = CGPointMake(x, y);
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        
        float halfx = CGRectGetMidX(pan.view.bounds);
        //x坐标左边界
        newcenter.x = MAX(halfx, newcenter.x);
        //x坐标右边界
        newcenter.x = MIN(pan.view.superview.bounds.size.width - halfx, newcenter.x);
        
        //y坐标同理
        float halfy = CGRectGetMidY(pan.view.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
        newcenter.y = MIN(pan.view.superview.bounds.size.height - halfy, newcenter.y);
        //移动view
        pan.view.center = newcenter;
    }
    if ([(UIPanGestureRecognizer *)pan state] == UIGestureRecognizerStateEnded)
    {
        if (self.tagsArray) { //移动更变tag的位置
            //得获取到哪一个tag移动，并更改其值
            int i=(int)pan.view.tag;
            CGFloat tempX =pan.view.frame.origin.x/kScreenWidth;
            CGFloat tempY =pan.view.frame.origin.y/kScreenWidth;

            [self.tagsArray[i]setObject:@(tempX) forKey:@"PosX"];
            [self.tagsArray[i]setObject:@(tempY) forKey:@"PosY"];
        
        }
    }
}
//BuyerTagDelegate

-(void)didSelectedTag:(NSString *)tagText AndPoint:(CGPoint)point AndSourceId:(NSString *)sourceId AndSourceType:(NSString *)sourceType{
    
    NSString *tag = tagText;
    CGSize size = [Public getContentSizeWith:tag andFontSize:13 andHigth:20];
    CGFloat x = point.x ;
    CGFloat y = point.y;
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(x, y, size.width+30, 25)];
    tagView.backgroundColor = [UIColor clearColor];
    [_bgImage addSubview:tagView];
    
    UIImageView *pointImage = [[UIImageView alloc] init];
    pointImage.center = CGPointMake(10, tagView.height/2);
    pointImage.bounds = CGRectMake(0, 0, 12, 12);
    pointImage.image = [UIImage imageNamed:@"yuan"];
    [tagView addSubview:pointImage];
    
    UIImageView *jiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(pointImage.right+5, 0, 15, tagView.height)];
    jiaoImage.image = [UIImage imageNamed:@"bqqian"];
    [tagView addSubview:jiaoImage];
    
    UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(jiaoImage.right, 0, size.width+10, tagView.height)];
    tagImage.image = [UIImage imageNamed:@"bqhou"];
    [tagView addSubview:tagImage];
    
    UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagImage.width, tagView.height)];
    tagLab.textColor = [UIColor whiteColor];
    tagLab.font = [UIFont systemFontOfSize:13];
    tagLab.text = tag;
    [tagImage addSubview:tagLab];
    
    NSMutableDictionary *tagArray =[NSMutableDictionary dictionary];
    CGFloat tempX =point.x/kScreenWidth;
    CGFloat tempY =point.y/kScreenWidth;
    [tagArray setObject:tagText forKey:@"Name"];
    [tagArray setObject:@(tempX) forKey:@"PosX"];
    [tagArray setObject:@(tempY) forKey:@"PosY"];
    [tagArray setObject:sourceId forKey:@"SourceId"];
    [tagArray setObject:sourceType forKey:@"SourceType"];
    [self.tagsArray addObject:tagArray];
    

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTagImageView:)];
    tagView.tag=viweTag;
    [tagView addGestureRecognizer:panGestureRecognizer];
    viweTag++;
}


-(void)getNewImg:(UIImage *)img{
    
    
    NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%d",1];
    CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    [lutFilter setValue:ciImage forKey:@"inputImage"];
    CIImage *outputImage = [lutFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge_transfer id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    CGImageRef ref =[context createCGImage:outputImage fromRect:outputImage.extent];
    CGImageRelease(ref);
    
    
}

-(void)getNewImg:(UIImage *)img AndType :(int)type{
    
    NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%d",type];
    CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    [lutFilter setValue:ciImage forKey:@"inputImage"];
    CIImage *outputImage = [lutFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge_transfer id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    CGImageRef ref =[context createCGImage:outputImage fromRect:outputImage.extent];
    switch (type) {
        case 1:
           self.getNewImg1= [UIImage imageWithCGImage:ref];
            break;
        case 2:
            self.getNewImg2= [UIImage imageWithCGImage:ref];
            break;
        case 3:
            self.getNewImg3= [UIImage imageWithCGImage:ref];
            break;
        case 4:
            self.getNewImg4= [UIImage imageWithCGImage:ref];
            break;
        default:
            break;
    }
    CGImageRelease(ref);

}
//actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        CGPoint point = tagPoint;
        BuyerTagViewController *tagView= [[BuyerTagViewController alloc]init];
        tagView.delegate =self;
        tagView.cpoint =point;
        tagView.cType =1;
        [self.navigationController pushViewController:tagView animated:YES];
    }else if(buttonIndex ==1){
        CGPoint point = tagPoint;
        BuyerTagViewController *tagView= [[BuyerTagViewController alloc]init];
        tagView.delegate =self;
        tagView.cpoint =point;
        tagView.cType =2;
        [self.navigationController pushViewController:tagView animated:YES];
    }
}


@end
