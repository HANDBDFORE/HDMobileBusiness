//
//  HDApproveListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListDataSource.h"
#import "HDTableStatusMessageItemCell.h"
#import "HDTodoListModelStatus.h"

@implementation HDTodoListDataSource

-(void)dealloc
{
    TT_RELEASE_SAFELY(_itemDictionary);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        self.itemDictionary =
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
    NSString * title = [[_itemDictionary valueForKey:@"title"] stringByReplacingSpaceHodlerWithDictionary:object];

    NSString * caption =[[_itemDictionary valueForKey:@"caption"] stringByReplacingSpaceHodlerWithDictionary:object];

    NSString * text = [[_itemDictionary valueForKey:@"text"] stringByReplacingSpaceHodlerWithDictionary:object];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * timestamp = [dateFormatter dateFromString:[[_itemDictionary valueForKey:@"timestamp"] stringByReplacingSpaceHodlerWithDictionary:object]];
    TT_RELEASE_SAFELY(dateFormatter);
    
    NSString * warning = [[_itemDictionary valueForKey:@"isLate"] stringByReplacingSpaceHodlerWithDictionary:object];
    
    NSString * stautMessage = nil;
    if (![[object valueForKey:kRecordStatus] isEqualToString:kRecordNormal] &&![[object valueForKey:kRecordStatus] isEqualToString:kRecordWaiting]) {
        stautMessage = [object valueForKey:kRecordServerMessage];
    }
        
    HDTableStatusMessageItem * item =
    [HDTableStatusMessageItem itemWithTitle:title
                                    caption:caption
                                       text:text
                                  timestamp:timestamp
                                    message:stautMessage
                                      state:[object valueForKey:kRecordStatus]
                                    warning:warning];
     
//                                           :title
//                                    caption:caption
//                                       text:text
//                                  timestamp:timestamp
//                                   selector:@selector(openURLForItem:)
//                                   delegate:self
//                                    message:stautMessage
//                                      state:[object valueForKey:kRecordStatus]
//                                    warning:warning];
    item.userInfo = [object valueForKey:kRecordStatus];
    return item;
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
    for (id record in self.model.resultList) {
        [self.items addObject:[self createItemWithObject:record]
         ];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark UITable datasource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:这里之后需要统一keyPath
    NSString * localStatus = [[self.items objectAtIndex:indexPath.row] valueForKeyPath:@"state"];
    
    return ([localStatus isEqualToString:kRecordNormal] ||
            [localStatus isEqualToString:kRecordError]);
}

-(void)openURLForItem:(HDTableStatusMessageItem *)item
{
    if ([item.state isEqualToString:kRecordNormal] ||
        [item.state isEqualToString:kRecordError]) {
        self.model.currentIndex = [self.items indexOfObject:item];

        HDSplitViewGuider * guider =  [[HDApplicationContext shareContext] objectForIdentifier:@"todolistTableGuider"];
        guider.pageTurningService = self.model;
        [guider perform];
    }
}

- (void)search:(NSString*)text {
    if ([self.model respondsToSelector:@selector(search:)]) {
        [self.model search:text];
    }
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"查找...";
}

- (NSString*)titleForNoData {
    return @"没有找到记录";
}

@end
