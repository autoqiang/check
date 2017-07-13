//
//  ViewControllerdfdfdf.m
//  qiandao
//
//  Created by auto on 2017/3/20.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "ViewControllerdfdfdf.h"
#import "CRNavigationBar.h"
#import "HWCalendar.h"
#import "HWOptionButton.h"


@interface ViewControllerdfdfdf ()< HWCalendarDelegate>

@property (nonatomic, weak) HWCalendar *calendar;


@end

@implementation ViewControllerdfdfdf
@synthesize person = _person ;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES] ;
    _person = [Person read] ;
    [self setNavigationbar] ;
   }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self preferredStatusBarStyle] ;
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    HWCalendar *calendar = [[HWCalendar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/5, [[UIScreen mainScreen]bounds].size.width, 396)];
    calendar.delegate = self;
    calendar.showTimePicker = YES;
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    HWOptionButton * opbutton = [[HWOptionButton alloc]initWithFrame:CGRectMake(0, 30, [[UIScreen mainScreen]bounds].size.width, 50)] ;
    [self.view addSubview:opbutton] ;

    

    // Do any additional setup after loading the view, typically from a nib.
   }
//点击日历的单元格,点击确定后发生的事件
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    NSLog(@"%@",[NSString stringWithFormat:date]);
}



- (void)setNavigationbar
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CRNavigationBar *navigationBar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 66)];
    UIColor * colorUnsigned =[UIColor colorWithRed:39/255.0 green:148/255.0 blue:252/255.0 alpha:1] ;
    UIColor * colorSigned = [UIColor colorWithRed:92/255.0 green:200/255.0 blue:151/255.0 alpha:1] ;
    if ([_person.isSigned integerValue] ==1 ) {
        navigationBar.barTintColor = colorSigned ;
    }else{
        navigationBar.barTintColor = colorUnsigned ;
    }

    NSDictionary * colordic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor] ;


    navigationBar.titleTextAttributes = colordic ;
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"签到记录"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    UIBarButtonItem *rili = [[UIBarButtonItem alloc]initWithTitle:@"日历" style: nil target:self action:@selector(rilishow)];
    rili.tintColor = [UIColor whiteColor] ;
    navigationBarTitle.rightBarButtonItem = rili;
    
    //    //创建UIBarButton 可根据需要选择适合自己的样式
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    //     item.tintColor = [UIColor blackColor] ;
    //设置barbutton
    //    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
}
-(void)rilishow{
    [_calendar show:_person.isSigned];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
