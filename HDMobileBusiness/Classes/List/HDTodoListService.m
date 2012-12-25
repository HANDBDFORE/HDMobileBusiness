//
//  HDWillAproveListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTodoListService.h"

@interface HDTodoListService()

@property(nonatomic,copy)NSString * searchText;

@end

@implementation HDTodoListService

@synthesize searchText = _searchText;
@synthesize searchFields = _searchFields;
@synthesize currentIndex = _currentIndex;

@synthesize groupedCode = _groupedCode;
@synthesize groupedCodeField = _groupedCodeField;
@synthesize groupedValueField = _groupedValueField;

@dynamic groupResultList;

- (void)dealloc
{
//    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_searchText);
    TT_RELEASE_SAFELY(_searchFields);
    
    TT_RELEASE_SAFELY(_groupedCode);
    TT_RELEASE_SAFELY(_groupedCodeField);
    TT_RELEASE_SAFELY(_groupedValueField);
    
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
//        _resultList = [[NSMutableArray alloc] init];
        _vectorRange = NSMakeRange(0, 0);
        _currentIndex = 0;
        
        self.groupedCodeField = @"employee_name";
        self.groupedValueField = @"employee_name";
        self.groupedCode = @"9999";
        
        self.model = [[HDApplicationContext shareContext]objectForIdentifier:@"todoListModel"];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray *)resultList
{
    if (!self.groupedCode || !self.groupedCodeField)
    {
        return [self.model resultList];
    }
    NSIndexSet * matchedIndexSet = [[self.model resultList] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL matchFlag = [[obj valueForKey:_groupedCodeField] isEqualToString:_groupedCode];
        if (self.searchText) {
            BOOL searchMatchFlag = NO;
            for (NSString * key in self.searchFields) {
                searchMatchFlag = searchMatchFlag || [[obj valueForKey:key] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
            }
            matchFlag = matchFlag && searchMatchFlag;
        }
        return matchFlag;
    }];
    
    return [[self.model resultList] objectsAtIndexes:matchedIndexSet];
}

-(NSArray *)groupResultList
{
    if (!self.groupedValueField || !self.groupedCodeField)
    {
        return nil;
    }
    NSMutableSet * groupSet = [NSMutableSet set];
    for (NSDictionary * record in [self.model resultList]) {
        [groupSet addObject:@{@"codeField":[record valueForKeyPath:_groupedCodeField],
             @"valueField":[record valueForKeyPath:_groupedValueField]}];
    }
    return [groupSet sortedArrayUsingDescriptors:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)isEffectiveRecord:(NSDictionary *)record
{
    NSString * status = [record valueForKey:kRecordStatus];
    return [status isEqualToString:kRecordNormal] ||
    [status isEqualToString:kRecordError];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark ListModel Query
- (void)search:(NSString*)text
{
    [self cancel];
    self.searchText = text;
    [self didFinishLoad];
}

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
    NSArray * submitRecords = @[[self.resultList objectAtIndex:_currentIndex]];
    for (NSString * key in dictionary) {
        [submitRecords setValue:[dictionary valueForKey:key] forKey:key];
    }
    [self.model submitRecords:submitRecords];
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
    NSSet * resultSet = [NSSet setWithArray:self.resultList];
    return [[resultSet objectsWithOptions:NSEndsWithPredicateOperatorType
                              passingTest:^BOOL(id obj, BOOL *stop) {
                                  return [self isEffectiveRecord:obj];
                              }] count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSIndexPath *) currentIndexPath
{
    return [NSIndexPath indexPathForRow:_currentIndex inSection:0];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)current
{
    if ( _currentIndex < [self.resultList count] && [self effectiveRecordCount] > 0) {
        return [self.resultList objectAtIndex:_currentIndex];
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)next
{
    if ([self hasNext]) {
        _currentIndex += _vectorRange.length;
    }
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

-(void)prev
{
    if ([self hasPrev]) {
        _currentIndex -= _vectorRange.length;
        _vectorRange.length = 0;
    }
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)modelDidFinishLoad:(id<HDListModelQuery>)model
{
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)model:(id<TTModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didUpdateObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}


@end
