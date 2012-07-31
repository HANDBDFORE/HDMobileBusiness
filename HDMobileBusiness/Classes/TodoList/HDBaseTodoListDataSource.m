//
//  HDWillApproveListBaseDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseTodoListDataSource.h"

@implementation HDBaseTodoListDataSource

@synthesize approveListModel = _approveListModel;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_approveListModel);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithModel:(id<TTModel>) model;
{
    self = [super init];
    if (self) {
        //TODO:test
        _approveListModel = (HDTodoListModel *)[model retain];
        //        [[HDWillAproveListModel alloc]init];
        self.model = _approveListModel;
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
    Approve * approveRecord = (Approve *)object;
    NSString * title = [NSString stringWithFormat:@"%@: %@",
                        approveRecord.orderType,
                        approveRecord.employeeName];
    
    NSString * caption = [NSString stringWithFormat:@"当前节点: %@",approveRecord.nodeName];
    
    NSString * text = [NSString stringWithFormat:@"%@",approveRecord.instanceDesc]; 
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate * timestamp = [dateFormatter dateFromString:approveRecord.creationDate];
    TT_RELEASE_SAFELY(dateFormatter);
    
    //    NSString * url = [NSString stringWithFormat:@"%@/%i",kOpenWillApproveDetailViewPath,[_approveListModel.resultList indexOfObject:approveRecord]];
    
    NSString * stautMessage = nil;
    //TODO:这里数据库数据读取有问题,status如果没有不是nil
    if (![approveRecord.localStatus isEqualToString:kTableStatusMessageNormoal] &&![approveRecord.localStatus isEqualToString:kTableStatusMessageWaiting]) {
        stautMessage = [NSString stringWithFormat:@"%@",approveRecord.serverMessage];
    }
    return [HDTableStatusMessageItem itemWithTitle:title 
                                           caption:caption 
                                              text:text 
                                         timestamp:timestamp 
                                          selector:@selector(openDetailViewForKey:)
                                          delegate:self
                                           message:stautMessage 
                                             state:approveRecord.localStatus];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

//#pragma -mark TTTableViewDataSource delegate
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

@end
