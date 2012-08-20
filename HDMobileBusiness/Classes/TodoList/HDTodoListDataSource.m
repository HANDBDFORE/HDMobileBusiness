//
//  HDApproveListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListDataSource.h"
//#import "HDDetailSubmitModel.h"

@implementation HDTodoListDataSource

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
