//
//  ViewController.m
//  wxDemo
//
//  Created by 吴鹏 on 16/7/25.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "WPToolBarView.h"
#import "WPOutTableViewCell.h"
#import "WPOutOrComeinImageTableViewCell.h"
#import "WPContentLable.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WPToolBarDataDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信";
    self.dataArray = [[NSMutableArray alloc] init];
    
    WPToolBarView * toolview = [[WPToolBarView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50, [UIScreen mainScreen].bounds.size.width, 50) viewController:self];
    toolview.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:toolview];
}



#pragma mark - property

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50 -64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_tableView addGestureRecognizer:tap];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPDataModel * mode = self.dataArray[indexPath.section];
    if(mode.stype == PASSSTYPE_STR)
    {
        NSString * str = @"cell";
        WPOutTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if(cell == nil)
        {
            cell = [[WPOutTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell getContenInfo:self.dataArray[indexPath.section]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        NSString * str = @"cell1";
        WPOutOrComeinImageTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if(cell == nil)
        {
            cell = [[WPOutOrComeinImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell imageViewGetInfo:self.dataArray[indexPath.section]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPDataModel * model;
    model = self.dataArray[indexPath.section];
    return  model.contentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - wptoolDelegate

- (void)wp_respond:(WPDataModel *)dataModel
{
    [self.dataArray addObject:dataModel];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataArray.count - 1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPBiaoQingWillHidden object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPMoreWillHidden object:nil];
}

- (void)tap
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPBiaoQingWillHidden object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPMoreWillHidden object:nil];
}

@end
