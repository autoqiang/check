//
//  ChangeInformationDataBagObject.m
//  qiandao
//
//  Created by auto on 2017/4/6.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "ChangeInformationDataBagObject.h"

@implementation ChangeInformationDataBagObject
-(ChangeInformationDataBagObject *)DataBagWithPerson:(Person *)person{
    self.staff_id = person.staff_id;
    self.staff_num = person.staff_num ;
    self.apartment = person.apartment ;
    self.name = person.name ;
    self.email = person.email ;
    self.passwd = person.passwd ;
    return  self ;
}
-(void)justfortest{
    
    NSLog(@"%@",_staff_id) ;
    NSLog(@"%@",_apartment) ;
    NSLog(@"%@",_name) ;
    NSLog(@"%@",_email) ;
    NSLog(@"%@",_passwd) ;
}
@end
