//
//  CusMyCircleTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusMyCircleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *lastMessageLab;

@property (strong, nonatomic) IBOutlet UILabel *msgCountLab;
-(void)setData:(NSDictionary *)dic;

@end
