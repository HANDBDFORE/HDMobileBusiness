//
//  HDWillAproveListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTodoListService.h"

@implementation HDTodoListService

@synthesize currentIndex = _currentIndex;

- (id)init
{
    self = [super init];
    if (self) {
        _vectorRange = NSMakeRange(0, 0);
        _currentIndex = 0;
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray *)resultList
{
    return [self.model resultList];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)isEffectiveRecord:(NSDictionary *)record
{
    NSString * status = [record valueForKey:kRecordStatus];
    return [status isEqualToString:kRecordNew] ||
    [status isEqualToString:kRecordError];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark ListModel Submit
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary
{
    NSMutableArray * submitRecords = [NSMutableArray array];
    for (NSIndexPath * indexPath in indexPaths) {
        [submitRecords addObject: [self.resultList objectAtIndex:indexPath.row]];
    }
    for (NSString * key in dictionary) {
        [submitRecords setValue:[dictionary valueForKey:key] forKey:key];
    }
    [self.model submitRecords:submitRecords];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary
{
    if (self.currentIndex < self.resultList.count) {
        NSArray * submitRecords = @[[self.resultList objectAtIndex:self.currentIndex]];
        for (NSString * key in dictionary) {
            [submitRecords setValue:[dictionary valueForKey:key] forKey:key];
        }
        [self.model submitDeliverRecords:submitRecords];
    }
}

#pragma 2014-10-19 JS 返回刷新调用

-(void)reflesh1
{
    [self.model load:nil more:nil];
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)removeRecordAtIndex:(NSUInteger) index
{
    if (self.resultList.count == 0) {
        return;
    }
    id record = [self.resultList objectAtIndex:index];
    if ([[record valueForKey:kRecordStatus] isEqualToString:kRecordDifferent]) {
        [self.model removeRecord:record];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark ListModel Vector
-(NSUInteger)effectiveRecordCount
{
    return [self.resultList count];
//    NSSet * resultSet = [NSSet setWithArray:self.resultList];
//    return [[resultSet objectsWithOptions:NSEndsWithPredicateOperatorType
//                              passingTest:^BOOL(id obj, BOOL *stop) {
//                                  return [self isEffectiveRecord:obj];
//                              }] count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSIndexPath *) currentIndexPath
{
    if ([self effectiveRecordCount] > 0) {
        return [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)current
{
    if ( [self effectiveRecordCount] > 0) {
        NSDictionary * record = [self.resultList objectAtIndex:self.currentIndex];
        if([self isEffectiveRecord:record]){
            return record;
        }
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger)currentIndex
{
    if (self.resultList.count <= _currentIndex) {
        _currentIndex = self.resultList.count - 1;
    }
    return _currentIndex;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)next
{
    if ([self hasNext]) {
        _currentIndex += _vectorRange.length;
    }
    return [self current];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasNext
{
    _vectorRange.length = 0;
    return [self hasNextRecordAtIndex:_currentIndex];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasNextRecordAtIndex:(NSUInteger)index
{
    NSUInteger nextIndex = index + 1;
    _vectorRange.length ++;
    if (nextIndex >= [self.resultList count]) {
        return NO;
    }
    
    BOOL hasNextRecord = YES;
    //如果不是有效的记录，获取下一条
    id record = [self.resultList objectAtIndex:nextIndex];
    if (![self isEffectiveRecord:record]) {
        hasNextRecord = [self hasNextRecordAtIndex:nextIndex];
    }
    return hasNextRecord;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)prev
{
    if ([self hasPrev]) {
        _currentIndex -= _vectorRange.length;
        _vectorRange.length = 0;
    }
    return [self current];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasPrev
{
    _vectorRange.length = 0;
    return [self hasPrevRecordAtIndex:_currentIndex];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasPrevRecordAtIndex:(NSUInteger) index
{
    if (index == 0) {
        return NO;
    }
    NSUInteger prevIndex = index - 1;
    _vectorRange.length ++ ;
    BOOL hasPrevRecord = YES;
    id record = [self.resultList objectAtIndex:prevIndex];
    if (![self isEffectiveRecord:record]) {
        hasPrevRecord = [self hasPrevRecordAtIndex:prevIndex];
    }
    return hasPrevRecord;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark TTModelDelegate functions
-(void)model:(id<TTModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _currentIndex) {
        _currentIndex --;
    }
    [super model:model didDeleteObject:object atIndexPath:indexPath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@end
