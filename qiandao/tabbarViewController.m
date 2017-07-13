//
//  tabbarViewController.m
//  qiandao
//
//  Created by auto on 2017/3/20.
//  Copyright © 2017年 auto. All rights reserved.
//

#import "tabbarViewController.h"
#import "ViewController.h" 
#import "SignOutControllerViewController.h"
#import "SigncontrollerObject.h"
#import "LoginControllerViewController.h"
@interface tabbarViewController ()<SignOutControllerProtocol>

@end

@implementation tabbarViewController
@synthesize object = _object ;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES] ;
    _person = [Person read] ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _object = [[SigncontrollerObject alloc]init] ;//用来判断是否签到 以后会用一个数据包代替
    LoginControllerViewController * NewloginViewcontroller = [[LoginControllerViewController alloc]init] ;
    [self presentModalViewController:NewloginViewcontroller animated:NO] ;
    NSLog(@"~~~~~~~~~~~~~~~~~") ;
    
    [self UpDateUi] ;
//    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 120, 100,100)] ;
//    btn.backgroundColor =[UIColor blueColor] ;
//    [btn addTarget:self action:@selector(Push) forControlEvents:UIControlEventTouchUpInside] ;
//    [self.view addSubview:btn] ;
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)UpDateUi{
//    ViewController * controller1 = [[ViewController alloc]init] ;
//    SignOutControllerViewController * controller2 = [[SignOutControllerViewController alloc]init] ;
    controller = [[SignOutControllerViewController alloc]init] ;
    controller2 = [[ViewController alloc]init] ;
    temp = [[ViewControllerdfdfdf alloc]init] ;
    setviewcontroller = [[SetViewController alloc]init] ;
    UINavigationController* qwe=[[UINavigationController alloc] initWithRootViewController:setviewcontroller] ;
    qwe.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"unpressed2"]selectedImage:[UIImage imageNamed:@"pressed2"]] ;
    
    [controller setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"已签到" image:[UIImage imageNamed:@"unpressed3"] selectedImage:[UIImage imageNamed:@"pressed4"]] ] ;
    [controller2 setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"未签到" image:[UIImage imageNamed:@"unpressed3"] selectedImage:[UIImage imageNamed:@"pressed3"]] ] ;
    [temp setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"签到记录" image:[UIImage imageNamed:@"unpressed1"] selectedImage:[UIImage imageNamed:@"pressed1"]]] ;
    [setviewcontroller setTabBarItem:[[UITabBarItem alloc]initWithTitle:@"设置"image:[UIImage imageNamed:@"unpressed2"]selectedImage:[UIImage imageNamed:@"pressed2"] ]] ;
    
    controller.delegate = self ;
    controller2.delegate = self ;
    NSLog(@"update") ;
    
    //    NSArray *unpressedArray=@[@"unpressed1",@"unpressed2",@"unpressed3",@"unpressed4"];
    // Do any additional setup after loading the view.
    
    
        if (_object->_isSigned ==0) {
        [self setViewControllers:@[controller2,temp,qwe] animated:NO] ;
            NSLog(@"a") ;
    }else{
        [self setViewControllers:@[controller,temp,qwe] animated:NO] ;
        NSLog(@"b");
    }
    
    
}
- (void)Push{

        NSLog(@"push") ;
    //改变登录状态
    [_object ChangeTheSign] ;
    int tempint = [_object GetTheSignNumber] ;
    NSNumber * tempnumber = [NSNumber numberWithInt:tempint] ;
    _person.isSigned = tempnumber ;
    [_person save] ;
    [self UpDateUi] ;

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
