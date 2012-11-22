//
//  HDDoneListListDataSource.m
//  HandMobile
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListDataSource.h"

////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDDoneListDataSource
@synthesize listModel = _listModel;
@synthesize itemDictionary = _itemDictionary;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_listModel);
    TT_RELEASE_SAFELY(_itemDictionary);
    [super dealloc];
}

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

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (NSDictionary * record in self.listModel.resultList) {
        
        NSString * title = [[_itemDictionary valueForKey: @"title"] stringByReplacingSpaceHodlerWithDictionary:record];
        NSString * caption = [[_itemDictionary valueForKey:@"caption"] stringByReplacingSpaceHodlerWithDictionary:record];
        NSString * text = [[_itemDictionary valueForKey:@"text"] stringByReplacingSpaceHodlerWithDictionary:record];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * timestamp = [dateFormatter dateFromString:[[_itemDictionary valueForKey:@"timestamp"] stringByReplacingSpaceHodlerWithDictionary:record]];

        TT_RELEASE_SAFELY(dateFormatter);
        if (!timestamp) {
            timestamp = [NSDate dateWithToday];
        }
        
        TTTableMessageItem * item =
        [TTTableMessageItem itemWithText:text
                                delegate:self
                                selector:@selector(openURLForKey:)];
        item.title = title;
        item.caption = caption;
        item.timestamp = timestamp;
        [self.items addObject:item];
    }
    [self.items addObject:[TTTableMoreButton itemWithText:@"更多..."]];
}

-(void)openURLForKey:(TTTableItem *)item
{
    NSUInteger index = [self.items indexOfObject:item];
    [self.listModel setCurrentIndex:index];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"doneListTableGuider"];
    [guider perform];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"查找...";
}

- (NSString*)titleForNoData {
    return @"没有找到记录";
}

@end
