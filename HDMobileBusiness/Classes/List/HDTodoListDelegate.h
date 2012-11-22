//
//  HDWillApproveListDelegate.h
//  hrms
//
//  Created by Rocky Lee on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface HDTodoListDelegate : TTTableViewDragRefreshDelegate

#pragma -override
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
