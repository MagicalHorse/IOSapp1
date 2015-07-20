//
//  CusCenterTableViewCell.m
//  joybar
//
//  Created by 123 on 15/5/4.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusCenterTableViewCell.h"

@implementation CusCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    
}

-(void)setData:(NSDictionary *)dic
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, kScreenWidth/2-5)];
    imageView.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:imageView];
    
    self.descLab = [[UILabel alloc] init];
    self.descLab.numberOfLines = 0;
    self.descLab.text = @"撒娇雷克萨斯登录";
    CGSize size = [self getContentSizeWith:self.descLab.text];
    self.descLab.frame = CGRectMake(10, imageView.bottom+10, kScreenWidth-20, size.height);
    self.descLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.descLab];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.descLab.bottom+30, 50, 17)];
    self.timeLab.text = @"123天前";
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLab];
    
    self.shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.shareBtn.frame = CGRectMake(kScreenWidth-75-12, self.descLab.bottom+20, 75, 30);
    [self.shareBtn setImage:[UIImage imageNamed:@"分享.png"] forState:(UIControlStateNormal)];
    [self.shareBtn setTitle:@"123" forState:(UIControlStateNormal)];
    self.shareBtn.backgroundColor = kCustomColor(242, 244, 246);
    [self.shareBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.shareBtn.layer.cornerRadius = 4;
    self.shareBtn.layer.borderColor = kCustomColor(234, 234, 234).CGColor;
    self.shareBtn.layer.borderWidth = 0.5;
    [self.shareBtn addTarget:self action:@selector(didClickShare:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.shareBtn];
    
    self.commentBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.commentBtn.frame = CGRectMake(self.shareBtn.left-8-75, self.descLab.bottom+20, 75, 30);
    [self.commentBtn setImage:[UIImage imageNamed:@"评论.png"] forState:(UIControlStateNormal)];
    [self.commentBtn setTitle:@"234" forState:(UIControlStateNormal)];
    self.commentBtn.backgroundColor = kCustomColor(242, 244, 246);
    [self.commentBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.commentBtn.layer.cornerRadius = 4;
    self.commentBtn.layer.borderColor = kCustomColor(234, 234, 234).CGColor;
    self.commentBtn.layer.borderWidth = 0.5;
    [self.commentBtn addTarget:self action:@selector(didClickComment:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.commentBtn];

    self.collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.collectBtn.frame = CGRectMake(self.commentBtn.left-8-75, self.descLab.bottom+20, 75, 30);
    [self.collectBtn setImage:[UIImage imageNamed:@"点赞.png"] forState:(UIControlStateNormal)];
    [self.collectBtn setTitle:@"456" forState:(UIControlStateNormal)];
    self.collectBtn.backgroundColor = kCustomColor(242, 244, 246);
    [self.collectBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.collectBtn.layer.cornerRadius = 4;
    self.collectBtn.layer.borderColor = kCustomColor(234, 234, 234).CGColor;
    self.collectBtn.layer.borderWidth = 0.5;
    self.collectBtn.selected = NO;
    [self.collectBtn addTarget:self action:@selector(didClickCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:self.collectBtn];
}

- (void)didClickCollect:(id)sender
{
    
    if (self.collectBtn.selected==NO)
    {
        [self.collectBtn setImage:[UIImage imageNamed:@"点赞h.png"] forState:(UIControlStateNormal)];
        self.collectBtn.selected = YES;
    }
    else
    {
        [self.collectBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        self.collectBtn.selected = NO;
    }
}

- (void)didClickComment:(id)sender
{
    
}

- (void)didClickShare:(id)sender
{
    
}

-(CGSize)getContentSizeWith:(NSString *)content
{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}


@end
