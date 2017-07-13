//
//  ZMChangePasswordViewController.m
//  找回密码界面
//
//  Created by 杨杨杨 on 2017/3/31.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "ZMChangePasswordViewController.h"
#import "AFNetworking.h"
@interface ZMChangePasswordViewController ()<UITextFieldDelegate>
{
    UITextField * field;
    UITextField * field_two;
}
@end

@implementation ZMChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"重置密码";
    
    
    UIButton * btn=[[UIButton alloc] initWithFrame:CGRectMake(
                                                              [UIScreen mainScreen].bounds.size.width*0.4,
                                                              [UIScreen mainScreen].bounds.size.height*0.4,
                                                              [UIScreen mainScreen].bounds.size.width*0.2,
                                                              [UIScreen mainScreen].bounds.size.height*0.0618)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    btn.backgroundColor = [UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1];
    btn.tintColor=[UIColor blueColor];
    btn.layer.cornerRadius=20;
    [self.view addSubview:btn];
    
    field=[[UITextField alloc] initWithFrame:CGRectMake(
                                                        [UIScreen mainScreen].bounds.size.width*0.2,
                                                        [UIScreen mainScreen].bounds.size.height*0.2,
                                                        [UIScreen mainScreen].bounds.size.width*0.6,
                                                        [UIScreen mainScreen].bounds.size.height*0.0618)];
    [field setPlaceholder:@"请输入新密码"];
    [self.view addSubview:field];
    //设置风格
    [field setBorderStyle:UITextBorderStyleRoundedRect];
    //设置后面会出现的那个叉叉
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    //设置键盘类型
    [field setKeyboardType:UIKeyboardTypeDefault];
    [field setKeyboardAppearance:UIKeyboardAppearanceAlert] ;
    [self.view addSubview:field];
    field.delegate=self;
    [field setSecureTextEntry:YES] ;
    
    field_two=[[UITextField alloc] initWithFrame:CGRectMake(
                                                                                       [UIScreen mainScreen].bounds.size.width*0.2,                   [UIScreen mainScreen].bounds.size.height*0.3,        [UIScreen mainScreen].bounds.size.width*0.6,
                                                                [UIScreen mainScreen].bounds.size.height*0.0618)];
    [field_two setPlaceholder:@"请再次输入新密码"];
    //设置风格
    [field_two setBorderStyle:UITextBorderStyleRoundedRect];
    //设置后面会出现的那个叉叉
    [field_two setClearButtonMode:UITextFieldViewModeWhileEditing];
    //设置键盘类型
    [field_two setKeyboardType:UIKeyboardTypeNumberPad];
    [field_two setKeyboardAppearance:UIKeyboardAppearanceAlert] ;
    [self.view addSubview:field_two];
    field_two.delegate=self;
    [field_two setSecureTextEntry:YES] ;
    
    
    
}

-(void)btnPressed{
    if ([field.text isEqualToString:field_two.text]||field.text.length>=6) {
        [self send];
        #pragma mark - 在这里直接返回登录界面,但是有没有更好的方法呢
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popViewControllerAnimated:NO];
//        [self.navigationController popViewControllerAnimated:NO];

    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* act=[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:act];
        [self presentViewController:alert animated:NO completion:nil];
    }
}
#pragma mark - 在这里发送修改后信息
-(void)send{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    //接口地址、、
    NSString *url=@"https://xsky123.com/check/api.php?q=reset_pw";
    //发送请求
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init] ;
    [dic setObject:self.phoneNumber forKey:@"mobile"] ;
    [dic setObject:self.yanzheng forKey:@"code"] ;
    [dic setObject:field.text forKey:@"passwd"] ;
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        if ([responsedic[@"code"] integerValue]==200) {
            NSLog(@"修改密码成功");
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //签到失败
        
    }];
    

    
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
