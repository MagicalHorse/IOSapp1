//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 3
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define FONT_SIZE 15
#define HORIZONTAL_PADDING 17
#define VERTICAL_PADDING 5
#define BACKGROUND_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.00]
#define TEXT_COLOR [UIColor darkGrayColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation DWTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    self.buttonArr = [[NSMutableArray alloc] init];
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}
- (void)display
{
    for (UIButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (int i=0;i<textArray.count;i++)
    {
        NSString *text = [textArray objectAtIndex:i];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        UIButton *btn = nil;
        if (!gotPreviousFrame)
        {
            btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(0, 0, textSize.width, 27.895);
            totalHeight = textSize.height;
        }
        else
        {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width)
            {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + 27.895 + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            }
            else
            {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(newRect.origin.x, newRect.origin.y, newRect.size.width, 27.895);
        }
        previousFrame = btn.frame;
        gotPreviousFrame = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        if (!lblBackgroundColor) {
            [btn setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [btn setBackgroundColor:lblBackgroundColor];
        }
        [btn setTitleColor:TEXT_COLOR forState:(UIControlStateNormal)];
        [btn setTitle:text forState:(UIControlStateNormal)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:CORNER_RADIUS];
        btn.tag = 1000+i;
//        if (i==0)
//        {
//            btn.backgroundColor = [UIColor orangeColor];
//            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//            if (self.clickBtnBlock)
//            {
//                self.clickBtnBlock(btn,btn.tag-1000);
//            }
//        }
//        else
//        {
//            btn.backgroundColor = BACKGROUND_COLOR;
//            [btn setTitleColor:TEXT_COLOR forState:(UIControlStateNormal)];
//            btn.selected = NO;
//        }

        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        
        [self.buttonArr addObject:btn];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}

-(void)didClickBtn:(UIButton *)btn
{
    for (UIButton *button in self.buttonArr)
    {
        if (button==btn)
        {
            button.backgroundColor = [UIColor redColor];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            if (self.clickBtnBlock)
            {
                self.clickBtnBlock(button,button.tag-1000);
            }
        }
        else
        {
            button.backgroundColor = BACKGROUND_COLOR;
            [button setTitleColor:TEXT_COLOR forState:(UIControlStateNormal)];
        }
    }
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end
