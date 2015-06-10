//
//  CusCenterTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusCenterTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *showImage;
@property (strong, nonatomic)  UILabel *descLab;
@property (strong, nonatomic)  UILabel *timeLab;
@property (strong, nonatomic)  UIButton *collectBtn;
@property (strong, nonatomic)  UIButton *commentBtn;
@property (strong, nonatomic)  UIButton *shareBtn;
- (void)didClickCollect:(id)sender;
- (void)didClickComment:(id)sender;
- (void)didClickShare:(id)sender;

-(void)setData:(NSDictionary *)dic;

@end
