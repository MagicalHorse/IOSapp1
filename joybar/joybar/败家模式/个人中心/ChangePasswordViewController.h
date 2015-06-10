//
//  ChangePasswordViewController.h
//  joybar
//
//  Created by 123 on 15/5/25.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePasswordViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *setNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *repeatPassword;

@end
