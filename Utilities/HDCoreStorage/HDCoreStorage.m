//
//  HDCoreStorage.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDCoreStorage.h"

static HDCoreStorage * globalStorage = nil;

@interface HDCoreStorage()
@property(nonatomic,readonly) NSMutableArray * tempList;

@end

@implementation HDCoreStorage
@synthesize tempList = _tempList;

+(id)shareStorage
{
    if (nil == globalStorage) {
        globalStorage = [[self alloc]init];
    }
    return globalStorage;
}

- (void)dealloc
{
    TT_RELEASE_CF_SAFELY(_tempList);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _tempList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)query:(NSString *)handler conditions:(id)conditions
{
    TTDPRINT(@"list count :%i\n", self.tempList.count);
    if (self.tempList.count >0) {
        for (id record in self.tempList) {
            [record setValue:kHDStorageStatusNormal forKey:@"storageStatus"];
        }
        return self.tempList;
    }
    return nil;
}

-(BOOL)excute:(NSString *)handler recordSet:(id)recordSet
{
    if ([handler isEqualToString:kHDInsertTodoList]) {
        return [self insert:recordSet];
    }
    if ([handler isEqualToString:kHDUpdateTodoList]) {
        return [self update:recordSet];
    }
    if ([handler isEqualToString:kHDRemoveTodoList]) {
        return [self remove:recordSet];
    }
    if ([handler isEqualToString:kHDSyncTodoList]) {
        return [self sync:recordSet];
    }
    return NO;
}

-(BOOL)insert:(id) data
{
    [self.tempList insertObjects:data
                       atIndexes:[[NSIndexSet alloc] initWithIndex:self.tempList.count]];
    return YES;
}

-(BOOL)update:(id) data
{
    return YES;
}

-(BOOL)remove:(id) data
{
    [self.tempList removeObjectsInArray:data];
    TTDPRINT(@"call remove");
    return YES;
}

-(BOOL)sync:(id)data
{
    HDApprovalRecord * record = [data objectAtIndex:0];
    NSString * storageStatus = [record valueForKey:@"storageStatus"];
    TTDPRINT(@"%@",storageStatus);
    if ([storageStatus isEqualToString:kHDStorageStatusInsert]) {
        return [self insert:data];
    }
    if ([storageStatus isEqualToString:kHDStorageStatusUpdate]) {
        return [self update:data];
    }
    if ([storageStatus isEqualToString:kHDStorageStatusRemove]) {
        return [self remove:data];
    }
    return NO;
}

@end
