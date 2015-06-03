//
//  ManagedViewController.m
//  ReserviorStandard
//**********账号管理*************
//  Created by teddy on 14-11-19.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ManagedViewController.h"
#import "AppDelegate.h"
#import "AddAccountController.h"
#import "UserObject.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"


@interface ManagedViewController ()
{
    NSArray *_arr;
}

@end

@implementation ManagedViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"账号管理";
       // _appVer = 1.2; //目前软件的版本号
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    _instance = [SegtonInstance sharedTheme];
    _arr = @[@"检查版本更新",@"关于"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isNeed) {
         [self.myTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
             return _instance.userArray.count + 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == _instance.userArray.count) {
            //添加账号
            cell.textLabel.text = @"添加账号";
            cell.textLabel.textColor = [UIColor colorWithRed:103/255.0 green:188/255.0 blue:223/255.0 alpha:1.0f];
            cell.imageView.image = [UIImage imageNamed:@"button-add"];
        } else {
            //显示已有的账号
            UserObject *user = [_instance.userArray objectAtIndex:indexPath.row];
            cell.textLabel.text = user.userName;
        }
        
    } else if (indexPath.section == 1){
        //检查版本更新。关于
        cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = @"退出账号";
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == _instance.userArray.count) {
                //添加账号
                AddAccountController *addCtrl = [[AddAccountController alloc] init];
                [self presentViewController:addCtrl animated:YES completion:^{
                    _isNeed = YES;//下次加载页面的时候需要刷新
                }];
            } else {
                _instance.selectedIndex = indexPath.row; //选择第几行
                //选择账号
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                UserObject *user = (UserObject *)[_instance.userArray objectAtIndex:_instance.selectedIndex];
                _instance.userName = user.userName;
                _instance.idNum = user.idNum;
                _instance.phoneNum = user.phoneNumber;
                [self.myTableView reloadData];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                //版本更新
                [self checkVersionsAction];
            } else {
                //关于。。。
            }
            break;
        case 2:
            //注销账号
            if (_instance.userArray.count == 1) {
                //当只有一个用户的时候退出程序
                [self exitApplication];
            } else {
                //不只有一个用户的时候，删除当前选择的用户
                [_instance.userArray removeObjectAtIndex:_instance.selectedIndex];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:0];
                _instance.selectedIndex = 0;
                //选择当前登录的用户
                UserObject *user = (UserObject *)[_instance.userArray objectAtIndex:_instance.selectedIndex];
                _instance.userName = user.userName;
                _instance.idNum = user.idNum;
                _instance.phoneNum = user.phoneNumber;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.myTableView reloadData];
            }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)[indexPath row];
    if (indexPath.section == 0 && row == _instance.selectedIndex) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
    
}
#pragma mark - 
//检查版本更新
- (void)checkVersionsAction
{
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request setPostValue:@"selectVersion" forKey:@"t"];
    [request setPostValue:@"iphone" forKey:@"results"];
    [SVProgressHUD show];
    [request startAsynchronous];
}
#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        [SVProgressHUD dismiss];
        NSString *resString = request.responseString;
        NSData *date = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:date options:NSJSONReadingMutableLeaves error:nil];
        
        float getAppVer = 0;
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            getAppVer = [[dic objectForKey:@"AppVer"] floatValue];
            _downloadUrl = [dic objectForKey:@"DownloadUrl"];
        }
        if (getAppVer > [_AppVer floatValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您的软件有新的版本，是否要更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"不更新", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您的软件已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"版本更新失败"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //打开页面
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrl]];
    }
}

#pragma mark - 退出程序
- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:SHAREAPP.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    SHAREAPP.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

//退出程序
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
    }
}
@end
