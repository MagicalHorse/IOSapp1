//
//  ListView.h
//  FaceView
//  功能列表View

//  Created by Sundy on 14-4-5.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceScroller.h"
#import "MessageMoreView.h"
@protocol SendMessageTextDelegate <NSObject>

- (void)sendMessageText:(UITextView *)textView withData:(NSDate *)date;

- (void)changeTableViewFrameWhileShow:(BOOL)isAction;

- (void)changeTableViewFrameWhileHidden;

- (void)selectProLink:(NSArray *)arr;

- (void)selectImage:(NSData *)data;
@end

@interface ListView : UIView<FaceVIewItemClickDelegate,UITextViewDelegate,MessageMoreViewDelegate>

//view的背景
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//输入框
@property (weak, nonatomic) IBOutlet UITextView *messageTF;

@property (weak, nonatomic) id<SendMessageTextDelegate>sendMessageDelegate;

//表情按钮
@property (weak, nonatomic) IBOutlet UIButton *smileBtn;
//更多按钮
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//语音按钮
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
//键盘按钮
@property (weak, nonatomic) IBOutlet UIButton *keyBoardBtn;
//长按按钮
@property (weak, nonatomic) IBOutlet UIButton *longBtn;

//------------------------------------------------------
@property (strong, nonatomic) FaceScroller *faceView;

@property (strong, nonatomic) MessageMoreView *moreView;

//  键盘是否开启
@property (nonatomic) BOOL openKeyBoard;
//    表情是否开启
@property (nonatomic) BOOL openFace;
//    功能列表是否开启
@property (nonatomic) BOOL openListView;

- (IBAction)longClickAction:(id)sender;

- (IBAction)keyBoardAction:(id)sender;

- (IBAction)voiceBtnAction:(id)sender;

- (IBAction)smileBtnAction:(id)sender;

- (IBAction)moreBtnAction:(id)sender;

-(void)reCreatNotification;

@end
