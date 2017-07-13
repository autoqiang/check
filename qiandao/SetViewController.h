//
//  SetViewController.h
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRNavigationBar.h"
#import "Person.h"
@interface SetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    UISwitch * sw1 ;
    UISwitch * sw2 ;
}
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (nonatomic,strong) Person * person ;
@end
