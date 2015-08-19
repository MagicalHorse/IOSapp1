//
//  ListView.m
//  FaceView
//
//  Created by Sundy on 14-4-5.
//  Copyright (c) 2014年 Mobile Financial. All rights reserved.
//

#import "ListView.h"
#import "NSString+JSMessagesView.h"

//#import "ChatViewController.h"
@implementation ListView
{
    CGSize kbSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.openKeyBoard = NO;
    self.messageTF.delegate = self;
    self.messageTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageTF.layer.borderWidth = 0.5;
    self.messageTF.layer.cornerRadius = 3;
    self.messageTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
    
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/4);
    
    at = CGAffineTransformTranslate(at, 0, 0);
    
    [self.moreBtn setTransform:at];
    
    //    监听键盘显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    //    监听键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    监听TextView的编辑
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

//-(void)reCreatNewNotification
//{
//    //    监听键盘显示
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
//    //    监听键盘消失
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    //    监听TextView的编辑
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
//}

//键盘按钮
- (IBAction)keyBoardAction:(id)sender
{
    [UIView animateWithDuration:.2 animations:^{
        self.keyBoardBtn.alpha = 0;
        self.longBtn.alpha = 0;
        self.openKeyBoard = YES;
    } completion:^(BOOL finished) {
        self.voiceBtn.alpha = 1.0f;
        [self performSelectorOnMainThread:@selector(becomeMessageTF) withObject:nil waitUntilDone:NO];
    }];
}

- (void)becomeMessageTF
{
    [self.messageTF becomeFirstResponder];
}


//语音按钮
//- (IBAction)voiceBtnAction:(id)sender
//{
//    [UIView animateWithDuration:.3 animations:^{
//        self.top = kScreenHeight-49-64;
//        self.voiceBtn.alpha = 0;
//        self.longBtn.alpha = 1.0f;
//        [self.messageTF resignFirstResponder];
//    } completion:^(BOOL finished) {
//        self.keyBoardBtn.alpha = 1.0f;
//    }];
//    self.top = kScreenHeight-49-64;
//    if (self.openFace) {
//        self.faceView.transform = CGAffineTransformTranslate(self.faceView.transform, 0, kScreenHeight-64);
//        self.openFace = NO;
//    }else if (self.openListView)
//    {
//        self.moreView.transform = CGAffineTransformTranslate(self.moreView.transform, 0, kScreenHeight-64);
//    }
//}

//表情按钮
- (IBAction)smileBtnAction:(id)sender
{
    
    //    启用表情View
//    [UIView animateWithDuration:.3 animations:^{
//        self.longBtn.alpha = 0;
//        self.voiceBtn.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        self.keyBoardBtn.alpha = 0;
//    }];
    
    self.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);

//    判断键盘是否启用
    if (self.openKeyBoard) {
//        关闭键盘
        [self.messageTF resignFirstResponder];
    }
    
    if (self.openListView && self.moreView != nil) {
        self.moreView.transform = CGAffineTransformTranslate(self.moreView.transform, 0, kScreenHeight-64);
    }
    if (self.faceView == nil) {
        self.faceView = [[FaceScroller alloc]initWithFrame:CGRectMake(0, kScreenHeight-216, kScreenWidth, 216-49)];
        self.faceView.faceViewClickDelegate = self;
        [self.viewController.view addSubview:self.faceView];
    }
    self.faceView.frame = CGRectMake(0, kScreenHeight-216, kScreenWidth, 216-49);
    self.top = kScreenHeight - 216-49;
    self.openFace = YES;
    
    if ([self.sendMessageDelegate respondsToSelector:@selector(changeTableViewFrameWhileShow:)])
    {
        [self.sendMessageDelegate changeTableViewFrameWhileShow:YES];
    }
}
-(void)handleProLinkDelegate:(NSArray *)proArr
{
    [self.sendMessageDelegate selectProLink:proArr];
}

-(void)handleImage:(NSData *)data
{
    [self.sendMessageDelegate selectImage:data];
}

//功能列表按钮
- (IBAction)moreBtnAction:(id)sender
{
    self.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
//    [UIView animateWithDuration:.3 animations:^{
//        self.longBtn.alpha = 0;
//        self.voiceBtn.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        self.keyBoardBtn.alpha = 0;
//    }];

//    if (!self.openKeyBoard)
//    {
//        [self.messageTF becomeFirstResponder];
//    }
    
    if (self.openKeyBoard)
    {
        [self.messageTF resignFirstResponder];
    }
    else if(self.openFace)
    {
        self.faceView.transform = CGAffineTransformTranslate(self.faceView.transform, 0, kScreenHeight-64);
        self.openFace = NO;
    }
    if (self.moreView == nil)
    {
        self.moreView = [[[NSBundle mainBundle]loadNibNamed:@"MessageMoreView" owner:self options:nil] lastObject];
        self.moreView.messageMoreDelegate = self;
        [self.viewController.view addSubview:self.moreView];
    }
//    self.moreView.transform = CGAffineTransformIdentity;
    self.moreView.frame = CGRectMake(0, kScreenHeight-164, kScreenWidth, 164);
    self.top = kScreenHeight -49-64-100;
    self.openListView = YES;
    
    if ([self.sendMessageDelegate respondsToSelector:@selector(changeTableViewFrameWhileShow:)])
    {
        [self.sendMessageDelegate changeTableViewFrameWhileShow:YES];
    }
}

#pragma mark - KeyBoardNotification
- (void)keyBoardwillShowNotification:(NSNotification *)not
{
    NSDictionary* info = [not userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
     kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度

    if ([self.sendMessageDelegate respondsToSelector:@selector(changeTableViewFrameWhileShow:)])
    {
        [self.sendMessageDelegate changeTableViewFrameWhileShow:NO];
    }
    self.top = kScreenHeight-kbSize.height-49;
//    键盘将要显示，判断功能列表和表情列表是否展开
    [UIView animateWithDuration:0.25 animations:^{
        if (self.openFace && self.faceView != nil) {
            self.faceView.transform = CGAffineTransformTranslate(self.faceView.transform, 0, kScreenHeight-49);
        }
        if (self.openListView && self.moreView != nil) {
//            self.moreView.transform = CGAffineTransformTranslate(self.faceView.transform, 0, kScreenHeight-49);
            self.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 164);
        }
        self.openKeyBoard = YES;
    }];
}

- (void)keyBoardwillHideNotification:(NSNotification *)not
{
    if ([self.sendMessageDelegate respondsToSelector:@selector(changeTableViewFrameWhileHidden)]) {
        [self.sendMessageDelegate changeTableViewFrameWhileHidden];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.openKeyBoard = NO;
        self.frame = CGRectMake(0, self.viewController.view.frame.size.height-49, kScreenWidth, 49);
        
    }];
}

- (void)keyBoardwillChangeFrameNotification:(NSNotification *)not
{
    [UIView animateWithDuration:0.25 animations:^{
        NSValue *keyboardValue = [not.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"];
        CGRect frame = [keyboardValue CGRectValue];
        float keyBoardHeight = frame.size.height;
        self.top = kScreenHeight-keyBoardHeight-49;
        self.openKeyBoard = YES;
    }];
}

- (void)textViewChangeNotification:(NSNotification *)not
{
    //textView内容发生改变的时候调用的方法.
}

- (NSInteger)lineCounts:(NSString *)content
{
    
    return 0;
}

#pragma mark - FaceVIewItemClickDelegate
- (void)faceViewItemClick:(NSString *)faceName
{
    if (faceName.length > 0) {
        [self.messageTF setText:[self.messageTF.text stringByAppendingString:faceName]];
    }
}


#pragma mark - 
#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
//        将消息内容前后去行
        if ([textView.text js_stringByTrimingWhitespace].length>0) {
            if ([self.sendMessageDelegate respondsToSelector:@selector(sendMessageText:withData:)]) {
                [self.sendMessageDelegate sendMessageText:textView withData:[NSDate date]];
            }
            return NO;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不能发送空白消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}


@end
