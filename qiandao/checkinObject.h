//
//  checkinObject.h
//  qiandao
//
//  Created by auto on 2017/4/10.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface checkinObject : NSObject
@property (nonatomic) NSString * user_id ;
@property (nonatomic) NSString * lng ;//经度
@property (nonatomic) NSString * lat ; //纬度

-(void)getUserid:(NSString *)idstring andlng:(NSString *)lngstring andlat:(NSString *)latstring ;
@end
