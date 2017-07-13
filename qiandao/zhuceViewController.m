//
//  ViewController.m
//  注册界面
//
//  Created by 杨杨杨 on 2017/3/25.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "zhuceViewController.h"
#import "EnsureViewController.h"
#import "AFNetworking.h"
#import "Person.h"
#import "ObJectToDictionary.h"

@interface zhuceViewController ()<UITextFieldDelegate>
{
    Person * _person;
    UITextField * field[7];
}
@end

@implementation zhuceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    _person=[[Person alloc] init];
    CGFloat cellwidth = [[UIScreen mainScreen]bounds].size.width ;
    CGFloat cellheight= [[UIScreen mainScreen]bounds].size.height/9;
    for (int i=0; i<7; i++) {
    NSArray * array=@[@"公司部门",@"姓名",@"工号",@"电话",@"电子邮件",@"密码",@"确认密码"];
        UILabel * lable=[[UILabel alloc] initWithFrame:CGRectMake(0, cellheight*3/4+cellheight*3/4*(i+1), cellwidth/3,cellheight/2 )];
        [lable setBackgroundColor:[UIColor clearColor]];
        [lable setText:array[i]];
        [lable setTextColor:[UIColor grayColor]];
        lable.textAlignment = NSTextAlignmentCenter ;
        [self.view addSubview:lable];
        lable.font = [UIFont systemFontOfSize:15];
        
        field[i]=[[UITextField alloc] initWithFrame:CGRectMake(cellwidth/3 , cellheight*3/4+cellheight*3/4*(i+1), cellwidth*3/5, cellheight/2)];
        //设置风格
        [field[i] setBorderStyle:UITextBorderStyleRoundedRect];
        //设置后面会出现的那个叉叉
        [field[i] setClearButtonMode:UITextFieldViewModeWhileEditing];
        //设置键盘类型
        if(i==3||i==2)
           [field[i] setKeyboardType:UIKeyboardTypeNumberPad];
        else
            [field[i] setKeyboardType:UIKeyboardTypeDefault];
        [field[i] setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self.view addSubview:field[i]];
        field[i].delegate=self;
        if (i==5||i==6) {
            [field[i] setSecureTextEntry:YES] ;
        }
        
    }
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btn setFrame:CGRectMake(cellwidth*2/3,cellheight*7, 100, 40)];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
//点击下一步
-(void)btnNext{
    
    _person.company=field[0].text;
    _person.name=field[1].text;
    _person.staff_id=field[2].text;
    _person.mobile=field[3].text;
    _person.email=field[4].text;
    _person.passwd=field[5].text;
    
    
    if([self isEmpty]||![self isValid]){
        return;
    }
    [self networking] ;
    NSLog(@"%@",_person);
    EnsureViewController * cv= [[EnsureViewController alloc] init];
    cv.phoneNumber=_person.mobile;
    NSLog(@"%@",self.navigationController) ;
    [self.navigationController pushViewController:cv animated:YES];
    
}
//判断输入是否为空

-(BOOL)isEmpty{
    if([_person.company isEqualToString:@""])
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"没有选择公司" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
#pragma mark - 这里的判断
    if(/* DISABLES CODE */ (0)/*公司部门不存在*/)
    {
        {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"公司部门信息错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertControl addAction:okAction];//ok
            [self presentViewController:alertControl animated:YES completion:nil];
            return YES;
        }
    }
    if([_person.name isEqualToString:@""])
    {   
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"没有输入名字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    if([_person.staff_id isEqualToString:@""])
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"没有输入工号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    if([_person.email rangeOfString:@"@"].length==0)
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"电子邮件格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    if([_person.mobile isEqualToString:@""])
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"没有输入电话号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    if(_person.mobile.length!=11){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"电话号长度不正确" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    if([_person.passwd isEqualToString:@""])
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"没有输入密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return YES;
    }
    return NO;
}
//判断密码输入是否相同
-(BOOL)isValid{
    if(![self testInfo])
    {
        return NO;
    }
    if (field[5].text.length<=5) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"密码长度过短" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return NO;
    }
    if (![field[5].text isEqualToString:field[6].text]) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    
    [textField resignFirstResponder];
    return YES;
}
#pragma - 这里添加方法
-(BOOL)testInfo{
    enum Exist{hasExisted,notExisted};
    enum Exist isExist=notExisted;
    //两种情况,存在和不存在
    /*
     向网络询问数据,并对isExist赋值
     */
    if (isExist==notExisted) {
        return YES;
    }
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"信息错误!" message:@"该用户已存在" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:okAction];//ok
    [self presentViewController:alertControl animated:YES completion:nil];
    
    return NO;
}
//点击屏幕任意位置收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (int i=0; i<7; i++) {
        [field[i] resignFirstResponder];
    }
}

- (void)networking{
    NSDictionary * dic = [ObJectToDictionary ObjectToDictionary:_person] ;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    //接口地址、、
    NSString *url=@"https://xsky123.com/check/api.php";
    //发送请求
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString * string = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        NSLog(@"%@",string) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
}
/*
//按下return回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"---------%s-------",__func__);
    return YES;
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
