//
//  SignOutControllerViewController.m
//  qiandao
//
//  Created by auto on 2017/3/19.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "SignOutControllerViewController.h"
#import "ViewController.h"
#import "CRNavigationBar.h"
#import <MapKit/MapKit.h>
#import "checkinObject.h"
#import "ObJectToDictionary.h"
#import "AFNetworking.h"
#import "NSObject+NSLocalNotification.h"
#import "WorkTimeInfoArray.h" 
@interface SignOutControllerViewController ()<SignOutControllerProtocol,MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *mgr;
@property (weak, nonatomic) IBOutlet MKMapView *Map;


@end

@implementation SignOutControllerViewController
@synthesize LabelArray = _LabelArray ;
@synthesize tempdate = _tempdate ;
@synthesize delegate = _delegate ;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    WorkTimeInfoArray * InfoArray = [[WorkTimeInfoArray alloc]init] ;
    InfoArray = [WorkTimeInfoArray read] ;
    NSString * datestring = [NSString stringWithString:[[InfoArray.WorkTimeArray objectAtIndex:0] objectForKey:@"check_in_time"]] ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] ;
    _tempdate = [formatter dateFromString:datestring] ;
    
    
    [self preferredStatusBarStyle] ;
    //设定navigationbar
    [self setNavigationbar] ;
    
    //
    _uiview = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height*3/5, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height*2/5)] ;
    _uiview.backgroundColor = [UIColor clearColor] ;
    [self.view addSubview:_uiview] ;

    //
    UIView * Timeview = [[UIView alloc]initWithFrame:CGRectMake(0, -10,[[UIScreen mainScreen]bounds].size.width/2, 100)] ;
    [_uiview addSubview:Timeview] ;

    
    //计时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(GetTimeString) userInfo:nil repeats:YES] ;
    
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:nil] ;//后台运行timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sendDatabag) userInfo:nil repeats:YES] ;
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes] ;
    
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
    _weizhilan.frame = CGRectMake(0, ([[UIScreen mainScreen]bounds].size.height*3/5)-35, [[UIScreen mainScreen]bounds].size.width, 10);
    _weizhilan.backgroundColor = [UIColor whiteColor];

    /////////////////////////////////////////////////

    //初始化数组
    _LabelArray = [[NSMutableArray alloc]init] ;
    
    UILabel * textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, [[UIScreen mainScreen]bounds].size.width/2,50)] ;
    textlabel.textColor = [UIColor lightGrayColor];
    textlabel.textAlignment = NSTextAlignmentCenter ;
    textlabel.text = @" 本次工作时长" ;
    textlabel.font = [UIFont systemFontOfSize:15];
    [_uiview addSubview:textlabel ] ;
    //倒计时label
    UILabel * TimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 33, [[UIScreen mainScreen]bounds].size.width/2,50)] ;
    TimeLabel.text = @"00:00:00" ;
    TimeLabel.textAlignment = NSTextAlignmentCenter ;
    TimeLabel.font = [UIFont systemFontOfSize:35] ;
    [_LabelArray addObject:TimeLabel] ;
    [Timeview addSubview:TimeLabel] ;
    
    //button
    UIButton * SignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    SignBtn.frame =  CGRectMake(([[UIScreen mainScreen]bounds].size.width*3/4) ,0, 80, 80) ;
    [SignBtn setBackgroundColor:[UIColor clearColor] ] ;
    SignBtn.layer.cornerRadius = 10 ;
    SignBtn.layer.masksToBounds = YES ;
    [SignBtn setBackgroundImage:[UIImage imageNamed:@"qianchu.png"] forState:UIControlStateNormal];
    [SignBtn setTitle:@"签出" forState:UIControlStateNormal ] ;
    [SignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [SignBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside] ;
    [_uiview addSubview:SignBtn] ;

    
    
    _uitableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, [[UIScreen mainScreen]bounds].size.width-20, [[UIScreen mainScreen]bounds].size.height*2/5-100) ];
    _uitableview.backgroundColor = [UIColor clearColor] ;
    _uitableview.delegate=self;
    _uitableview.dataSource=self;
    [_uiview addSubview:_uitableview] ;


    // Do any additional setup after loading the view.
}
//获取当前时间，并与服务器传来的签到时间进行比对
- (void)GetTimeString{
    NSDate *date = [NSDate date] ;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] ;
    NSString * datestring = [formatter stringFromDate:date] ;
    date = [formatter dateFromString:datestring] ;
    NSTimeInterval interval = [date timeIntervalSinceDate:_tempdate ] ;
    [self UpDateUi:interval] ;
                    
}

//更新label显示的内容
- (void)UpDateUi :(NSTimeInterval) interval{
    
    NSInteger hour = interval/3600 ;
    NSInteger minute = ( interval -hour *3600)/60 ;
    NSInteger second = (interval - hour *3600 - minute *60) ;
    for (UILabel * label in _LabelArray) {
        label.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second] ;
    }
}
//设置navigationbar
- (void)setNavigationbar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CRNavigationBar *navigationBar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 66)];
    navigationBar.barTintColor= [UIColor colorWithRed:92/255.0 green:200/255.0 blue:151/255.0 alpha:1] ;
    NSDictionary * colordic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor] ;
    navigationBar.titleTextAttributes = colordic ;
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"已签到"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    //    //创建UIBarButton 可根据需要选择适合自己的样式
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    //     item.tintColor = [UIColor blackColor] ;
    //设置barbutton
    //    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
}

//点击签出按钮的方法
- (void)push{
    NSLog(@"向服务器发送签出请求") ;
    [UILocalNotification registerLocalNotification:0 content:@"已经签出" key:@"notification"] ;
    [UILocalNotification cancelLocalNotificationWithKey:@"notification"] ;
    [_timer invalidate] ;
    [_delegate Push] ;
//    ViewController *controller = [[ViewController alloc]init] ;
//    [self presentModalViewController:controller animated:YES] ;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _InfoArray.WorkTimeArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * str=@"setView";
//    UITableViewCell * cell=[_uitableview dequeueReusableCellWithIdentifier:str];
//    if (cell==nil) {
    UITableViewCell* cell=[[UITableViewCell alloc] init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary * tempdic = [_InfoArray.WorkTimeArray objectAtIndex:indexPath.row] ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 签入 ",tempdic[@"check_in_time"]] ;
    cell.imageView.image = [UIImage imageNamed:@"cellphoto2"] ;
    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
//    }
    return cell ;
}
-(instancetype)init{
    if (self=[super init]) {
//        _array = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3", nil] ;
        _person = [Person read] ;
        _InfoArray = [WorkTimeInfoArray read] ;
    }
    return self;
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@"%@",userLocation.location);
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

- (void)sendDatabag{
    
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
    NSString *url=@"https://xsky123.com/check/api.php?q=day_check";
    //发送请求
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        NSLog(@"%@",responsedic) ;
        if ([responsedic[@"code"] integerValue]==200) {
            //            _number++ ;
            if ([_person.isSigned integerValue]!=1) {
                [self showRightWithTitle: @"签到成功" autoCloseTime: 2];
                [_timer invalidate] ;
                [UILocalNotification registerLocalNotification:0 content:@"已经签出" key:@"notification"] ;
                [UILocalNotification cancelLocalNotificationWithKey:@"notification"] ;
                [_delegate Push] ;
               
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //签到失败
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
