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


@interface BuyerFilterViewController ()<BuyerTagDelegate,UIActionSheetDelegate>
{
    UIImage *cImage;
    CGPoint tagPoint;
    OSSData *osData;
}
@property (nonatomic,strong)UIView *customInfoView;
@property (nonatomic,strong)UIView *dscView;
@property (nonatomic,strong)UIView *photoView;
@property (nonatomic,strong)UIButton *footerBtn;
@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)NSMutableDictionary *tagArray;
@property (nonatomic,strong)NSMutableArray *tagsArray;
@property (nonatomic,strong)NSMutableArray * images;
@property (nonatomic,strong)NSString *tempImageName;
@property (nonatomic,strong)BuyerIssueViewController *issue;
@end

@implementation BuyerFilterViewController

-(NSMutableArray *)images{
    if (_images ==nil) {
        _images =[[NSMutableArray alloc]init];
    }
    return _images;
}
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@"编辑图片"];
    [self setInitView];
    [self aliyunSet];
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
-(void) setInitView{
    
    self.view.backgroundColor =kCustomColor(241, 241, 241);
    
    UIView *titieView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    titieView.backgroundColor =[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
   
    
    _bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 300)];
    _bgImage.image =cImage;
    [self.view addSubview:_bgImage];
    _bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage:)];
    [_bgImage addGestureRecognizer:tap];
    
    UILabel* titieLable= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    titieLable.font =[UIFont fontWithName:@"youyuan" size:17];
    titieLable.text =@"点击图片任意位置添加标签";
    titieLable.textColor =[UIColor whiteColor];
    titieLable.textAlignment = NSTextAlignmentCenter;
    [titieView addSubview:titieLable];
    [self.view addSubview:titieView];
    
    UIView * tzhiView=[[UIView alloc]initWithFrame:CGRectMake(0, _bgImage.bottom, kScreenWidth, 110)];
    tzhiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:tzhiView];
    

    for (int i=0; i<4; i++) {
        UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth/4-20)*i+15*(i+1), 15, kScreenWidth/4-20, 60)];
        btn.tag =i+1;
        btn.backgroundColor =[UIColor greenColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tzhiView addSubview:btn];
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth/4-20)*i+15*(i+1), btn.bottom+10, kScreenWidth/4-20, 13)];
        label.text=@"我是滤镜";
        label.font =[UIFont fontWithName:@"youyuan" size:13];
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
            self.bgImage.image =[self getNewImg:image AndType:1];
            break;
        case 2:
            self.bgImage.image =[self getNewImg:image AndType:2];
            break;
        case 3:
            self.bgImage.image =[self getNewImg:image AndType:3];
            break;
        case 4:
            self.bgImage.image =[self getNewImg:image AndType:4];
            break;
            
        default:
            break;
    }
}
-(void)nextClick{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmsss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSString *temp=[NSString stringWithFormat:@"%@.png",locationString];
    if (self.issue==nil) {
        self.issue =[[BuyerIssueViewController alloc]init];
    }
    self.issue.image =cImage;
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:AlyBucket];
    osData = [[OSSData alloc] initWithBucket:bucket withKey:temp];
    NSData *data = UIImagePNGRepresentation(cImage);
    [osData setData:data withType:@"image/png"];
    [osData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            self.tempImageName =temp;
            [self performSelectorOnMainThread:@selector(pushIssue:)withObject:self.issue waitUntilDone:YES];
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"%f",progress);
    }];
    
}
-(void)pushIssue :(BuyerIssueViewController *)issue{
    issue.imgTag =self.imgTag;
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    [dict setObject:self.tempImageName forKey:@"ImageUrl"];
    [dict setObject:self.tagsArray forKey:@"Tags"];
    [self.images addObject:dict];
    issue.images =self.images;
    [self.navigationController pushViewController:issue animated:YES];
    
    
}
-(void)choose:(UIImage *)image{
    
    if ([self.delegate respondsToSelector:@selector(choose:)])
    {
        [self.delegate choose:image];
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
//        CGPoint point = [pan locationInView:pan.view];
        NSLog(@"%f---%f",pan.view.frame.origin.x,pan.view.frame.origin.y);
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
    tagLab.font = [UIFont fontWithName:@"youyuan" size:13];
    tagLab.text = tag;
    [tagImage addSubview:tagLab];
    
    [self.tagArray setObject:tagText forKey:@"Name"];
    [self.tagArray setObject:@(point.x) forKey:@"PosX"];
    [self.tagArray setObject:@(point.y) forKey:@"PosY"];
    [self.tagArray setObject:sourceId forKey:@"SourceId"];
    [self.tagArray setObject:sourceType forKey:@"SourceType"];
    [self.tagsArray addObject:self.tagArray];
    

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTagImageView:)];
    [tagView addGestureRecognizer:panGestureRecognizer];
}

-(UIImage *)getNewImg:(UIImage *)img AndType :(int)type{
    
    NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%d",type];
    CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    [lutFilter setValue:ciImage forKey:@"inputImage"];
    CIImage *outputImage = [lutFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
    
    UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
    return newImage;
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
-(void)dealloc{
    NSLog(@"dea");
}

@end
