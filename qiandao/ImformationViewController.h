//
//  ImformationViewController.h
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface ImformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) Person * person ;

@property(nonatomic) UIImageView * imageView ;
@end
