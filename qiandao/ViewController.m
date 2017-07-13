//
//  ViewController.m
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "ViewController.h"
#import "SignOutControllerViewController.h"
#import "CRNavigationBar.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ObJectToDictionary.h"
#import "checkinObject.h" 
#import "Person.h"
#import "AFNetworking.h"
#import "WorkTimeInfoArray.h"
@interface ViewController ()<MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *mgr;
@property (weak, nonatomic) IBOutlet MKMapView *Map;
@end

@implementation ViewController
@synthesize date = _date ;
@synthesize DateString =_DateString ;
@synthesize TimeString =_TimeString ;
@synthesize Datelabel = _Datelabel ;
@synthesize LabelArray =_LabelArray ;
@synthesize delegate = _delegate ;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES] ;
    self.Map.userTrackingMode = MKUserTrackingModeFollow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkin = [[checkinObject alloc]init] ;
    self.person = [[Person alloc]init] ;
    self.person = [Person read] ;
     [self getcheckinlogs] ;
    
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    //调用更改电池栏风格方法
    [self preferredStatusBarStyle] ;
///////////////////////////////////////////////////地图框架
    self.mgr = [CLLocationManager new];//创建Manger对象
    //请求用户授权在ios8 以上系统
    if([UIDevice currentDevice].systemVersion.floatValue >=8.0){
        
        [self.mgr requestAlwaysAuthorization];
        [self.mgr startUpdatingLocation];
    }
    //用户跟踪
   self.Map.userTrackingMode =  MKUserTrackingModeFollow;
    self.Map.delegate = self;
    self.Map.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height*2.75/5);
    _maoboli.frame =CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height*2.75/5);
/////////////////////////////////////////////////
    //初始化uiview
    _uiview = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height*3/5, [[UIScreen mainScreen]bounds].size.width, ([[UIScreen mainScreen]bounds].size.height*2/5)+10)] ;
    _uiview.backgroundColor = [UIColor clearColor] ;
    [self.view addSubview:_uiview] ;
    _weizhilan.frame = CGRectMake(0, ([[UIScreen mainScreen]bounds].size.height*3/5)-35, [[UIScreen mainScreen]bounds].size.width, 10);
    _weizhilan.backgroundColor = [UIColor whiteColor];
    _LabelArray = [[NSMutableArray alloc]init] ;//初始化数组
    [self setNavigationbar] ;//向视图添加navigationbar
    [self GetPresentDate] ;//获取当前时间 生成相应字符串 并更新label显示
    
    
    //计时器1 周期性获取当前时间
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSTimer *timer = [NSTimer timerWithTimeInterval:40.0 target:self selector:@selector(GetPresentDate) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
    //计时器2 周期性发送数据包
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:nil] ;//后台运行timer2
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(sendDatabag:) userInfo:nil repeats:YES] ;
    [[NSRunLoop currentRunLoop]addTimer:self.timer2 forMode:NSRunLoopCommonModes] ;
    
    
    //存放时间和日期的uiview 
    UIView * TimeLabelsView = [[UIView alloc]initWithFrame:CGRectMake(0, -10,[[UIScreen mainScreen]bounds].size.width/2, 100)] ;
    TimeLabelsView.backgroundColor = [UIColor clearColor] ;
    
    
    //时间的label
    UILabel * time  = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, [[UIScreen mainScreen]bounds].size.width/2, 50)] ;
    time.text = _TimeString ;
    time.textAlignment = NSTextAlignmentCenter ;
    time.font = [UIFont systemFontOfSize:50] ;
    time.adjustsFontSizeToFitWidth = YES  ;
    [_LabelArray addObject:time] ;
    [TimeLabelsView addSubview:time] ;
    
    [_uiview addSubview:TimeLabelsView] ;
    
    //日期的label
    _Datelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width/2,50) ] ;
    _Datelabel.text = _DateString ;
    _Datelabel.font = [UIFont systemFontOfSize:15];
    _Datelabel.backgroundColor = [UIColor clearColor] ;
    _Datelabel.textAlignment = UITextAlignmentCenter ;
    [TimeLabelsView addSubview:_Datelabel] ;
    _Datelabel.textColor = [UIColor grayColor];
    //签到button
    UIButton * SignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    SignBtn.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width*3/4) ,0, 80, 80)  ;
    [SignBtn setBackgroundColor:[UIColor clearColor] ] ;
    [SignBtn setBackgroundImage:[UIImage imageNamed:@"qiandao.png"] forState:UIControlStateNormal];
    SignBtn.layer.cornerRadius = 10 ;
    SignBtn.layer.masksToBounds = YES ;
    [SignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [SignBtn setTitle:@"签到" forState:UIControlStateNormal ] ;
    [SignBtn addTarget:self action:@selector(Push) forControlEvents:UIControlEventTouchUpInside] ;
    
    [_uiview addSubview:SignBtn] ;
    
    
  /*  //重新定位button
    UIButton * Locationbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Locationbutton.frame = CGRectMake([[UIScreen mainScreen]bounds].size.width/2, 0, [[UIScreen mainScreen]bounds].size.width/4, 100) ;
    [Locationbutton setBackgroundColor:[UIColor whiteColor]] ;
    [Locationbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    Locationbutton.layer.cornerRadius = 10 ;
    Locationbutton.layer.masksToBounds = YES ;
    [Locationbutton setTitle:@"定位" forState:UIControlStateNormal] ;
    //缺少一个按下按钮的方法
    [_uiview addSubview:Locationbutton] ;*/
    
    
    //数据视图
    _uitableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height*2/5-140) ];
    _uitableview.backgroundColor = [UIColor clearColor] ;
    _uitableview.delegate=self;
    _uitableview.dataSource=self;
    [_uiview addSubview:_uitableview] ;
    // Do any additional setup after loading the view, typically from a nib.
}
//获取时间的方法 注意最后调用了更新ui的方法
-(void)GetPresentDate{
    _date = [NSDate date] ;
    NSDateFormatter *TimeFormatter = [[NSDateFormatter alloc]init] ;
    [TimeFormatter setDateFormat:@"HH:mm"] ;
    _TimeString = [TimeFormatter stringFromDate:_date] ;
    
    
    
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init] ;
    [DateFormatter setDateFormat:@"yyyy年MM月dd日 "] ;
    _DateString = [DateFormatter stringFromDate:_date] ;
    
    [self UpDateUi] ;
}
//更新了所有label的显示内容
- (void)UpDateUi{
    for (UILabel * temp in _LabelArray) {
        temp.text = _TimeString ;
    }
    _Datelabel.text = _DateString ;
}
//创建navigationbar
- (void)setNavigationbar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CRNavigationBar *navigationBar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 66)];
    navigationBar.barTintColor= [UIColor colorWithRed:39/255.0 green:148/255.0 blue:252/255.0 alpha:1] ;
    NSDictionary * colordic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor] ;
    navigationBar.titleTextAttributes = colordic ;
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"未签到"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    UIBarButtonItem * shuaxinbutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"location.png"] style:nil target:self action:@selector(shuaxin)];
    shuaxinbutton.tintColor = [UIColor whiteColor] ;
    navigationBarTitle.rightBarButtonItem = shuaxinbutton;
    /*UIBarButtonItem * listbutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list.png"] style:nil target:self action:@selector(shuaxin)];
    listbutton.tintColor = [UIColor whiteColor] ;
    navigationBarTitle.leftBarButtonItem = listbutton;*/
    navigationBarTitle.rightBarButtonItem = shuaxinbutton;
 
    [self.view addSubview: navigationBar];
    //    //创建UIBarButton 可根据需要选择适合自己的样式
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    //     item.tintColor = [UIColor blackColor] ;
    //设置barbutton
    //    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
}
-(void)shuaxin{
    //返回中心点
    CLLocationCoordinate2D coordinate = self.Map.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    self.Map.region = MKCoordinateRegionMake(coordinate, span);
}
//向服务器传送数据的方法 按下button后生效
- (void) Push {
//     [self showRightWithTitle: @"签到成功" autoCloseTime: 2];
//    NSLog(@"签到按下 向服务器发送签到申请") ;
//    _number++ ;
//    [_delegate Push] ;
    [self sendDatabag:1] ;
//    if ([_responsedic[@"code"] integerValue]==200) {
//        //            _number++ ;
//        if ([_person.isSigned integerValue]!=1) {
//            [self showRightWithTitle: @"签到成功" autoCloseTime: 2];
//            [_delegate Push] ;
//            [_timer2 invalidate] ;
//        }
//        
//    }else{
//        [self showErrorWithTitle:@"签到范围外" autoCloseTime:2] ;
//    }

    
}
//更改电池栏风格为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent ;
}

//数据视图的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * str=@"setView";
//    UITableViewCell * cell=[_uitableview dequeueReusableCellWithIdentifier:str];
//    if (cell==nil) {
    UITableViewCell*cell=[[UITableViewCell alloc] init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *tempdic = [[NSDictionary alloc]initWithDictionary:[_InfoArray.WorkTimeArray objectAtIndex:indexPath.row]] ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 工作%.1f分钟", [tempdic objectForKey:@"check_out_time"],[[tempdic objectForKey:@"Work_Time"] floatValue]] ;
    cell.imageView.image = [UIImage imageNamed:@"cellphoto1"] ;
    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
    
//    }
    return cell ;
}
-(instancetype)init{
    if (self=[super init]) {
        if (_checkinlogsdic!=nil) {
             _array = [[NSMutableArray alloc]initWithArray:_checkinlogsdic[@"data"]];
        }
        
       
    }
    return self;
}
///////////////////////////////////////////////地图地理信息
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"%@",userLocation.location);
    //显示当前地理位置
    CLGeocoder * geocoder = [CLGeocoder new];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray< CLPlacemark *> * __nullable placemarks, NSError * __nullable error){
        if(placemarks.count == 0||error){
//            NSLog(@"解析出错");
            return ;
        }
        for (CLPlacemark *placemark in placemarks){
            _weizhi.text = [NSString stringWithFormat: @"当前位置:%@",placemark.name];
             _weizhi.font = [UIFont systemFontOfSize:15];
            _weizhi.textColor = [UIColor lightGrayColor];
        }
    }];
        
    
    
}


- (void)sendDatabag:(NSInteger)flag{
    
    self.checkin = [[checkinObject alloc]init] ;
    [self.checkin getUserid:_person.staff_id andlng:@"100" andlat:@"100"] ;//此处经纬度的变量类型都是nsstring 可能需要你把得到的数据转为这个格式  ;
    
    
    
    NSDictionary * dic = [ObJectToDictionary ObjectToDictionary:self.checkin] ;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    //接口地址、、
    NSString *url=@"https://xsky123.com/check/api.php?q=check";
    //发送请求
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
         _responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        NSLog(@"%@",_responsedic) ;
        if ([_responsedic[@"code"] integerValue]==200) {
            if ([_person.isSigned integerValue]!=1) {
                [self showRightWithTitle: @"签到成功" autoCloseTime: 2];
                [_delegate Push] ;
                [_timer2 invalidate] ;
            }
        }else{
            if (flag==1) {
                [self showErrorWithTitle:@"超出范围" autoCloseTime:2] ;
            }
        }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
                //签到失败
        
    }];

}
- (void)getcheckinlogs{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init] ;
    if (_person.staff_id!=nil) {
        [dic setObject:_person.staff_id forKey:@"user_id" ] ;
    }
    

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    //接口地址、、
    NSString *url=@"https://xsky123.com/check/api.php?q=check_log";
    //发送请求
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _checkinlogsdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        _array = [[NSMutableArray alloc]initWithArray:_checkinlogsdic[@"data"]];
        _InfoArray = [[WorkTimeInfoArray alloc]init] ;
        _InfoArray = [_InfoArray initwithArray:_array] ;
//        NSLog(@"~~~~~%@",_InfoArray.WorkTimeArray) ;
         [_InfoArray save] ;
        [_uitableview reloadData] ;
//        NSLog(@"%@",_checkinlogsdic) ;
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //签到失败
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
 
