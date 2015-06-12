//
//  MessageTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/20.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

//发送消息的日期
//@property (strong, nonatomic) UILabel *senderAndTimeLabel;
////消息内容
//@property (strong, nonatomic) UITextView *messageContentView;
////背景图片
//@property (strong, nonatomic) UIImageView *bgImageView;

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position;

- (UIView *)imageBubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position;

- (UIView *)productLinkBubbleView:(NSString *)text AndProcuctLink:(NSString *)proLink from:(BOOL)fromSelf withPosition:(int)position;


@end
