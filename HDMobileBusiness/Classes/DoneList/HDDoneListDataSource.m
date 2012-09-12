//
//  HDDoneListListDataSource.m
//  HandMobile
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListDataSource.h"
#import "HDDoneListModel.h"

////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDDoneListDataSource
@synthesize listModel = _listModel;
@synthesize cellItemMap = _cellItemMap;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_cellItemMap);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        HDDoneListModel * model = [[[HDDoneListModel alloc]init] autorelease];
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

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    for (NSDictionary * record in self.listModel.resultList) {
        
        NSString * title = [self createCellItemWithTemplete:[_cellItemMap valueForKey: @"title"] query:record];
        NSString * caption = [self createCellItemWithTemplete:[_cellItemMap valueForKey:@"caption"] query:record];
        NSString * text = [self createCellItemWithTemplete:[_cellItemMap valueForKey:@"text"] query:record];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate * timestamp = [dateFormatter dateFromString:[self createCellItemWithTemplete:[_cellItemMap valueForKey:@"timestamp"] query:record]];
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

-(void)openURLForKey:(TTTableItem *)item
{
    NSUInteger index = [self.items indexOfObject:item];
    TTDPRINT(@"row :%i is being selected",index);
    
    [self.listModel setCurrentIndex:index];
    [[TTNavigator navigator]openURLAction:[[[TTURLAction actionWithURLPath:@"guide://createViewControler/DETIAL_VC_PATH"]applyQuery:@{ @"listModel" : self.listModel}]applyAnimated:YES]];
}

- (NSString*)titleForLoading:(BOOL)reloading {
    return @"查找...";
}

- (NSString*)titleForNoData {
    return @"没有找到记录";
}

@end
