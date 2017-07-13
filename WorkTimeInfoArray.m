//
//  WorkTimeInfoArray.m
//  qiandao
//
//  Created by auto on 2017/4/10.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "WorkTimeInfoArray.h"

@implementation WorkTimeInfoArray
-(WorkTimeInfoArray*)initwithArray:(NSArray *)array{
    self.WorkTimeArray = [[NSMutableArray alloc]init] ;
    for (NSDictionary *dic in array) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc]init] ;
        [temp setObject:dic[@"check_in_time"] forKey:@"check_in_time" ] ;
        [temp setObject:dic[@"check_out_time"] forKey:@"check_out_time"] ;
        NSRange range = NSMakeRange(11,8) ;
        NSString * CheckInTime = dic[@"check_in_time"] ;
        NSString * CheckOutTime = dic[@"check_out_time"] ;
        CheckInTime = [CheckInTime substringWithRange:range] ;
        CheckOutTime = [CheckOutTime substringWithRange:range] ;
        NSNumber *WorkTime = [self GetWorkTimeWithCheckInTime:CheckInTime
                                                                          CheckOutTime:CheckOutTime] ;
        [temp setObject:WorkTime forKey:@"Work_Time" ] ;
//        NSLog(@"!!!!!%@",temp) ;
        [_WorkTimeArray addObject:temp] ;
    }
    return self ;
}
-(NSNumber *)GetWorkTimeWithCheckInTime:(NSString *)Checkin CheckOutTime:(NSString*)Checkout{
    NSRange rangehour = NSMakeRange(0, 2) ;
    NSRange rangeminute = NSMakeRange(3, 2) ;
    NSRange rangesecond = NSMakeRange(6, 2) ;
    NSInteger hourin = [[Checkin substringWithRange:rangehour] integerValue] ;
    NSInteger hourout = [[Checkout substringWithRange:rangehour] integerValue];
    NSInteger minutein = [[Checkin substringWithRange:rangeminute] integerValue] ;
    NSInteger minuteout = [[Checkout substringWithRange:rangeminute] integerValue] ;
    NSInteger secondin = [[Checkin substringWithRange:rangesecond] integerValue] ;
    NSInteger secondout = [[Checkout substringWithRange:rangesecond] integerValue] ;
    NSInteger TimeIn = hourin*3600+minutein*60+secondin ;
    NSInteger TimeOut = hourout*3600+minuteout*60+secondout ;
    NSNumber *time = @((float)(TimeOut-TimeIn)/60);
    
    return time;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.WorkTimeArray forKey:@"array" ] ;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.WorkTimeArray = [aDecoder decodeObjectForKey:@"array"] ;
    return self ;
}
- (void)save{
    //申请一块data数据
    NSMutableData * data = [NSMutableData data] ;
    //将NSKeyedArchiver和申请到的data链接
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data ] ;
    //将对象编码并写入data区块
    [archiver encodeObject:self forKey:@"array"] ;
    //结束编码
    [archiver finishEncoding] ;
    [self save:data] ;
}

-(void)save:(NSData *)data{
    //利用自定义方法获取地址即将创建的plist文件的路径
    NSString *filename = [WorkTimeInfoArray GetDocumentPath] ;
    
    //利用NSFileManager 在我们提供的地址创建一个空的plist文件
    NSFileManager * fm = [NSFileManager defaultManager] ;
    //如果文件存在 调用
    if ([fm fileExistsAtPath:filename]) {
        [data writeToFile:filename atomically:YES] ;
        NSLog(@"归档成功") ;
        
    }else{
        [fm createFileAtPath:filename contents:nil attributes:nil] ;
        //将已经存有编码过的对象的data区块写入文件
        [data writeToFile:filename atomically:YES] ;
        NSLog(@"归档成功") ;
    }
    
}
//获取文件路径
+(NSString *)GetDocumentPath{
    //NSUserDomainMask 代表从用户文件夹下找
    //YES 代表展开路径中的波浪字符“～”
    NSArray *array  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    //NSDocumentDirectory代表寻找Document文件夹
    //如果需要寻找其他系统文件夹比如Caches 输入NSCachesDirectory即可
    //tmp文件夹: NSString *tmp = NSTemporaryDirectory();
    //在ios中，只有一个目录和传入的参数匹配，所以这个数组里面只有一个元素
    NSString *documents = [array objectAtIndex:0 ] ;
    
    
    
    NSLog(@"获取到Documents文件夹路径%@",documents) ;
    //在得到的Documents文件夹路径后添加即将创建的plist文件名 得到新的路径
    NSString * filename = [documents stringByAppendingPathComponent:@"array.plist"] ;
    //返回得到的路径
    return filename ;
}

+ (WorkTimeInfoArray*)read{
    NSString * filestring = [self GetDocumentPath] ;
    NSData * data = [NSData dataWithContentsOfFile:filestring] ;
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data] ;
    WorkTimeInfoArray * new = [unarchiver decodeObjectForKey:@"array"] ;
    return new ;
}



@end
