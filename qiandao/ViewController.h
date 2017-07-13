//
//  ViewController.h
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignOutControllerProtocol.h"
#import "checkinObject.h" 
#import "Person.h"
#import "WorkTimeInfoArray.h"
#import "LemonKit.h"
@interface ViewController : UIViewController
                                    <SignOutControllerProtocol,UITableViewDataSource,UITableViewDelegate>
{
    //存放关于签到的各种控件
    UIView * _uiview  ;
    //记录今日打卡信息
    UITableView * _uitableview ;
    //row数量
    NSInteger _number ;
    //签到信息的数组
    NSMutableArray * _array  ;
}
@property (strong,nonatomic)NSDate * date ; //存放当前时间日期
@property (strong,nonatomic)NSString * DateString ;//日期的字符串
@property (strong,nonatomic)NSString * TimeString ;//时间的字符串
@property (strong,nonatomic)NSMutableArray * LabelArray ;//存放显示时间的label
@property (strong,nonatomic)UILabel * Datelabel ;//显示日期的label
@property (weak, nonatomic) IBOutlet UILabel *weizhi;//显示地理位置
@property (strong,nonatomic)id<SignOutControllerProtocol>delegate ;//代理 用于调用tabbar里面的同名方法
@property (weak, nonatomic) IBOutlet UIView *weizhilan;//位置栏
@property (weak, nonatomic) IBOutlet UIImageView *maoboli;//毛玻璃
@property (weak, nonatomic) IBOutlet UIImageView *fengexian;//分割线
@property (strong,nonatomic)NSTimer * timer2 ;//数据包的计时器
@property (nonatomic) checkinObject * checkin ;//每5分钟发送的数据包;
@property (nonatomic) Person * person ;

@property (nonatomic) NSDictionary * checkinlogsdic ;//签到记录
@property (nonatomic) WorkTimeInfoArray * InfoArray ;
@property (nonatomic) NSDictionary * responsedic ;
@end

