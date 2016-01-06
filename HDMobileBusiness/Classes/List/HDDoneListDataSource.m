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
@synthesize itemDictionary = _itemDictionary;

-(void)dealloc
{
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
    for (NSDictionary * record in self.model.resultList) {
        
        NSString * title = [[_itemDictionary valueForKey: @"title"] stringByReplacingSpaceHodlerWithDictionary:record];
        NSString * caption = [[_itemDictionary valueForKey:@"caption"] stringByReplacingSpaceHodlerWithDictionary:record];
        NSString * text = [[_itemDictionary valueForKey:@"text"] stringByReplacingSpaceHodlerWithDictionary:record];
    
        NSString * timestamp = [[_itemDictionary valueForKey:@"timestamp"] stringByReplacingSpaceHodlerWithDictionary:record];
        TTTableMessageItem * item =
        [TTTableMessageItem itemWithText:text
                                delegate:self
                                selector:@selector(openURLForItem:)];
        item.title = title;
        item.caption = caption;
        item.timestamp = timestamp;
        [self.items addObject:item];
    }
    [self.items addObject:[TTTableMoreButton itemWithText:TTLocalizedString(@"more...", @"")]];
}

-(void)openURLForItem:(TTTableItem *)item
{
    NSUInteger index = [self.items indexOfObject:item];
    [self.model setCurrentIndex:index];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"doneListTableGuider"];
    [guider perform];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return TTLocalizedString(@"search...", @"");
}

- (NSString*)titleForNoData {
    return TTLocalizedString(@"record is not found!", @"");
}

@end
