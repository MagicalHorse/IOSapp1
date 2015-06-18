//
//  CusRefundPriceViewController.h
//  joybar
//
//  Created by 123 on 15/6/15.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListItem.h"

@protocol refundDelegate <NSObject>

-(void)refundPriceDelegate;

@end
@interface CusRefundPriceViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *proSizeLab;
@property (strong, nonatomic) IBOutlet UILabel *proNumLab;
@property (strong, nonatomic) IBOutlet UILabel *proPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *proStatusLab;
@property (strong, nonatomic) IBOutlet UILabel *refundPriceLab;
@property (strong, nonatomic) IBOutlet UITextView *refundText;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic ,strong) OrderListItem *orderItem;

@property (nonatomic ,assign) id<refundDelegate> delegete;

@end
