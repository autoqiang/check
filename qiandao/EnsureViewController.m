//
//  EnsureViewController.m
//  注册界面
//
//  Created by 杨杨杨 on 2017/3/25.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "EnsureViewController.h"

@interface EnsureViewController ()
{
    UITextField * field;
    UIButton * btnReset;
    NSString * yanzheng;
}
@end

@implementation EnsureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self send] ;
  //  self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"确认信息";
    CGFloat cellwidth = [[UIScreen mainScreen]bounds].size.width ;
    CGFloat cellheight= [[UIScreen mainScreen]bounds].size.height/9;
    // Do any additional setup after loading the view.
    UILabel * lable=[[UILabel alloc] initWithFrame:CGRectMake(0, cellheight, cellwidth, 50)];
    [lable setText:[NSString stringWithFormat:@"请输入手机%@收到的验证码",self.phoneNumber]];
    lable.textAlignment  = NSTextAlignmentCenter ;
    lable.font =[UIFont systemFontOfSize:13];
    [lable setTextColor:[UIColor grayColor]];
    [self.view addSubview:lable];
    
    field=[[UITextField alloc] initWithFrame:CGRectMake(cellwidth/4, cellheight*3, cellwidth/2, 40)];
    [field setBorderStyle:UITextBorderStyleRoundedRect];
    //设置后面会出现的那个叉叉
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    //设置键盘类型
    [field setKeyboardType:UIKeyboardTypeNumberPad];
   
    [self.view addSubview:field];

    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(cellwidth*2/5, cellheight*5, cellwidth/5, 40)];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.backgroundColor  =[UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btnReset=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnReset setFrame:CGRectMake(cellwidth*1/5, cellheight*4, cellwidth*3/5, 40)];
  btnReset.layer.cornerRadius = 5;
    btnReset.backgroundColor  =[UIColor colorWithRed:130/255.0 green:194/255.0 blue:253/255.0 alpha:1];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btnReset setTitle:@"重新发送验证码" forState:UIControlStateNormal];
    [btnReset addTarget:self action:@selector(REset) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnReset];
}
-(void)REset{
    //需要改成只让数字闪烁
    static NSInteger i=0;
    static BOOL flag=0;
    btnReset.enabled=NO;
    NSLog(@"---------%s-------",__func__);
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (flag==0) {
            i=60;flag=1;
        }
        btnReset.enabled=NO;
        NSLog(@"---------%s-------%li",__func__,i);
        [btnReset setTitle:[NSString stringWithFormat:@"%li秒后可重新发送验证码",i] forState:UIControlStateDisabled];
//        btnReset.titleLabel.text = [NSString stringWithFormat:@"%li秒后可重新发送验证码"] ;
        if (i>0)    i--;
        if (i==0) {
            [timer invalidate];
            btnReset.enabled=YES;
            flag=0;
        }
        
    }];
    [self send];
}
-(void)ensure{
    if([field.text isEqualToString:yanzheng]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"现在可以开始登陆了" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //返回两次直接到注册界面
            [self.navigationController popViewControllerAnimated:NO];
            //[self.navigationController popViewControllerAnimated:NO];
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
    else{
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"验证码失败" message:@"请重新输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:okAction];//ok
        [self presentViewController:alertControl animated:YES completion:nil];
        return;
    }
        
}

#pragma - asd
- (void)send{
    NSLog(@"发送验证码了");
    yanzheng=@"111111";
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(![self.view isExclusiveTouch]){
        [self.view resignFirstResponder];
    }
    if(![field isExclusiveTouch]){
        [field resignFirstResponder];
    }
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
