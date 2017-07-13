//
//  LoginControllerViewController.m
//  qiandao
//
//  Created by auto on 2017/3/25.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "LoginControllerViewController.h"
#import "Person.h"
#import "CRNavigationBar.h"
#import "tabbarViewController.h"
#import "SigncontrollerObject.h"
#import "ObJectToDictionary.h"
#import "AFNetworking.h"
#import "zhuceViewController.h"
#import "ZMBackPasswordViewController.h"
#import "NameloginObject.h"

@interface LoginControllerViewController ()<UITextFieldDelegate>

@end

@implementation LoginControllerViewController
@synthesize NameView = _NameView ;
@synthesize PwdView = _PwdView ;
@synthesize uiview = _uiview ;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES] ;
    self.navigationController.navigationBarHidden = YES ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavigationbar] ;
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    _uiview = [[UIView alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen]bounds].size.width-300)/2, [[UIScreen mainScreen]bounds].size.height/4, 300, 450)] ;
    _uiview.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_uiview] ;
    _NameView = [[UITextField alloc]initWithFrame:CGRectMake(30, 30, 240, 40)] ;
    _PwdView = [[UITextField alloc]initWithFrame:CGRectMake(30, 90, 240, 40)] ;
    _NameView.borderStyle = UITextBorderStyleRoundedRect ;
    _PwdView.borderStyle = UITextBorderStyleRoundedRect ;
    _NameView.textAlignment = NSTextAlignmentLeft ;
    _NameView.placeholder = @"手机号" ;
    _PwdView.textAlignment = NSTextAlignmentLeft;
    _PwdView.placeholder = @"密码" ;
    [_PwdView setSecureTextEntry:YES] ;
    _person = [Person read] ;
    if (_person.mobile!=nil) {
        _NameView.text = _person.mobile ;
        _PwdView.text = _person.passwd ;
//        [self push:nil] ;
    }
    
    [_uiview addSubview:_NameView ] ;
    [_uiview addSubview:_PwdView] ;
    
    
    
    UIButton  * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn.layer.cornerRadius = 5;
    btn.frame = CGRectMake(30, 150, 240, 40) ;
    btn.backgroundColor = [UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1] ;
    [btn setTitle:@"登录" forState:UIControlStateNormal] ;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside] ;
    [_uiview addSubview:btn ] ;
    
    UIButton  * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn1.frame = CGRectMake(30, 210, 240, 40) ;
    btn1.backgroundColor = [UIColor whiteColor] ;
    [btn1 setTitle:@"忘记密码" forState:UIControlStateNormal] ;
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
    [btn1 addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside] ;
    [_uiview addSubview:btn1 ] ;
    
    UIButton  * btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn2.frame = CGRectMake(30, 270, 240, 40) ;
    btn2.backgroundColor = [UIColor whiteColor] ;
    [btn2 setTitle:@"没有账号？去注册" forState:UIControlStateNormal] ;
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
    [btn2 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside] ;
    [_uiview addSubview:btn2 ] ;
    
    // Do any additional setup after loading the view.
}
//登录
- (void)push:(id)sender{
    NSLog(@"登陆");
    [sender setUserInteractionEnabled:NO]  ;
    id object ;
    if ([_NameView.text integerValue]>0) {
        SigncontrollerObject * objectmobile = [[SigncontrollerObject alloc]init] ;
        objectmobile.mobile = _NameView.text ;
        objectmobile.passwd = _PwdView.text ;
        object = objectmobile ;
    }else{
        NameloginObject * objectname = [[NameloginObject alloc]init] ;
        objectname.name = _NameView.text ;
        objectname.passwd = _PwdView.text ;
        object = objectname ;
    }
    
    
//    if ((![object.mobile isEqual:@"手机号"])&&(![object.passwd isEqual:@"密码"])) {
    
        NSDictionary *dic = [ObJectToDictionary ObjectToDictionary:object] ;
        NSLog(@"%@",dic) ;
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] ;
        NSString * jsonstring = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
        NSRange range = {0,jsonstring.length} ;
        NSMutableString * mutstr = [NSMutableString stringWithString:jsonstring] ;
        [mutstr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range] ;
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
        
        //接口地址、、
        NSString *url=@"https://xsky123.com/check/api.php?q=login";
        //发送请求
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString  *tempstring = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] ;
            NSData * data = [tempstring dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] ;
            NSLog(@"dic:%@",dic) ;
            //登录状态判断
            if ([dic[@"code"] integerValue]==200) {
                [self loginsuccessed:dic[@"data"]] ;
            }else if ([dic[@"code"] integerValue] ==404||[dic[@"code"] integerValue] ==403) {
                [self loginshibai:sender] ;
            }else{
                [self loginshibai:sender] ;
            }
//            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self CannotConnectWithServer:sender] ;
            
        }];
        
//    }else{
//        NSLog(@"暂未连接服务器") ;
//    }

}

//忘记密码
- (void)push1{
    NSLog(@"忘记密码");
    //点完之后传送用户信息 弹回tabbbarcontroller
    self.navigationController.navigationBarHidden = NO ;
    [self.navigationController pushViewController:[[ZMBackPasswordViewController alloc] init] animated:NO];
}
//注册
- (void)push2{
    NSLog(@"注册");
    self.navigationController.navigationBarHidden = NO ;
    zhuceViewController * zhuce = [[zhuceViewController alloc]init] ;
    [self.navigationController pushViewController:zhuce animated:YES ];
    
    //点完之后传送用户信息 弹回tabbbarcontroller
}
//登录成功
- (void)loginsuccessed:(NSDictionary*)dic{
    //获取数据
    Person * userperson = [[Person alloc]init] ;
    userperson.apartment = dic[@"apartment"] ;
    userperson.company = dic[@"company"] ;
    userperson.email = dic[@"email"] ;
    userperson.mobile = dic[@"mobile"] ;
    userperson.name = dic[@"name"] ;
    userperson.passwd = dic[@"passwd"] ;
    userperson.staff_num = dic[@"staff_num"] ;
    userperson.staff_id = dic[@"staff_id"] ;
    userperson.isSigned = dic[@"check_in"] ;
    
    //就是调试用的测试输出
    NSDictionary * person = [ObJectToDictionary ObjectToDictionary:userperson] ;
    NSLog(@"person:%@",person) ;
    [userperson save] ;
    LKNotificationBar *notificationBar = [[self getLKNotificationManager] createWithTitle: @"登录成功" content:[NSString stringWithFormat:@"%@ 欢迎回来",userperson.name] icon: [UIImage imageNamed: @"test"]];
    notificationBar.delegate = self;
    [notificationBar showWithAnimated: YES];
    
    //切换根视图
    tabbarViewController * a = [[tabbarViewController alloc]init] ;
    UIApplication.sharedApplication.delegate.window.rootViewController = a ;

}
-(void)loginshibai:(id)sender{
    [self showErrorWithTitle:@"用户名密码错误" autoCloseTime:2];
       [sender setUserInteractionEnabled:YES] ;
    
}
-(void)CannotConnectWithServer:(id)sender{
          [self showErrorWithTitle:@"网络异常" autoCloseTime:2];
    [sender setUserInteractionEnabled:YES] ;
    
}
- (void)onNavigationBarTouchUpInside:(LKNotificationBar *)navigationBar{
    NSLog(@"TOUCH !@");
    [navigationBar hideWithAnimated: YES];
}

//收起键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(![_NameView isExclusiveTouch]){
        [_NameView resignFirstResponder];
    }
    if(![_PwdView isExclusiveTouch]){
        [_PwdView resignFirstResponder];
    }
}

//设置导航栏
- (CRNavigationBar *)setNavigationbar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CRNavigationBar *navigationBar = [[CRNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 66)];
    navigationBar.barTintColor= [UIColor colorWithRed:39/255.0 green:148/255.0 blue:252/255.0 alpha:1] ;
    NSDictionary * colordic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor] ;
    navigationBar.titleTextAttributes = colordic ;
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@""];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    //    //创建UIBarButton 可根据需要选择适合自己的样式
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    //     item.tintColor = [UIColor blackColor] ;
    //设置barbutton
    //    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    return navigationBar ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
