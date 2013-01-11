//
//  HDTodoListSearchService.m
//  HDMobileBusiness
//
//  Created by Plato on 1/10/13.
//  Copyright (c) 2013 hand. All rights reserved.
//

#import "HDTodoListSearchService.h"

@interface HDTodoListSearchService ()

@property(nonatomic,copy)NSString * searchText;

@end

@implementation HDTodoListSearchService

- (void)dealloc
{
    TT_RELEASE_SAFELY(_searchText);
    TT_RELEASE_SAFELY(_searchFields);
    [super dealloc];
}

-(void)model:(id<TTModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchText) {
        [super model:model didUpdateObject:object atIndexPath:indexPath];
    }
}

-(void)model:(id<TTModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchText) {
        [super model:model didDeleteObject:object atIndexPath:indexPath];
    }
}

-(NSArray *)resultList
{
    NSIndexSet * matchedIndexSet = [[self.model resultList] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (self.searchText) {
            BOOL searchMatchFlag = NO;
            for (NSString * key in self.searchFields) {
                searchMatchFlag = searchMatchFlag || [[obj valueForKey:key] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
            }
            return searchMatchFlag;
        }else{
            return NO;
        }
    }];
    return [[self.model resultList] objectsAtIndexes:matchedIndexSet];
}

- (void)search:(NSString*)text
{
    [self cancel];
    self.searchText = text;
    self.currentIndex = 0;
    [self didFinishLoad];
}
@end
