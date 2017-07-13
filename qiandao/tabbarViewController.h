//
//  tabbarViewController.h
//  qiandao
//
//  Created by auto on 2017/3/20.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigncontrollerObject.h"
#import "SignOutControllerViewController.h"
#import "ViewController.h"
#import "SignOutControllerProtocol.h"
#import "ViewControllerdfdfdf.h"
#import "SetViewController.h"
#import "Person.h"
@interface tabbarViewController : UITabBarController<SignOutControllerProtocol>{
    SignOutControllerViewController * controller ;
    ViewController * controller2 ;
    ViewControllerdfdfdf *temp ;
    SetViewController * setviewcontroller ;
    
   
}
 - (void)Push ;
@property (strong,nonatomic) SigncontrollerObject * object ;
@property (strong,nonatomic) Person * person ;

@end
