//
//  MessageTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/20.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "MessageTableViewCell.h"

#define BEGIN_FLAG @"["
#define END_FLAG @"]"

@implementation MessageTableViewCell

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    UIView *textView =  [self assembleMessageAtIndex:text from:fromSelf];
    
    UIView *returnView = [[UIView alloc] init];
    returnView.backgroundColor = [UIColor clearColor];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:fromSelf == YES?@"橙色对话框@2x":@"白色对话框@2x" ofType:@"png"];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:imagePath];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)];
    
    bgImageView.frame = CGRectMake(0.0f, 40, textView.width+40.0f, textView.height+30.0f);
    
    if(fromSelf)
    {
        returnView.frame = CGRectMake(kScreenWidth-position-(textView.width+30.0f), 0.0f, textView.width+30.0f, textView.height+10.0f);
    }
    else
    {
        returnView.frame = CGRectMake(position, 0.0f, textView.width+30.0f, textView.height+10.0f);
    }
    
    [returnView addSubview:bgImageView];
    [returnView addSubview:textView];
    
    return returnView;
}

//图片
-(UIView *)imageBubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position
{
    UIView *imageView = [[UIView alloc] init];
//    imageView.backgroundColor = [UIColor blueColor];
    
//    imageView.clipsToBounds = YES;
    
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 100, 100)];
    ImgView.backgroundColor = [UIColor redColor];
//    if(fromSelf){
//        NSData *data = [NSData dataFromBase64String:text];
//        ImgView.image = [UIImage imageWithData:data];
//    }
//    else
//    {
////占位图
////        [ImgView setImageWithURL:[NSURL URLWithString:text] placeholderImage:nil];
//    }
    if(fromSelf)
        imageView.frame = CGRectMake(kScreenWidth-position-(ImgView.width+10.0f), 5.0f, ImgView.width+10.0f, ImgView.height+10.0f);
    else
        imageView.frame = CGRectMake(position, 5.0f, ImgView.width+10.0f, ImgView.height+10.0f);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:fromSelf == YES?@"橙色对话框@2x":@"白色对话框@2x" ofType:@"png"];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)];
    bgImageView.frame = CGRectMake(0.0f, 40, imageView.width+10, imageView.height);
    [imageView addSubview:bgImageView];
    [bgImageView addSubview:ImgView];
    return imageView;
}

//发送链接
- (UIView *)productLinkBubbleView:(NSString *)text AndProcuctLink:(NSString *)proLink from:(BOOL)fromSelf withPosition:(int)position
{
    UIView *returnView = [[UIView alloc] init];
    returnView.backgroundColor = [UIColor clearColor];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:fromSelf == YES?@"橙色对话框@2x":@"白色对话框@2x" ofType:@"png"];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)];
    
    bgImageView.frame = CGRectMake(0.0f, 40, 230, 90);
    
    if(fromSelf)
    {
        returnView.frame = CGRectMake(kScreenWidth-position-220, 0.0f, 220, 70);
    }
    else
    {
        returnView.frame = CGRectMake(position, 0.0f, 220, 70);
    }
    
    [returnView addSubview:bgImageView];
    
    UIImageView *proImage = [[UIImageView alloc] init];
    
    if(fromSelf)
    {
        proImage.frame =CGRectMake(5, 5, bgImageView.height-10, bgImageView.height-10);
    }
    else
    {
        proImage.frame =CGRectMake(10, 5, bgImageView.height-10, bgImageView.height-10);

    }
    [proImage sd_setImageWithURL:[NSURL URLWithString:text] placeholderImage:nil];
    [bgImageView addSubview:proImage];
    
    UILabel *linkLab = [[UILabel alloc] initWithFrame:CGRectMake(proImage.right+5, 5, bgImageView.width-proImage.width-20, bgImageView.height-10)];
    linkLab.numberOfLines = 0;
    linkLab.text = proLink;
    if (fromSelf)
    {
        linkLab.textColor = [UIColor whiteColor];
    }
    else
    {
        linkLab.textColor = [UIColor blueColor];

    }
    linkLab.font = [UIFont systemFontOfSize:14];
    [bgImageView addSubview:linkLab];
    return returnView;
}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 200
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont fontWithName:@"youyuan" size:15];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = MAX_WIDTH;
                    Y = upY;
                }
                // NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                //转换成图片
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"faceInfo"];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[dict valueForKey:str]]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<MAX_WIDTH) X = upX;
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(MAX_WIDTH, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    if (fromself)
                    {
                        la.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        la.textColor = [UIColor blackColor];
                    }
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<MAX_WIDTH) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,48, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    return returnView;
}

@end
