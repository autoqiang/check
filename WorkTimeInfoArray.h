//
//  WorkTimeInfoArray.h
//  qiandao
//
//  Created by auto on 2017/4/10.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTimeInfoArray : NSObject<NSCoding>
@property (nonatomic) NSMutableArray *WorkTimeArray ;
-(WorkTimeInfoArray*)initwithArray:(NSArray *)array;
-(void)save ;
+(WorkTimeInfoArray*)read ;
@end
