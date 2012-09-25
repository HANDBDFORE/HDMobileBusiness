//
//  HDPersonPickDataSource.m
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListDataSource.h"

@implementation HDPersonListDataSource
@synthesize listModel = _listModel;
@synthesize itemDictionary = _itemDictionary;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_itemDictionary)
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        HDPersonListModel * model = [[[HDPersonListModel alloc]init] autorelease];
        self.model = model;
        self.listModel = model;
        self.itemDictionary =
        @{ @"text" : @"text",
        @"subtitle":@"subtitle",
        @"userInfo":@"userInfo"};
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (NSDictionary * record in self.listModel.resultList) {
        NSString * text = [self createCellItemWithTemplete:[self.itemDictionary valueForKey: @"text"] query:record];
        NSString * subtitle = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"subtitle"] query:record];
        NSString * userInfo = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"userInfo"] query:record];
        
        TTTableSubtitleItem * item = [TTTableSubtitleItem itemWithText:text subtitle:subtitle];
        item.userInfo = userInfo;
        [_items addObject:item];
    }
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

-(void)search:(NSString *)text
{
    if ([self.listModel respondsToSelector:@selector(search:)]){
        [self.listModel search:text];
    }
}
@end
