//
//  HDApproveListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDListModel.h"
#import "HDTableDataSource.h"

@interface HDTodoListDataSource : TTListDataSource <HDTableDataSource>

@property(nonatomic,retain) id<HDTodoListService,HDPageTurning> model;

#pragma -override


@property(nonatomic,retain) NSDictionary * itemDictionary;



-(NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

-(NSIndexPath *)tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

-(void)tableViewDidLoadModel:(UITableView *)tableView;

@end
