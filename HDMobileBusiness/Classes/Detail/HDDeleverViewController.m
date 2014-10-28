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
#import "HDDeleverCommentViewController.h"

@interface HDDeleverViewController (){
    UITextView * _textview;
    
    UIButton  * _btn;
    UILabel * _label;
    
    HDDeleverModel *  _model;
    
    UITableView * _tableview;
    
    UIActivityIndicatorView *    indicator;
}

@end

@implementation HDDeleverViewController


- (void)viewDidLoad
{
    
    [self initViews];
    
    _model = [[HDDeleverModel alloc] init];
    
    [self setModel:_model];
}

/////////////////private//////////////
-(void)initViews
{
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }


        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 30, 30)];
    
    
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicator];
    
    [self.queryBtn addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchDown];
    
    [self.navigationController setToolbarHidden:YES];
    
}

-(void)resumeView
{
    [indicator stopAnimating];
    self.view.userInteractionEnabled = YES;
    
}

////////////////btn click listener////////////
-(void)query
{
    
    [self.keywordTf resignFirstResponder];
    
    //对输入内容进行
    if(_keywordTf.text.length == 0 ){
        
        TTAlertNoTitle(TTLocalizedString(@"Enter Conditions For Search", @""));
        return;
    }
    
    
    
    
    [_model loadRecord:_keywordTf.text];
    
}




/////////////tableviewdelegate//////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_model.list != nil){
        
        return   _model.list.count;
        
    }else{
        
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDDeleverCell * cell = [[HDDeleverCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDDeleverCell"];
    
    NSDictionary * data =  [_model.list objectAtIndex:indexPath.row];


    [cell setCell:data];
    
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   HDDeleverCell * cell =  (HDDeleverCell *)[tableView cellForRowAtIndexPath:indexPath];
 
    self.superView.deliverId =  cell.delivereeid;
    self.superView.delivereeLbl.text = cell.userNameLbl.text;
    
   [self.navigationController popViewControllerAnimated:YES];
    
}


///////////////////modelvie delegate
-(void)modelDidStartLoad:(id<TTModel>)model
{
    
    
    self.view.userInteractionEnabled = NO;

    [indicator startAnimating];
    
    
    
    
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    //隐藏提示
    [self.hintLbl setHidden:true];
    
    
    [self resumeView];

    if(_model.list.count == 0)
    {
        
        
    }else{
        self.delivereeTableView.tableFooterView = [[UIView alloc]init];
        self.delivereeTableView.tableHeaderView = [[UIView alloc]init];
        
        self.delivereeTableView.delegate = self;
        self.delivereeTableView.dataSource = self;
        [self.delivereeTableView reloadData];
    }
    
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{

    [self resumeView];
    
    
}

/////////////////system autocreate////////////////////////////////

- (void)dealloc {
    [_keywordTf release];
    [_queryBtn release];
    [_hintLbl release];
    [_delivereeTableView release];
    [super dealloc];
}
@end
