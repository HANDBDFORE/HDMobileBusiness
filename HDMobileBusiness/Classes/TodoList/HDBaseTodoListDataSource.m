//
//  HDWillApproveListBaseDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseTodoListDataSource.h"

@implementation HDBaseTodoListDataSource

@synthesize todoListModel = _todoListModel;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_todoListModel);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        _todoListModel = [[HDTodoListModel alloc]init];
        self.model = _todoListModel;
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *生成cell对应的item
 */
-(TTTableItem *) createItemWithObject:(id) object
{
    //TODO:考虑在这里通过配置文件设置映射关系,而不是在model中
//    Approve * approveRecord = (Approve *)object;
    NSString * title = [NSString stringWithFormat:@"%@: %@",
                        [object valueForKey: @"orderType"],
                        [object valueForKey: @"employeeName"]];
    
    NSString * caption = [NSString stringWithFormat:@"当前节点: %@",[object valueForKey: @"nodeName"]];
    
    NSString * text = [NSString stringWithFormat:@"%@",[object valueForKey: @"instanceDesc"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate * timestamp = [dateFormatter dateFromString:[object valueForKey:@"creationDate"]];
    TT_RELEASE_SAFELY(dateFormatter);
    
    //    NSString * url = [NSString stringWithFormat:@"%@/%i",kOpenWillApproveDetailViewPath,[_approveListModel.resultList indexOfObject:approveRecord]];
    
    NSString * stautMessage = nil;
    //TODO:这里数据库数据读取有问题,status如果没有不是nil
    if (![[object valueForKey:@"localStatus"] isEqualToString:kRecordNormal] &&![[object valueForKey:@"localStatus"] isEqualToString:kRecordWaiting]) {
        stautMessage = [NSString stringWithFormat:@"%@",[object valueForKey:@"serverMessage"]];
    }
    return [HDTableStatusMessageItem itemWithTitle:title 
                                           caption:caption 
                                              text:text 
                                         timestamp:timestamp 
                                          selector:@selector(openDetailViewForKey:)
                                          delegate:self
                                           message:stautMessage 
                                             state:[object valueForKey:@"localStatus"]];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTTableViewDataSource delegate
-(NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{ 
    [self.items removeObjectAtIndex:indexPath.row];
    [self.items insertObject:[self createItemWithObject:object] atIndex:indexPath.row];
    return indexPath;
}

////////////////////////////////////////////////////////////////////////////////////////////
-(NSIndexPath *)tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{    
    [self.items removeObjectAtIndex:indexPath.row];
    return indexPath;
}
////////////////////////////////////////////////////////////////////////////////////////////

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[HDTableStatusMessageItem class]]) {  
        return [HDTableStatusMessageItemCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    //tableload完成生成cell item 对象列表
    self.items = [NSMutableArray array];
    //    [self.model];
    for (id approvedRecord in self.todoListModel.resultList) {
        [self.items addObject:[self createItemWithObject:approvedRecord]
         ];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark UITable datasource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString * localStatus =  [[self.todoListModel.resultList objectAtIndex:indexPath.row] valueForKeyPath:@"localStatus"];
    
    return ([localStatus isEqualToString:@"NORMAL"] || [localStatus isEqualToString:@"ERROR"]);
}

-(void)openDetailViewForKey:(HDTableStatusMessageItem *)item
{
    //    HDWillAproveListModel * _approveListModel = (HDWillAproveListModel *) self.model;
    NSUInteger index = [self.items indexOfObject:item];
    NSString * url = [NSString stringWithFormat:@"%@/%i",kOpenWillApproveDetailViewPath,index];
    TTOpenURL(url);
    //    return viewController;
}

- (void)search:(NSString*)text {
    [self.todoListModel search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"Searching...";
}

- (NSString*)titleForNoData {
    return @"No names found";
}

@end
