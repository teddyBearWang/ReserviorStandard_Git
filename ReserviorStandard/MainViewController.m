//
//  MainViewController.m
//  ReserviorStandard
//
//  Created by teddy on 14-10-22.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "MainViewController.h"
#import "ConcreteCheckViewController.h"
#import "HoistViewController.h"
#import "SteelGateController.h"
#import "HoistOperateViewController.h"
#import "InspectViewController.h"
#import "SegtonInstance.h"
#import "PrePareViewController.h"
#import "ManagedViewController.h"
#import "RSButton.h"
#import "RTLabel.h"

@interface MainViewController ()
{
    UIImageView *_statusView; //顶部
    UIScrollView *_scrollView;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"主菜单";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    SegtonInstance *instance = [SegtonInstance sharedTheme];
    RTLabel *nameLabel = (RTLabel *)[self.view viewWithTag:4001];
    nameLabel.text = instance.userName;
    
    RTLabel *stateLabel = (RTLabel *)[self.view viewWithTag:4002];
    stateLabel.text = [NSString stringWithFormat:@"当前共有%d位用户在线",instance.userArray.count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initStateViewAction];
    
    [self initScrollView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//初始化状态视图
- (void)initStateViewAction
{
    _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,TITLEVIEWHEGHT)];
    _statusView.image = [UIImage imageNamed:@"bg"];
    _statusView.userInteractionEnabled = YES;
    [self.view addSubview:_statusView];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRect){10,10,IMGVIEW_WIDTH,IMGVIEW_HIGHT}];
    imgView.layer.cornerRadius = 20;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"icon_user"];
    [_statusView addSubview:imgView];
    
    RTLabel *nameLabel = [[RTLabel alloc] initWithFrame:(CGRect){10+IMGVIEW_WIDTH+10,15,IMGVIEW_WIDTH*3,30}];
    nameLabel.tag = 4001;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [_statusView addSubview:nameLabel];
    
    RSButton *setBtn = [RSButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = (CGRect){(SCREEN_WIDTH - 10 - 50),15,50,25};
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(chooseUserAction:) forControlEvents:UIControlEventTouchUpInside];
    [_statusView addSubview:setBtn];
    
    RTLabel *stateLabel = [[RTLabel alloc] initWithFrame:(CGRect){10,(TITLEVIEWHEGHT - 10-30),160,30}];
    stateLabel.tag = 4002;
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.font = [UIFont boldSystemFontOfSize:15];
    [_statusView addSubview:stateLabel];

}

//初始化滑动视图
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TITLEVIEWHEGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TITLEVIEWHEGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-TITLEVIEWHEGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    NSArray *itemArr = @[@"大坝卷式扬启闭机",@"一级电厂启闭机",@"二级电厂螺杆式启闭机",@"大坝弧形钢闸门",@"电厂一级钢闸门",@"电厂二级钢闸门",@"混凝土坝检查记录",@"通用巡查",@"闸门操作记录"];
    NSArray *images = @[@"juanyang",@"yeya",@"luoxuan",@"DamGate",@"gate1",@"gate2",@"check",@"command",@"gateOperate"];
    for (int i=0; i<itemArr.count; i++) {
        int row = i / 3; //表示第几行
        int cloum = i % 3;//表示第几列
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake((20 *(cloum+1)+ BUTTON_VIEW_WIDTH *cloum), (25 * (row + 1) + BUTTON_VIEW_HEIGHT * row), BUTTON_VIEW_WIDTH, BUTTON_VIEW_HEIGHT)];
        buttonView.layer.cornerRadius = 6.0f;
        buttonView.layer.borderWidth = 0.5;
        buttonView.layer.borderColor = [UIColor colorWithRed:234/244.0 green:234/255.0 blue:234/255.0 alpha:1.0].CGColor;
        buttonView.layer.masksToBounds = YES;
        [_scrollView addSubview:buttonView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        btn.frame = (CGRect){(BUTTON_VIEW_WIDTH - BUTTON_WIDTH)/2,0,BUTTON_WIDTH,BUTTON_HEIGHT};
        btn.tag = i+1;
        btn.layer.cornerRadius = 6.0f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, btn.frame.origin.y+BUTTON_HEIGHT, BUTTON_VIEW_WIDTH - 5, (BUTTON_VIEW_HEIGHT-BUTTON_HEIGHT) )];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        label.text = [itemArr objectAtIndex:i];
        label.numberOfLines = 0; //支持多行
        CGSize size = CGSizeMake(BUTTON_VIEW_WIDTH, 1000);
        CGSize lableSize = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        label.frame = (CGRect){label.frame.origin.x,label.frame.origin.y,lableSize.width,lableSize.height};
        [buttonView addSubview:label];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入账号管理界面
- (void)chooseUserAction:(UIGestureRecognizer *)tap
{
    ManagedViewController *managedCtrl = [[ManagedViewController alloc] init];
    [self.navigationController pushViewController:managedCtrl animated:YES];
}

#pragma mark - private
- (void)clickButtonAction:(UIButton *)btn
{
    if (btn.tag == 1) {
        //启闭机检查
        HoistViewController *hoist = [[HoistViewController alloc] init];
        hoist.type = kFixedHoistType;//固定卷扬启闭机
        [self.navigationController pushViewController:hoist animated:YES];
    }else if (btn.tag == 2){
        HoistViewController *hoist = [[HoistViewController alloc] init];
        hoist.type = kHydraulichoistType;//液压启闭机
        [self.navigationController pushViewController:hoist animated:YES];
    }else if (btn.tag == 3){
        HoistViewController *hoist = [[HoistViewController alloc] init];
        hoist.type = kSpiralHoistType;//螺旋启闭机
        [self.navigationController pushViewController:hoist animated:YES];
    }else if (btn.tag == 4){
        SteelGateController *gate = [[SteelGateController alloc] init];
        gate.gateType = kDamSteelGateType; //大坝钢闸门
        [self.navigationController pushViewController:gate animated:YES];
    } else if (btn.tag == 5){
        SteelGateController *gate = [[SteelGateController alloc] init];
        gate.gateType = kFirstPowerFlantType; //一级电厂闸门
        [self.navigationController pushViewController:gate animated:YES];
    } else if(btn.tag == 6){
        SteelGateController *gate = [[SteelGateController alloc] init];
        gate.gateType = kSecondPowerFlantType; //二级电厂闸门
        [self.navigationController pushViewController:gate animated:YES];
    } else if (btn.tag == 7){
        //大坝检查
        PrePareViewController *concreteCtr = [[PrePareViewController alloc] init];
        [self.navigationController pushViewController:concreteCtr animated:YES];
    } else if (btn.tag == 8){
        InspectViewController *inspectCtr = [[InspectViewController alloc] init];
        [self.navigationController pushViewController:inspectCtr animated:YES];
    } else if (btn.tag == 9) {
        HoistOperateViewController *hoistOperate = [[HoistOperateViewController alloc] init];
        [self.navigationController pushViewController:hoistOperate animated:YES];
    }
}
@end
