//
//  HDWillApproveListDelegate.m
//  hrms
//
//  Created by Rocky Lee on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListDelegate.h"

@implementation HDTodoListDelegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSNumber * count =  [NSNumber numberWithInt:tableView.indexPathsForSelectedRows.count];
        if ([self.controller respondsToSelector:@selector(setToolbarButtonTitleWithCount:)])
        {
            [self.controller performSelector:@selector(setToolbarButtonTitleWithCount:) withObject:count];
        }
        
    }else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSNumber * count =  [NSNumber numberWithInt:tableView.indexPathsForSelectedRows.count];
        if ([self.controller respondsToSelector:@selector(setToolbarButtonTitleWithCount:)])
        {
            [self.controller performSelector:@selector(setToolbarButtonTitleWithCount:) withObject:count];
        }
    }
}

@end
