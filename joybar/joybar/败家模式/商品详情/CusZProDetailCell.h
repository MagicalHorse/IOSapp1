//
//  CusZProDetailCell.h
//  joybar
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProDetailData.h"

@protocol handleSizeHeight <NSObject>

-(void)handleSizeHeight:(CGFloat)height;

-(void)handleSizeName:(NSString *)sizeName;

-(void)handleBuyCount:(NSString *)count;

@end
@interface CusZProDetailCell : UITableViewCell<UIScrollViewDelegate>


-(void)setDetailData:(ProDetailData *)proData andIndex:(NSIndexPath *)indexPath;

@property (nonatomic ,strong) NSArray *kuCunArr;

@property (nonatomic ,assign) NSInteger sizeHeight;

@property (nonatomic ,assign)id<handleSizeHeight> delegate;

@end
