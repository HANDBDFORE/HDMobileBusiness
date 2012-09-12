//
//  HDPersonPickDataSource.m
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListDataSource.h"

@implementation HDPersonListDataSource
@synthesize personListModel = _personListModel;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_personListModel);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _personListModel = [[HDPersonListModel alloc]init];
        self.model = _personListModel;
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    
    for (NSString* name in _personListModel.resultList) {
        TTTableItem* item = [TTTableTextItem itemWithText:name URL:@"http://google.com"];
        [_items addObject:item];
    }
}

-(void)search:(NSString *)text
{
    [_personListModel search:text];
}
@end
