//
//  BuyerFilterViewController.h
//  joybar
//
//  Created by joybar on 15/6/17.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "Image.h"

@protocol BuyerFilterDelgeate <NSObject>
@optional
-(void)choose:(UIImage *)image andImgs :(NSMutableDictionary *)array;
-(void)pop:(UIImage *)image AndDic :(NSMutableDictionary *)dic AndType:(int)type;
@end
@interface BuyerFilterViewController : BaseViewController
@property (nonatomic, weak) id <BuyerFilterDelgeate> delegate;
-(instancetype)initWithImg:(UIImage *)image;
-(instancetype)initWithImg:(UIImage *)image andImage :(Image *)dic;
@property (nonatomic ,strong)NSDictionary *imageDic;
@property (nonatomic ,assign)int btnType;

@end
