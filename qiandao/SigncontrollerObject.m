//
//  SigncontrollerObject.m
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "SigncontrollerObject.h"

@implementation SigncontrollerObject

- (void) ChangeTheSign {
    if (_isSigned==1) {
        _isSigned = 0 ;
    }else{
        _isSigned = 1 ;
    }
}
- (BOOL)GetTheSignNumber {
    return _isSigned ;
}
@end
