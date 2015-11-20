//
//  CusVipOrderProTableViewCell.h
//  joybar
//
//  Created by joybar on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailData.h"
@interface CusVipOrderProTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *buyNameLab;
@property (strong, nonatomic) IBOutlet UILabel *colorLab;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UIView *bgTextFieldView;

@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UITextField *desLab;
@property (strong, nonatomic) IBOutlet UILabel *allPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *sizeLab;

-(void)setData:(ProDetailData *)proDetailData;

//购买数量
@property (nonatomic ,strong)NSString *buyNum;
//规格名字
@property (nonatomic ,strong) NSString *sizeName;
@property (nonatomic ,strong) NSDictionary *priceDic;
@end
