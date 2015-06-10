//
//  SVProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

//enum {
//    SVProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
//    SVProgressHUDMaskTypeClear, // don't allow
//    SVProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
//    SVProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
//};
//
//typedef NSUInteger SVProgressHUDMaskType;

@interface SVProgressHUD : UIView

+ (void)show;
+ (void)show1;
+ (void)dismiss;

@end
