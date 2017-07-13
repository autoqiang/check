//
//  ZMBackPasswordViewController.m
//  找回密码界面
//
//  Created by 杨杨杨 on 2017/3/31.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "ZMBackPasswordViewController.h"
#import "ZMSureViewController.h"
#import "AFNetworking.h"
@interface ZMBackPasswordViewController ()<UITextFieldDelegate>
{
    UITextField * field;
}
@end

@implementation ZMBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"找回密码";

    
    UIButton * btn=[[UIButton alloc] initWithFrame:CGRectMake(
                                                             [UIScreen mainScreen].bounds.size.width*0.4,
                                                             [UIScreen mainScreen].bounds.size.height*0.3,
                                                             [UIScreen mainScreen].bounds.size.width*0.2,
                                                             [UIScreen mainScreen].bounds.size.height*0.0618)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=20;
    btn.backgroundColor = [UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1];
    btn.tintColor=[UIColor blueColor];
    [self.view addSubview:btn];
    
    field=[[UITextField alloc] initWithFrame:CGRectMake(
                                                        [UIScreen mainScreen].bounds.size.width*0.2,
                                                        [UIScreen mainScreen].bounds.size.height*0.2,
                                                        [UIScreen mainScreen].bounds.size.width*0.6,
                                                        [UIScreen mainScreen].bounds.size.height*0.0618)];
    [field setPlaceholder:@"请输入手机号"];
    [self.view addSubview:field];
    //设置风格
    [field setBorderStyle:UITextBorderStyleRoundedRect];
    //设置后面会出现的那个叉叉
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    //设置键盘类型
    [field setKeyboardType:UIKeyboardTypeNumberPad];
    [field setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [self.view addSubview:field];
    field.delegate=self;
    [field setSecureTextEntry:NO] ;
    
    

}

-(void)btnPressed{
    if([self ensurePhone])
    {
        ZMSureViewController * zms=[[ZMSureViewController alloc] init];
        zms.phoneNumber=field.text;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //如果报接受类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
        
        //接口地址、、
        NSString *url=@"https://xsky123.com/check/api.php?q=forget_pw";
        //发送请求
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init] ;
        [dic setObject:zms.phoneNumber forKey:@"mobile"] ;
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
            NSLog(@"%@",responsedic) ;
            if ([responseObject[@"code" ] integerValue]==200) {
                [self.navigationController pushViewController:zms animated:NO];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //签到失败
            
        }];

    }
    else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"不存在该用户" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];//ok
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"---------%s-------",__func__);
}
-(BOOL)ensurePhone{
#pragma mark - 在这里确认是否输入了正确的电话号码(向服务器发送请求)
    //不存在就返回NO
    //  self.phoneNumber 是输入的电话号
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    
    [textField resignFirstResponder];
    return YES;
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
