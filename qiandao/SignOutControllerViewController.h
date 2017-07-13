//
//  SignOutControllerViewController.h
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignOutControllerProtocol.h"
#import "Person.h"
#import "WorkTimeInfoArray.h"

#import "checkinObject.h"

@interface SignOutControllerViewController : UIViewController<SignOutControllerProtocol>
{
    id <SignOutControllerProtocol>delegate ;
    
    //存放关于签到的各种控件
    UIView * _uiview  ;
    //记录今日打卡信息
    UITableView * _uitableview ;
    //row数量
    NSInteger _number ;
    //签到信息的数组
    NSMutableArray * _array  ;

}
@property (strong,nonatomic) NSMutableArray * LabelArray ;//存放label
@property (strong,nonatomic) NSDate * tempdate ;//模拟服务器传来的签到时间
@property (strong,nonatomic) id <SignOutControllerProtocol>delegate ;
@property (weak, nonatomic) IBOutlet UIView *weizhilan;//位置栏
@property (weak, nonatomic) IBOutlet UIImageView *maoboli;//毛玻璃
@property (weak, nonatomic) IBOutlet UILabel *weizhi;//显示地理位置

@property (nonatomic) Person * person ;
@property (nonatomic) WorkTimeInfoArray * InfoArray ;
@property (nonatomic) NSTimer * timer ;
@property (nonatomic) checkinObject * checkin ;
@end
