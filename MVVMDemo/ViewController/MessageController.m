//
//  MessageController.m
//  MVVMDemo
//
//  Created by goldeneye on 2017/3/16.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//
#import "MessageController.h"
#import "SDAutoLayout.h"
#import "MJRefresh.h"
#import "MessageModel.h"
#import "MessageViewModel.h"
#import "MessageCell.h"
static  NSString * const cellIdtentifier = @"MessageCell";
@interface MessageController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableV;
@property(nonatomic,strong)NSMutableArray * array;
@property (nonatomic,assign) NSInteger page;
@end
@implementation MessageController

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = 0;
        [_tableV registerClass:[MessageCell class] forCellReuseIdentifier:cellIdtentifier];
        _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableV;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"MVVMDemo";
    [self.view addSubview:self.tableV];
    self.tableV.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    [self.tableV.mj_header beginRefreshing];
}
- (void)headRefresh{
    self.page = 1;
    [self getNetworkData];
}
- (void)loadMoreData{
    self.page++;
    [self getNetworkData];
}
- (void)getNetworkData{
    MessageViewModel * model = [[MessageViewModel alloc]init];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(20);
    params[@"key"] = @"420a75504ae314f404935173451bbd8e";
    [model getMessageParams:params successData:^(NSArray *array) {
        if (self.page==1) [self.array removeAllObjects];
        [self.array addObjectsFromArray:array];
        [self.tableV reloadData];
        [self.tableV.mj_header endRefreshing];
        [self.tableV.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableV.mj_header endRefreshing];
        [self.tableV.mj_footer endRefreshing];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count?self.array.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdtentifier];
    if (!cellIdtentifier) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdtentifier];
    }
    cell.model = self.array[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableV cellHeightForIndexPath:indexPath model:self.array[indexPath.row] keyPath:@"model" cellClass:[MessageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
