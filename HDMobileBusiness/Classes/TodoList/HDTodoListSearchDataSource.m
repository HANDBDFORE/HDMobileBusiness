//
//  HDWillAproveSearchListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListSearchDataSource.h"

@implementation HDTodoListSearchDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    //tableload完成生成cell item 对象列表
    self.items = [NSMutableArray array];
    for (id approvedRecord in self.todoListModel.resultList) {
        [self.items addObject:[self createItemWithObject:approvedRecord]
         ];
    }
}

#pragma mark UITable datasource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * localStatus =  [[self.todoListModel.resultList objectAtIndex:indexPath.row] valueForKeyPath:@"localStatus"];
    
    return ([localStatus isEqualToString:@"NORMAL"] || [localStatus isEqualToString:@"ERROR"]);
}

////#pragma -mark TTTableViewDataSource delegate
//-(NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
//{ 
//    TTDPRINT(@"search");
//    [self.items removeObjectAtIndex:indexPath.row];
//    [self.items insertObject:[self createItemWithObject:object] atIndex:indexPath.row];
//    return indexPath;
//}

-(void)openDetailViewForKey:(HDTableStatusMessageItem *)item
{
    //    HDWillAproveListModel * _approveListModel = (HDWillAproveListModel *) self.model;
    NSUInteger index = [self.items indexOfObject:item];
    NSString * url = [NSString stringWithFormat:@"%@/%i",kOpenWillApproveSearchDetailViewPath,index];
    TTOpenURL(url);
    //    return viewController;
}

#pragma mark Search

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
