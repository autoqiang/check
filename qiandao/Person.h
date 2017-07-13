//
//  Person.h
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>
@property(nonatomic) NSString * apartment ;
@property(nonatomic) NSString * company;
@property(nonatomic) NSString * email;
@property(nonatomic) NSString * mobile;
@property(nonatomic) NSString * name;
@property(nonatomic) NSString * passwd;
@property(nonatomic) NSString * staff_num;
@property(nonatomic) NSString* staff_id ;
@property(nonatomic) NSNumber * isSigned ;

- (void) save ;
+ (Person *)read ;

@end
