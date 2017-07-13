//
//  ChangeInformationDataBagObject.h
//  qiandao
//
//  Created by auto on 2017/4/6.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface ChangeInformationDataBagObject : NSObject

@property (nonatomic) NSString * staff_id ;
@property (nonatomic) NSString * staff_num ;
@property (nonatomic) NSString * apartment ;
@property (nonatomic) NSString * name ;
@property (nonatomic) NSString * email ;
@property (nonatomic) NSString * passwd ;

-(ChangeInformationDataBagObject *)DataBagWithPerson:(Person *)person ;
-(void)justfortest ;
@end
