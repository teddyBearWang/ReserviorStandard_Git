//
//  HoistViewController.m
//  ReserviorStandard
// ********************启闭机检查记录****************
//  Created by teddy on 14-10-23.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "HoistViewController.h"
#import "HoistTableViewCell.h"
#import "HoistObject.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "SegtonInstance.h"
#import "ReportViewController.h"

@interface HoistViewController ()
{
    NSMutableArray *_hoistArray; //获取plist文件
    UITextView *contextView; //填写问题的TextView，用来接受问题的值
}

@end

@implementation HoistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
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
    if (_hoistArray.count != 0) {
        [_hoistArray removeAllObjects];
    }
    if (self.type == kFixedHoistType) {
        self.title = @"大坝卷扬式";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HoistContentList" ofType:@"plist"];
        _hoistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }else if (self.type == kSpiralHoistType){
        self.title = @"二级电厂";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LuoXuanHoistList" ofType:@"plist"];
        _hoistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }else {
        self.title = @"一级电厂";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HoistContentList" ofType:@"plist"];
        _hoistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
  
    listArray = [NSMutableArray arrayWithCapacity:_hoistArray.count];
    for (NSDictionary *dic in _hoistArray) {
        NSString *valueContent = [dic objectForKey:@"key"];
        [listArray addObject:valueContent]; //所有key对应值的数组
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0f];
    self.numerIDTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.myTableVIew.delegate = self;
    self.myTableVIew.dataSource = self;
    
    [self.uploadButton setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    fileArray  = [NSMutableArray array]; //保存有问题的选项
    
    NSArray *arr = @[@"拍照",@"已上报"];
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:arr];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segCtrl.multipleTouchEnabled = NO;
    segCtrl.momentary = YES;
    segCtrl.apportionsSegmentWidthsByContent = YES;
    [segCtrl addTarget:self action:@selector(reportedItemAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)reportedItemAction:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        TakePhotoViewController *photo = [[TakePhotoViewController alloc] init];
        photo.delegate = self;
        [self.navigationController pushViewController:photo animated:YES];
    } else {
        ReportViewController *report = [[ReportViewController alloc] init];
        switch (self.type) {
            case kFixedHoistType:
                report.reportedType = kDamHoistReportedType;
                break;
            case kSpiralHoistType:
                report.reportedType = kSecondPowerHoistReportedType;
                break;
            case kHydraulichoistType:
                report.reportedType = kFirstPowerHoistReportedType;
                break;
        }
        [self.navigationController pushViewController:report animated:YES];
    }
}

#pragma takePhotoDelegate
- (void)takePhotoWithArray:(NSMutableArray *)array
{
    _imgArray = [NSMutableArray arrayWithArray:array];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - file action
- (NSString *)createFileAction
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documengtDirectory = [paths objectAtIndex:0];
    NSString *filepath = [documengtDirectory stringByAppendingPathComponent:@"dangerObjectArray.txt"];
    return filepath;
}

#pragma mark - private Action
- (IBAction)selectedPartAction:(id)sender
{
    [self tapBackground:nil];//取消键盘
    UIButton *btn = (UIButton *)sender;
    CGRect rect = [btn.superview convertRect:btn.frame toView:self.view];
    float height = rect.origin.y+rect.size.height;
    if (_dropDown == nil) {
        CGFloat f = 30*listArray.count;
        //防止超出屏幕
        if ((f + height) > SCREEN_HEIGHT-height) {
            f = SCREEN_HEIGHT - height-100;
        }
        _dropDown = [[NIDropDown alloc]showDropDown:btn :&f :listArray :(CGRect )rect];
        [self.view addSubview:_dropDown];
        _dropDown.delegate = self;
    }else{
        [_dropDown hideDropDown:btn];
        _dropDown.delegate = self;
        [self rel];
    }
}

- (void)rel
{
    _dropDown = nil;
}

#pragma mark -DropDownDelegateMethod
- (void) niDropDownDelegateMethod: (int) sender
{
    NSString *str = [listArray objectAtIndex:sender];
    [self.partButoon setTitle:str forState:UIControlStateNormal];
    NSDictionary *dic = [_hoistArray objectAtIndex:sender]; //其中一个检查部位
    NSArray *listArr = [dic objectForKey:@"value"]; //tableView的数据源
    if (_contentArray.count != 0) {
        [_contentArray removeAllObjects];
    }else {
        _contentArray = [NSMutableArray arrayWithCapacity:listArr.count]; //_contentArray里面包括的全部是hoistObject对象
    }
    for (int i=0; i<listArr.count; i++) {
        NSDictionary *dic1 = [listArr objectAtIndex:i];
        HoistObject *hoist = [[HoistObject alloc] init];
        hoist.name = [dic1 objectForKey:@"name"];
        hoist.idNum = [dic1 objectForKey:@"id"];
        for (HoistObject *hoist1 in fileArray) {
            //检查是否已经有问题的
            if (hoist.idNum == hoist1.idNum) {
                hoist.isMark = YES;
                hoist.danger = hoist1.danger;
                break; //跳出此次循环
            }else{
                hoist.isMark = NO;
                hoist.danger = @"正常";
            }
        }
        [_contentArray addObject:hoist];
    }
    [self.myTableVIew reloadData];
    [self rel];
}
#pragma mark - UITableViewdataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyCell";
    HoistTableViewCell *cell = (HoistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HoistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    HoistObject *hoist = (HoistObject *)[_contentArray objectAtIndex:indexPath.row];
    cell.contentLabel.text = hoist.name;
    [cell setIntroductionText:hoist.name];
    if (hoist.isMark) {
        cell.backgroundColor = [UIColor redColor];
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    return cell;
}

#pragma amrk - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.myTableVIew cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.height > 44) {
         return cell.frame.size.height;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableVIew deselectRowAtIndexPath:indexPath animated:YES];
    HoistObject *hoist =  [_contentArray objectAtIndex: indexPath.row];
    selectedIndex = [hoist.idNum intValue];//选择的IDnumber
    [self createAlertView:hoist.danger];
}

- (void)createAlertView:(NSString *)content
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    contextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    contextView.tag = 2001;
    if (content.length == 0) {
        contextView.text = @"正常";
    }else{
        contextView.text = content;
    }
    contextView.delegate = self;
    [sView addSubview:contextView];
    
    [alertView setContainerView:sView];
    [alertView setButtonTitles:[NSArray arrayWithObjects:@"确定",@"取消", nil]];
    alertView.delegate = self;
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //点击了确定按钮
        for (HoistObject *hoist in _contentArray) {
            if ([hoist.idNum intValue] == selectedIndex) {
                hoist.danger = contextView.text; //保存隐患
                if (![hoist.danger isEqual:@"正常"]) {
                    hoist.isMark = YES;//标记隐患
                }
                [fileArray addObject:hoist]; //保存已经有隐患的
            }
        }
        [self.myTableVIew reloadData];
    }
    [alertView close];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [contextView resignFirstResponder];
    }
    return YES;
}

//上传服务
- (IBAction)uploadProblemAction:(id)sender
{
    if (self.numerIDTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"启闭机台号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:_hoistArray.count];
    for (NSDictionary *dic in _hoistArray) {
        NSArray  *dicArr = [dic objectForKey:@"value"];
        for (NSDictionary *dic1 in dicArr) {
            HoistObject *hoist = [[HoistObject alloc] init];
            hoist.name = [dic1 objectForKey:@"name"];
            hoist.idNum = [dic1 objectForKey:@"id"];
            for (HoistObject *object in fileArray) {
                if (hoist.idNum == object.idNum) {
                    hoist.danger = object.danger;
                    break;
                } else {
                    hoist.danger = @"正常";
                }
            }
            [valueArr addObject:hoist.danger];
        }
    }
    
    NSString *str = [valueArr componentsJoinedByString:@"$"];
    
    NSURL *url = [NSURL URLWithString:WEB_SERVER];
    NSString *dateString = [NSString stringWithFormat:@"%d-%.2d-%.2d",SHAREAPP.remYear,SHAREAPP.remMonth,SHAREAPP.remDay];
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    //your code...
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    NSString *hoistType = nil;
    switch (self.type) {
        case kFixedHoistType:
            [request setPostValue:@"insertGateLiftingHoistCheck" forKey:@"t"];
            hoistType = @"1";//卷扬式启闭机
            break;
        case kSpiralHoistType:
            [request setPostValue:@"insertScrewHoistCheck" forKey:@"t"];
            break;
        case kHydraulichoistType:
            [request setPostValue:@"insertHydraulicHoistCheck" forKey:@"t"];
            hoistType = @"2"; //一级电厂启闭机
            break;
        default:
            break;
    }
    NSString *valueStr = nil;
    if (self.type == kSpiralHoistType) {
     valueStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@",dateString,self.numerIDTextField.text,str,instance.userName,instance.userName,instance.idNum,instance.idNum];
    } else {
        valueStr = [NSString stringWithFormat:@"%@$%@$%@$%@$%@$%@$%@$%@",dateString,self.numerIDTextField.text,str,instance.userName,instance.userName,instance.idNum,instance.idNum,hoistType];
    }

    [request setPostValue:valueStr forKey:@"results"];
    for (int i = 0; i < _imgArray.count; i++) {
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:[_imgArray objectAtIndex:i]];
        [request addData:imgData withFileName:@"image.jpg" andContentType:@"image/png" forKey:@"photo"];
    }
    [SVProgressHUD showWithStatus:@"上传中..."];
    [request startAsynchronous];
}

- (IBAction)tapBackground:(id)sender
{
    [self.numerIDTextField resignFirstResponder];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        NSString *resString = request.responseString;
        NSData *data = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [arr objectAtIndex:0];
        if ([[dic objectForKey:@"success"] isEqualToString:@"True"]) {
            [SVProgressHUD dismissWithSuccess:@"上传成功"];
            //上传成功后全部本地照片
            for (int i=0; i<_imgArray.count; i++) {
                [[NSFileManager defaultManager] removeItemAtPath:[_imgArray objectAtIndex:i] error:nil];
            }
        } else {
            [SVProgressHUD dismissWithError:@"上传失败"];
        }
    } else {
        [SVProgressHUD dismissWithError:@"上传失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"上传超时"];
}

@end
