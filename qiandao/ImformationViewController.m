//
//  ImformationViewController.m
//  SetterController
//
//  Created by 杨杨杨 on 2017/3/19.
//  Copyright © 2017年 杨杨杨. All rights reserved.
//

#import "ImformationViewController.h"
#import "CRNavigationBar.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AFNetworking.h"
#import "ObJectToDictionary.h"
#import "ChangeInformationDataBagObject.h"
@interface ImformationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController * _imagePickerController;//调用相册时的controller
    UITableView * _tableView;
    UITextField * _textField;
}
@end

@implementation ImformationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES] ;
    _person = [Person read] ;
    [self setNavigationbar] ;
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!%d",[_person.isSigned integerValue]) ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self preferredStatusBarStyle] ;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height)  style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    //初始化
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    
}
//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        [self useCamera];
        return;
    }
    if (indexPath.row==1) {
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你需要跳槽么 我们可以帮助联系你的老板" delegate:self cancelButtonTitle:@"不跳槽" otherButtonTitles:nil, nil] ;
        [view show] ;
        return;
    }
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请输入要更改的信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![_textField.text isEqualToString:@""]) {
            switch (indexPath.row) {
                case 2:
                    _person.name=_textField.text;
                    break;
                case 3:
                    if(_textField.text.length!=11)
                        return ;
                    _person.mobile=_textField.text;
                    break;
                case 4:
                    if([_textField.text rangeOfString:@"@"].length==0)
                        return;
                    _person.email=_textField.text;
                    break;
                default:
                    break;
            }
             [self 向服务器发送修改后的数据包];
            [_person save];
            [_tableView reloadData];
            
            
        }
        
#pragma - 在下面写发送信息的方法,要是自己看着不顺眼就改一下名字
       
    }];
    
    [alertControl addAction:okAction];//ok
    [alertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _textField=textField;
        NSString * str;
        switch (indexPath.row) {
            case 2:
                str=_person.name;
                break;
            case 3:
                str=_person.mobile;
                break;
            case 4:
                str=_person.email;
                break;
            default:
                break;
        }
        textField.placeholder=str;
    }];
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma - 在这里写发送信息的方法
-(int)向服务器发送修改后的数据包{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //发送数据的类型是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"] ;
    
    NSString * urlstring = [NSString stringWithFormat:@"https://xsky123.com/check/api.php?q=info"] ;
    ChangeInformationDataBagObject * DataBag = [[ChangeInformationDataBagObject alloc]init] ;
    DataBag = [DataBag DataBagWithPerson:_person] ;
    NSDictionary * dic = [ObJectToDictionary ObjectToDictionary:DataBag] ;
    
    
    [manager POST:urlstring parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        NSLog(@"%@",data) ;
        [DataBag justfortest] ;
        if([data[@"code"] integerValue]==200){
            UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"通知" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
            [_person save] ;
            [view show] ;
        }else{
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"通知" message:@"网络繁忙 请稍候重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
            [view show] ;
        }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
               UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"通知" message:@"网络繁忙 请稍候重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
               [view show] ;

    }];
    return 0;
}
//调用系统相册
- (void)useCamera{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"改变头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"使用相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }];
    UIAlertAction *photoLabraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:cameraAction];
    [alertControl addAction:photoLabraryAction];
    [alertControl addAction:cancelAction];
    [self presentViewController:alertControl animated:NO completion:nil];
}
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}
#pragma mark UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        self.imageView.image = info[UIImagePickerControllerEditedImage];
        
        
    }else{
        NSLog(@"这是视频");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置单元格具体内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str=@"setView";
    UITableViewCell * cell=[_tableView dequeueReusableCellWithIdentifier:str];
//    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.imageView.image=[UIImage imageNamed:@"test"];
                break;
            case 1:
                cell.textLabel.text =@"公司部门";
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.person.company,self.person.apartment];
                break;
            case 2:
                cell.textLabel.text =@"用户名";
                cell.detailTextLabel.text=self.person.name;
                break;
            case 3:
                cell.textLabel.text =@"联系电话";
                cell.detailTextLabel.text=self.person.mobile;
                break;
            case 4:
                cell.textLabel.text =@"邮箱";
                cell.detailTextLabel.text=self.person.email;

                break;
            
                
            default:
                break;
//        }
    }
    
    return cell;
}
-(instancetype)init{
    if (self=[super init]) {
        self.person=[Person read] ;
    }
    return self;
}
- (void)setNavigationbar{
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
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"个人信息"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    UIBarButtonItem * returnbutton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(push)] ;
    returnbutton.tintColor = [UIColor whiteColor] ;
    navigationBarTitle.leftBarButtonItem = returnbutton ;
        //创建UIBarButton 可根据需要选择适合自己的样式
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
//         item.tintColor = [UIColor blackColor] ;
//    设置barbutton
//        [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
//    
}

- (void)push{
    [self.navigationController popViewControllerAnimated:YES] ;
    
}
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
