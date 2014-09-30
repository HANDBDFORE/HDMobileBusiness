//
//  HDDeleverViewController.m
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import "HDDeleverViewController.h"
#import "HDDeleverModel.h"
#import "HDDeleverCell.h"

@interface HDDeleverViewController (){
    UITextView * _textview;
    UIButton  * _btn;
    
    
    UILabel * _label;
    
    HDDeleverModel *  _model;
    
    
    UITableView * _tableview;
}

@end

@implementation HDDeleverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.navigationItem.leftBarButtonItem =
//        [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
//                                                       target: self
//                                                       action: @selector(cancel)] autorelease];
//        self.navigationItem.rightBarButtonItem =
//        [[[UIBarButtonItem alloc] initWithTitle: TTLocalizedString(@"Done", @"")
//                                          style: UIBarButtonItemStyleDone
//                                         target: self
//                                         action: @selector(post)] autorelease];
        
        
        _model = [[HDDeleverModel alloc] init];
        self.model = _model;
        self.title = @"审批意见";

    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width * 2/3, 50)];
    _btn  = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 2/3 + 7,0 , self.view.bounds.size.width /3 -7, 50)];
    [_btn setTitle:@"查询" forState:UIControlStateNormal];

    [_btn addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_textview];
    [self.view addSubview:_btn];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    
    _label.textColor = [UIColor redColor];
    _label.text = @"提示： 请输入工号，姓名，等进行查询";
    
    [self.view addSubview:_label];
    
    

    
    // Do any additional setup after loading the view.
}

-(void)btnpress:(id)sender
{
    
    if(!_textview.text.length ){
        TTAlertNoTitle(@"查询条件不能为空");
        return;
    }

    
    
    [_label setHidden:true];
    
    [_model loadRecord:_textview.text];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error{
    
    TTAlertNoTitle(@"请求数据失败");
}

-(void)modelDidFinishLoad:(id<TTModel>)model{
    
    NSLog(@"%d conut is ",_model.list.count);
    
    if( _model.list == nil || _model.list.count == 0){
        _label.textColor = [UIColor whiteColor];
        _label.text = @"未找到任何数据";
        _label.hidden = NO;
    }else{
        _tableview= [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableview];
        
        
        
    }
    
}

#pragma  tableviewdatesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSInteger  num =   _model.list.count;
    NSLog(@"%d",num);
    
    return num;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  HDDeleverCell * cell=  [[HDDeleverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDDeleverCell"];
    return  cell;
    
}


#pragma tableviewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
