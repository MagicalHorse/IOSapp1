//
//  CusOrderProTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailData.h"
@interface CusOrderProTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *buyNameLab;
@property (strong, nonatomic) IBOutlet UILabel *addressLab;
@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *proNumLab;
@property (strong, nonatomic) IBOutlet UILabel *allPriceLab;

@property (strong, nonatomic) IBOutlet UILabel *sizeLab;

-(void)setData:(ProDetailData *)proDetailData;

//购买数量
@property (nonatomic ,strong)NSString *buyNum;

//规格名字
@property (nonatomic ,strong) NSString *sizeName;


@end
