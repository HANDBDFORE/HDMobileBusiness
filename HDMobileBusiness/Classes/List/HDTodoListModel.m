//
//  HDWillAproveListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTodoListService.h"

@interface HDTodoListModel()

@property(nonatomic,copy)NSString * searchText;

@property(nonatomic,retain) id<TTModel,HDListModelSubmit> service;

@end

@implementation HDTodoListModel
@synthesize resultList = _resultList;
@synthesize searchText = _searchText;
@synthesize searchFields = _searchFields;
@synthesize currentIndex = _currentIndex;

@dynamic  groupResultList;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_searchText);
    TT_RELEASE_SAFELY(_searchFields);
    
    TT_RELEASE_SAFELY(_groupedCode);
    TT_RELEASE_SAFELY(_groupedCodeField);
    TT_RELEASE_SAFELY(_groupedValueField);
    
    TT_RELEASE_SAFELY(_service);
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        _resultList = [[NSMutableArray alloc] init];
        _vectorRange = NSMakeRange(0, 0);
        _currentIndex = 0;
        
        self.groupedCodeField = @"employee_name";
        self.groupedValueField = @"employee_name";
        self.groupedCode = @"9999";
        
        self.service = [[HDApplicationContext shareContext]objectForIdentifier:@"todoListService"];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setService:(id <TTModel,HDListModelSubmit>)service
{
    if (_service != service) {
        [_service.delegates removeObject:self];
        [_service release];
        _service = [service retain];
        [_service.delegates addObject:self];
    }
}

#pragma mark TTModel protocol
-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    [_service load:cachePolicy more:more];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)resultList
{
    if (!self.groupedCode || !self.groupedCodeField)
    {
        return _resultList;
    }
    NSIndexSet * matchedIndexSet = [_resultList indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
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
    
    return [_resultList objectsAtIndexes:matchedIndexSet];
}

-(NSArray *)groupResultList
{
    if (!self.groupedValueField || !self.groupedCodeField)
    {
        return nil;
    }
    NSMutableSet * groupSet = [NSMutableSet set];
    for (NSDictionary * record in _resultList) {
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
    [self.service submitRecords:submitRecords dictionary:dictionary];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary
{
    [self.service submitRecords:@[[self.resultList objectAtIndex:_currentIndex]]
             dictionary:dictionary];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)removeRecordAtIndex:(NSUInteger) index
{
    if (self.resultList.count == 0) {
        return;
    }
    id record = [self.resultList objectAtIndex:index];
    if ([[record valueForKey:kRecordStatus] isEqualToString:kRecordDifferent]) {
        //remove
        [self.service removeRecord:record];
        [_resultList removeObject:record];
//        [self didDeleteObject:record atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
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
-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    [self didFailLoadWithError:error];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [_resultList removeAllObjects];
    [_resultList addObjectsFromArray:self.service.resultList];
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)modelDidBeginUpdates:(id<TTModel>)model
{
    [self beginUpdates];
}

-(void)modelDidCancelLoad:(id<TTModel>)model
{
    [self didCancelLoad];
}

-(void)modelDidChange:(id<TTModel>)model
{
    [self didChange];
}

-(void)modelDidEndUpdates:(id<TTModel>)model
{
    [self endUpdates];
}

-(void)modelDidStartLoad:(id<TTModel>)model
{
    [self didStartLoad];
}

-(void)model:(id<TTModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    [_resultList removeAllObjects];
    [_resultList addObjectsFromArray:[self.service resultList]];
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didUpdateObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}

-(void)model:(id<TTModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didDeleteObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}

-(void)model:(id<TTModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didInsertObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}

#pragma mark override TTModel
-(BOOL)isLoaded
{
    return [self.service isLoaded];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isLoading
{
    return [self.service isLoading];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isLoadingMore
{
    return [self.service isLoadingMore];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isOutdated
{
    return [self.service isOutdated];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)cancel
{
    [self.service cancel];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)invalidate:(BOOL)erase
{
    [self.service invalidate:erase];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSDate *)loadedTime
{
    return [(TTURLRequestModel *)self.service loadedTime];
}

@end
