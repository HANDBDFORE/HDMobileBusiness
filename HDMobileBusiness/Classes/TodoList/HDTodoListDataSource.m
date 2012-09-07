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

@synthesize todoListModel = _todoListModel;
@synthesize cellItemMap = _cellItemMap;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_todoListModel);
    TT_RELEASE_SAFELY(_cellItemMap);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        _todoListModel = [[HDTodoListModel alloc]init];
        self.model = _todoListModel;
       
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
    NSString * title = [self createCellItemWithTemplete:[_cellItemMap valueForKey: @"title"] query:object];
    NSString * caption = [self createCellItemWithTemplete:[_cellItemMap valueForKey:@"caption"] query:object];
    NSString * text = [self createCellItemWithTemplete:[_cellItemMap valueForKey:@"text"] query:object];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * timestamp = [dateFormatter dateFromString:[self createCellItemWithTemplete:[_cellItemMap valueForKey:@"timestamp"] query:object]];
    TT_RELEASE_SAFELY(dateFormatter);
    
    NSString * warning = [self createCellItemWithTemplete:[_cellItemMap valueForKey:@"isLate"] query:object];
    
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

-(NSString *)createCellItemWithTemplete:(NSString *) templete
                                  query:(NSDictionary *)query
{
    NSEnumerator * e = [query keyEnumerator];
    for (NSString * key; (key = [e nextObject]);) {
        NSString * replaceString = [NSString stringWithFormat:@"${%@}",key];
        NSString * valueString = [NSString stringWithFormat:@"%@",[query valueForKey:key]];
        
        templete = [templete stringByReplacingOccurrencesOfString:replaceString withString:valueString];
    }
    return templete;
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
    for (id approvedRecord in self.todoListModel.resultList) {
        [self.items addObject:[self createItemWithObject:approvedRecord]
         ];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark UITable datasource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * localStatus =  [[self.todoListModel.resultList objectAtIndex:indexPath.row] valueForKeyPath:kRecordStatus];
    
    return ([localStatus isEqualToString:kRecordNormal] ||
            [localStatus isEqualToString:kRecordError]);
}

-(void)openURLForKey:(HDTableStatusMessageItem *)item
{
    if ([item.state isEqualToString:kRecordNormal] ||
        [item.state isEqualToString:kRecordError]) {
        self.todoListModel.currentIndex = [self.items indexOfObject:item];
        [[TTNavigator navigator]openURLAction:[[[TTURLAction actionWithURLPath:@"guide://createViewControler/TOOLBAR_DETIAL_VC_PATH"]applyQuery:@{ @"listModel" : self.todoListModel}]applyAnimated:YES]];
    }
}

- (void)search:(NSString*)text {
    [self.todoListModel search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"查找...";
}

- (NSString*)titleForNoData {
    return @"没有找到记录";
}

@end
