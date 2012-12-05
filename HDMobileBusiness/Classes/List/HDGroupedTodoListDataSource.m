//
//  HDGroupedTodoListDataSource.m
//  HDMobileBusiness
//
//  Created by Plato on 12/5/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDGroupedTodoListDataSource.h"

@implementation HDGroupedTodoListDataSource

- (void)dealloc
{
    TT_RELEASE_SAFELY(_listModel);
    TT_RELEASE_SAFELY(_groupedField);
    [super dealloc];
}
-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    
    NSSet *groupSet =[NSSet setWithArray:[self.listModel.resultList valueForKeyPath:_groupedField]];
    
    for (id record in groupSet) {
        [self.items addObject:[self createItemWithObject:record]
         ];
    }
}


-(void)openURLForItem:(TTTableTextItem *)item
{
    TTDPRINT(@"%@",item.userInfo);

//    HDViewGuider  * guider =  [[HDApplicationContext shareContext] objectForIdentifier:@"todolistTableGuider"];
//    if ([guider.destinationController respondsToSelector:@selector(setListModel:)]){
//        [guider.destinationController performSelector:@selector(setListModel:) withObject:self.listModel];
//    }
//    [guider perform];
    
}

/*
 *生成cell对应的item
 */
-(TTTableItem *) createItemWithObject:(NSString *) object
{    
    return [TTTableTextItem itemWithText:object delegate:self selector:@selector(openURLForItem:)];
}
/////////////
@end
