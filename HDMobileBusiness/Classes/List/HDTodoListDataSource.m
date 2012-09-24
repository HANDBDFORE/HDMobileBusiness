//
//  HDApproveListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListDataSource.h"
#import "HDTableStatusMessageItemCell.h"

@implementation HDTodoListDataSource

@synthesize listModel = _listModel;
@synthesize cellItemMap = _cellItemMap;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_cellItemMap);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        HDTodoListModel *model = [[[HDTodoListModel alloc]init] autorelease];
        self.model = model;
        self.listModel = model;
        
        self.cellItemMap =
        @{@"title":@"title",
        @"caption":@"caption",
        @"text":@"text",
        @"timestamp":@"timestamp"};
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *生成cell对应的item
 */
-(TTTableItem *) createItemWithObject:(NSDictionary *) object
{
    NSString * title = [[_cellItemMap valueForKey:@"title"] stringByReplacingSpaceHodlerWithDictionary:object];

    NSString * caption =[[_cellItemMap valueForKey:@"caption"] stringByReplacingSpaceHodlerWithDictionary:object];

    NSString * text = [[_cellItemMap valueForKey:@"text"] stringByReplacingSpaceHodlerWithDictionary:object];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * timestamp = [dateFormatter dateFromString:[[_cellItemMap valueForKey:@"timestamp"] stringByReplacingSpaceHodlerWithDictionary:object]];
    TT_RELEASE_SAFELY(dateFormatter);
    
    NSString * warning = [[_cellItemMap valueForKey:@"isLate"] stringByReplacingSpaceHodlerWithDictionary:object];
    
    NSString * stautMessage = nil;
    if (![[object valueForKey:kRecordStatus] isEqualToString:kRecordNormal] &&![[object valueForKey:kRecordStatus] isEqualToString:kRecordWaiting]) {
        stautMessage = [object valueForKey:kRecordServerMessage];
    }
    
    return [HDTableStatusMessageItem itemWithTitle:title
                                           caption:caption
                                              text:text
                                         timestamp:timestamp
                                          selector:@selector(openURLForKey:)
                                          delegate:self
                                           message:stautMessage
                                             state:[object valueForKey:kRecordStatus]
                                           warning:warning];
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
    for (id record in self.listModel.resultList) {
        [self.items addObject:[self createItemWithObject:record]
         ];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark UITable datasource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * localStatus =  [[self.listModel.resultList objectAtIndex:indexPath.row] valueForKeyPath:kRecordStatus];
    
    return ([localStatus isEqualToString:kRecordNormal] ||
            [localStatus isEqualToString:kRecordError]);
}

-(void)openURLForKey:(HDTableStatusMessageItem *)item
{
    if ([item.state isEqualToString:kRecordNormal] ||
        [item.state isEqualToString:kRecordError]) {
        self.listModel.currentIndex = [self.items indexOfObject:item];
        [[TTNavigator navigator]openURLAction:[[[TTURLAction actionWithURLPath:@"guide://createViewControler/TOOLBAR_DETIAL_VC_PATH"]applyQuery:@{ @"listModel" : self.listModel}]applyAnimated:YES]];
    }
}

- (void)search:(NSString*)text {
    if ([self.listModel respondsToSelector:@selector(search:)]) {
        [self.listModel search:text];
    }
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"查找...";
}

- (NSString*)titleForNoData {
    return @"没有找到记录";
}

@end
