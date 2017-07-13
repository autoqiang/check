//
//  SigncontrollerObject.h
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigncontrollerObject : NSObject
{
@public
BOOL _isSigned  ;
}



@property(nonatomic) NSString * mobile;
@property(nonatomic) NSString * passwd ;


- (void) ChangeTheSign ;
- (BOOL)GetTheSignNumber ;
@end
