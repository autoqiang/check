 //
//  Person.m
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "Person.h"

@implementation Person
-(instancetype)init{
    if (self=[super init]) {
        self.company=@"网络错误";
        self.email=@"网络错误";
        self.name=@"网络错误";
        self.mobile=@"网络错误";
        self.staff_num=@"网络错误";
        self.passwd=@"000000";
        self.staff_id = @"网络错误" ;
        self.isSigned = [NSNumber numberWithInt:0] ;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"\n公司:%@\n电子邮件:%@\n名字:%@\n电话号:%@\n工号:%@\n密码:%@",self.company,self.email,self.name,self.mobile,self.staff_num,self.passwd];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.apartment forKey:@"apartment"] ;
    [aCoder encodeObject:self.company forKey:@"company"] ;
    [aCoder encodeObject:self.email forKey:@"email"] ;
    [aCoder encodeObject:self.mobile forKey:@"mobile"] ;
    [aCoder encodeObject:self.name forKey:@"name"] ;
    [aCoder encodeObject:self.passwd forKey:@"passwd"] ;
    [aCoder encodeObject:self.staff_num forKey:@"staff_num"] ;
    [aCoder encodeObject:self.isSigned forKey:@"isSigned"] ;
    [aCoder encodeObject:self.staff_id forKey:@"staff_id"] ;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.apartment = [aDecoder decodeObjectForKey:@"apartment"] ;
    self.company = [aDecoder decodeObjectForKey:@"company"] ;
    self.email = [aDecoder decodeObjectForKey:@"email"] ;
    self.mobile = [aDecoder decodeObjectForKey:@"mobile"] ;
    self.name = [aDecoder decodeObjectForKey:@"name"] ;
    self.passwd =[aDecoder decodeObjectForKey:@"passwd"] ;
    self.staff_num = [aDecoder decodeObjectForKey:@"staff_num"] ;
    self.isSigned = [aDecoder decodeObjectForKey:@"isSigned"] ;
    self.staff_id = [aDecoder decodeObjectForKey:@"staff_id"] ;
    return self ; 
}
- (void)save{
    //申请一块data数据
    NSMutableData * data = [NSMutableData data] ;
    //将NSKeyedArchiver和申请到的data链接
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data ] ;
    //将对象编码并写入data区块
    [archiver encodeObject:self forKey:@"person"] ;
    //结束编码
    [archiver finishEncoding] ;
    [self save:data] ;
}

-(void)save:(NSData *)data{
    //利用自定义方法获取地址即将创建的plist文件的路径
    NSString *filename = [Person GetDocumentPath] ;
   
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
    NSString * filename = [documents stringByAppendingPathComponent:@"person.plist"] ;
    //返回得到的路径
    return filename ;
}

+ (Person*)read{
    NSString * filestring = [self GetDocumentPath] ;
    NSData * data = [NSData dataWithContentsOfFile:filestring] ;
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data] ;
    Person * new = [unarchiver decodeObjectForKey:@"person"] ;
    return new ;
}

@end
