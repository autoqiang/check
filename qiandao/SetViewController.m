//
//  SetViewController.m
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "SetViewController.h"
#import "ImformationViewController.h"
#import "CRNavigationBar.h"
@interface SetViewController ()
{
    UITableView * _tableView;
    ImformationViewController * personView;
    
}
@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES] ;
    self.tabBarController.tabBar.hidden = NO ;
    _person = [Person read] ;
    _company.text=[NSString stringWithFormat:@"%@ %@",self.person.company,self.person.apartment];
    _username.text=[NSString stringWithFormat:@"%@",self.person.name];
   
  //  [self setNavigationbar] ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES ;
        
    [self preferredStatusBarStyle] ;
     _person = [Person read] ;
    _company.text=[NSString stringWithFormat:@"%@ %@",self.person.company,self.person.apartment];
     _username.text=[NSString stringWithFormat:@"%@",self.person.name];
    _photo.layer.cornerRadius = _photo.frame.size.width/2 ;
    _photo.layer.masksToBounds = YES ;

    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height)  style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_view2 addSubview:_tableView];
    
    UIColor * colorUnsigned =[UIColor colorWithRed:39/255.0 green:148/255.0 blue:252/255.0 alpha:1] ;
    UIColor * colorSigned = [UIColor colorWithRed:92/255.0 green:200/255.0 blue:151/255.0 alpha:1] ;
    if ([_person.isSigned integerValue] ==1 ) {
        _view1.backgroundColor = colorSigned ;
    }else{
         _view1.backgroundColor  = colorUnsigned ;
    }

    
    personView =[[ImformationViewController alloc] init];
    
}
-(void)switchQiandao:(UISwitch*)swi{
    if (swi.on) {
        NSLog(@"打开了");
    }
    else{
        NSLog(@"关闭了");
    }
}
-(void)switchTixing:(UISwitch*)swi{
    if (swi.on) {
        NSLog(@"打开了");
    }
    else{
        NSLog(@"关闭了");
    }
}
//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?4:1;
}
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                
                self.tabBarController.tabBar.hidden = YES ;
                [self.navigationController pushViewController:personView animated:YES];
                
                NSLog(@"点击了个人信息界面");
                break;
            case 1:
                NSLog(@"点击了自动签到");
                if (sw1.on ==YES) {
                    sw1.on=NO ;
                }else{
                    sw1.on =YES ;
                }
                break;
            case 2:
                NSLog(@"点击了提醒");
                if (sw2.on ==YES) {
                    sw2.on=NO ;
                }else{
                    sw2.on =YES ;
                }
                break;
            case 3:
                NSLog(@"打卡记录");
                break;
                //        case 4:
                //            NSLog(@"退出当前账户");
                //            break;
            default:
                break;
        }

    }else if(indexPath.section==1){
        NSLog(@"点击了退出") ;
    }
   }


//设置单元格具体内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str=@"setView";
    
    UITableViewCell * cell=[_tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
                    cell.textLabel.text =@"更改信息";
                    
                    //cell.imageView.image=[UIImage imageNamed:@"test"];
                    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    break;
                case 1:
                    cell.textLabel.text =@"自动签到";
                    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
                    sw1 = [[UISwitch alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width*5/6, 15, 0, 0)] ;
                    sw1.on=YES;
                    [sw1 addTarget:self action:@selector(switchQiandao:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:sw1];
                    break;
                case 2:
                    cell.textLabel.text =@"提醒";
                    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
                    sw2= [[UISwitch alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width*5/6, 15, 0, 0)] ;
                    sw2.on=YES;
                    [sw2 addTarget:self action:@selector(switchTixing:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:sw2];
                    break;
                case 3:
                    cell.textLabel.text =@"打卡记录";
                    cell.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] ;
                    break;
//                case 4:
//                    cell.backgroundColor = [UIColor redColor];
//                    cell.textColor = [UIColor whiteColor];
//                    cell.textLabel.text =@"                               退出账户";
//                    break;
                    
                default:
                    break;
            }
        }else  {
            
            cell.backgroundColor = [UIColor redColor];
            cell.textColor = [UIColor whiteColor];
            cell.textLabel.text =@"退出账户";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
        }


    }
    return cell;
}

/*- (CRNavigationBar *)setNavigationbar
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
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"设置"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    //    //创建UIBarButton 可根据需要选择适合自己的样式
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    //     item.tintColor = [UIColor blackColor] ;
    //设置barbutton
    //    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    return navigationBar ;
}
*/
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent ;
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
