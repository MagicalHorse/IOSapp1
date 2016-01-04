//
//  RefundTableViewCell.h
//  joybar
//
//  Created by 123 on 15/12/31.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *proImage;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *proSizeLab;
@property (strong, nonatomic) IBOutlet UILabel *proNumLab;
@property (strong, nonatomic) IBOutlet UILabel *proPriceLab;
@property (strong, nonatomic) IBOutlet UILabel *proStatusLab;
@property (strong, nonatomic) IBOutlet UILabel *refundPriceLab;
@property (strong, nonatomic) IBOutlet UITextView *refundText;


-(void) setData:(NSDictionary *)dic;

@end
