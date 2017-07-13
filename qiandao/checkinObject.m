//
//  checkinObject.m
//  qiandao
//
//  Created by auto on 2017/4/10.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "checkinObject.h"

@implementation checkinObject

-(void)getUserid:(NSString *)idstring andlng:(NSString *)lngstring andlat:(NSString *)latstring{
    self.user_id = idstring ;
    self.lng = lngstring ;
    self.lat = latstring ;
}

@end
