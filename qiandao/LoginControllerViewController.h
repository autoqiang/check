//
//  LoginControllerViewController.h
//  qiandao
//
//  Created by auto on 2017/3/25.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "LemonKit.h"
@interface LoginControllerViewController : UIViewController<LKNotificationDelegate>
@property (strong ,nonatomic) UIView * uiview ;
@property (strong ,nonatomic) UITextField *NameView ;
@property (strong ,nonatomic) UITextField *PwdView ;
@property (strong ,nonatomic) Person * person ;
@end
