//
//  RefundTableViewCell.m
//  joybar
//
//  Created by 123 on 15/12/31.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "RefundTableViewCell.h"

@implementation RefundTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setData:(NSDictionary *)dic
{
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"ProductPic"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.proName.text = [dic objectForKey:@"ProductName"];
    self.proSizeLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SizeName"]];
    self.proNumLab.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"ProductCount"]];
    self.proPriceLab.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"Price"]];
    
}
@end
