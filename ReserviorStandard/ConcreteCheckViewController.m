//
//  ConcreteCheckViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-22.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "ConcreteCheckViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "CheckedObject.h"
#import "CustomCell.h"
#import "RTLabel.h"
#import "RSButton.h"
#import "SegtonInstance.h"
#import "MainViewController.h"


#define AREALABEL_WIDTH 120
#define PROBLEMBUTTON_WIDTH 200
#define PROBLEMBUTTON_HEIGHT 30
#define TABLEVIEW_WIDTH 260
#define TABLEVIEW_HEIGHT 280

@interface ConcreteCheckViewController ()

@end

@implementation ConcreteCheckViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"大坝检查表";
        _lastArea = @"上游面";
        _lastContent = @"表面整治";
        _problemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    _areaArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaList.plist" ofType:nil]];
    _contentArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CheckContentList.plist" ofType:nil]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSArray *arr = @[@"拍照",@"已上报"];
//    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:arr];
//    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segCtrl.multipleTouchEnabled = NO;
//    segCtrl.apportionsSegmentWidthsByContent = YES;
//    [segCtrl addTarget:segCtrl action:@selector(ReportedItemAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(ReportedItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.areaLable.font = [UIFont boldSystemFontOfSize:15];
    self.areaLable.text = @"检查部位:";
    
    [self.areaBtn setTitle:@"上游面" forState:UIControlStateNormal];
    self.areaBtn.tag = 1001;
    [self.areaBtn addTarget:self action:@selector(selectedAreaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentLabel.font = [UIFont boldSystemFontOfSize:15];
    self.contentLabel.text = @"检查内容:";
    
    [self.contentBtn setTitle:@"表面整治" forState:UIControlStateNormal];
    self.contentBtn.tag = 1002;
    [self.contentBtn addTarget:self action:@selector(selectedContentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.havaProblemBtn setTitle:@"添加问题" forState:UIControlStateNormal];
    [self.havaProblemBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    [self.havaProblemBtn addTarget:self action:@selector(markProblemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.comfirmBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.comfirmBtn setBackgroundImage:[UIImage imageNamed:@"button_blue_big"] forState:UIControlStateNormal];
    self.tableView.backgroundColor = [UIColor colorWithRed:209/255.0 green:236/255.0 blue:255/255.0 alpha:1.0f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ReportedItemAction:(id)sender
{
   // UISegmentedControl *seg = (UISegmentedControl *)sender;
    //if (seg.selectedSegmentIndex == 0) {
        TakePhotoViewController *takeCtrl = [[TakePhotoViewController alloc] init];
        takeCtrl.delegate = self;
        [self.navigationController pushViewController:takeCtrl animated:YES];
   // } else {
        //已上报
   // }
}

#pragma mark - takePhotoDelegate
- (void)takePhotoWithArray:(NSMutableArray *)array
{
    _imgArray = [NSMutableArray arrayWithArray:array];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    CustomDateActionSheet *timeAction = [[CustomDateActionSheet alloc] initWithTitle:@"请选择时间" delegate:self];
    timeAction.tag = 3001;
    [timeAction showInView:self.view];
    return YES;
}

#pragma mark - Private Method
//seleted area
- (void)selectedAreaAction:(UIButton *)btn
{
    _type = 1;
    CGRect rect = [btn.superview convertRect:btn.frame toView:self.view];
    if (dropDown == nil) {
        CGFloat f = 30*_areaArray.count;
        dropDown = [[NIDropDown alloc]showDropDown:btn :&f :_areaArray :(CGRect)rect];
        [self.view addSubview:dropDown];
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:btn];
        dropDown.delegate = self;
        [self rel];
    }
}

- (void)rel
{
    dropDown = nil;
}

//selected content
- (void)selectedContentAction:(UIButton *)btn
{
    _type = 2;
    CGRect rect = [btn.superview convertRect:btn.frame toView:self.view];
    
    float height = btn.frame.origin.y+btn.frame.size.height;
    if (dropDown == nil) {
        CGFloat f = 30*_contentArray.count;
        //防止超出屏幕
        if ((f + height) > SCREEN_HEIGHT) {
            f = SCREEN_HEIGHT - height-40;
        }
        dropDown = [[NIDropDown alloc]showDropDown:btn :&f :_contentArray :(CGRect)rect];
        [self.view addSubview:dropDown];
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:btn];
        dropDown.delegate = self;
        [self rel];
    }
}

//mark problem
- (void)markProblemAction:(UIButton *)btn
{
    if (![self checkIsRepeat]) {
        CheckedObject *object = [[CheckedObject alloc] init];
        object.areaName = _lastArea;
        object.contentName = _lastContent;
        [_problemArray addObject:object];
        //上传隐患
        [self webServerAction];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你进行了重复的操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL)checkIsRepeat
{
    BOOL isRepeat = NO;
    for (CheckedObject *obj in _problemArray) {
        if ([_lastArea isEqualToString:obj.areaName] && [_lastContent isEqualToString:obj.contentName]) {
            isRepeat = YES;
        }
    }
    return isRepeat;
}
//上传调用的服务
- (void)webServerAction
{
    [self uploadWebSeverAction];
}


//完成上传
- (void)completeAction
{
    
    NSURL *webUrl = [NSURL URLWithString:WEB_SERVER];
    //正式传数据
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:webUrl];
    request.delegate = self;
    [request setPostValue:@"UpdateConcreteDamSafetyCheckPic" forKey:@"t"];
    [request setPostValue:self.parentID forKey:@"results"];
    for (int i = 0; i < _imgArray.count; i++) {
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:[_imgArray objectAtIndex:i]];
        [request addData:imgData withFileName:@"image.jpg" andContentType:@"image/png" forKey:@"photo"];
    }
    _isPhoto = YES;
    [SVProgressHUD showWithStatus:@"上传中.."];
    [request startAsynchronous];
}

//一个个上传数据
- (void)uploadWebSeverAction
{
    NSURL *webUrl = [NSURL URLWithString:WEB_SERVER];
    //正式传数据
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:webUrl];
    request.delegate = self;
    NSString *item = [NSString stringWithFormat:@"item%d",_itemID+1];
    NSString *value = [NSString stringWithFormat:@"%@$%d$%@$N",self.parentID,_partID+1,item];
    [request setPostValue:@"updateConcreteDamSafetyCheckDetail" forKey:@"t"];
    [request setPostValue:value forKey:@"results"];
    [SVProgressHUD showWithStatus:@"上传中.."];
    [request startAsynchronous];
}
 #pragma mark - NIDropDownDelegate action
- (void) niDropDownDelegateMethod: (int) sender
{
    [self rel];
    if (_type == 1) {
        _lastArea = [_areaArray objectAtIndex:sender];
        _partID = sender;
    } else {
        _lastContent = [_contentArray objectAtIndex:sender];
        _itemID = sender;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _problemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = (CGRect){200,5,25,25};
        deleteBtn.tag = indexPath.row;
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [cell.contentView addSubview:deleteBtn];
    }
    CheckedObject *object = [_problemArray objectAtIndex:indexPath.row];
    cell.areaLabel.text = object.areaName;
    cell.contentLabel.text = object.contentName;
    return cell;
}

- (void)deleteAction:(UIButton *)btn
{
    [_problemArray removeObjectAtIndex:btn.tag];
    [self.tableView reloadData];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        //处理数据
        NSString *resString = request.responseString;
        NSData *jsonData = [resString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic = [jsonArray objectAtIndex:0];
            //正式上传数据
        if ([[dic objectForKey:@"success"] isEqualToString:@"True"]) {
            if (_isPhoto) {
                //上传图片
                _isPhoto = NO;
                NSArray *temArr = self.navigationController.viewControllers;
                for (UIViewController *temVc in temArr) {
                    if ([temVc isKindOfClass:[MainViewController class]]) {
                        
                        [[self.navigationController popToViewController:temVc animated:YES] lastObject];
                    }
                }
            } else {
                [self.tableView reloadData];
            }
            //清空照片
            for (int i=0; i<_imgArray.count; i++) {
                [[NSFileManager defaultManager] removeItemAtPath:[_imgArray objectAtIndex:i] error:nil];
            }
            [SVProgressHUD dismissWithSuccess:@"上传成功"];
        }else{
            [SVProgressHUD dismissWithSuccess:@"上传失败"];
        }
    } else {
        [SVProgressHUD dismissWithSuccess:@"上传失败"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithSuccess:@"上传失败"];
}

- (IBAction)tapBackgroundAction:(id)sender
{
    CustomDateActionSheet *custom = (CustomDateActionSheet *)[self.view viewWithTag:3001];
    [custom cancelAction:nil]; //取消actionSheet
}
@end
