//
//  HDMobileBusinessTests.m
//  HDMobileBusinessTests
//
//  Created by Plato on 7/30/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDMobileBusinessTests.h"

@implementation HDMobileBusinessTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testCoreStorage
{
    //insert
    NSMutableDictionary * record1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"test1",@"recordId",
                              @"测试001",@"serverId",
                              [NSDate dateWithTimeIntervalSince1970:0],@"timeStamp",
                              @"i测试Title",@"recordTitle",
                              kHDRecordStatusNormal,@"recordStatus",
                              kHDStorageStatusInsert,@"storageStatus",
                              nil];
    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDInsertTodoList recordSet:[NSArray arrayWithObject:record1]],@"insert failed");
    
    NSMutableDictionary * record2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"test2",@"recordId",
                                     @"测试002",@"serverId",
                                     [NSDate dateWithTimeIntervalSince1970:0],@"timeStamp",
                                     @"i测试Title",@"recordTitle",
                                     kHDRecordStatusNormal,@"recordStatus",
                                     kHDStorageStatusInsert,@"storageStatus",
                                     nil];
    
    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDSyncTodoList recordSet:[NSArray arrayWithObject:record2]],@"sync insert failed");
    //query

    NSArray * resultList = [[HDCoreStorage shareStorage] query:kHDQueryTodoList conditions:nil];
    //列表长度为2
    STAssertTrue(resultList.count == 2,@"list count is:%i",resultList.count);
    //记录对象是HDApprovalRecord
    TTDASSERT([[resultList objectAtIndex:0] isKindOfClass:[NSDictionary class]]);
    //数据校验
    record1 = [resultList objectAtIndex:0];
    record2 = [resultList objectAtIndex:1];

    STAssertEqualObjects([record1 valueForKey:@"recordId"], @"test1", @"获取recordId失败");
    STAssertEqualObjects([record1 valueForKey:@"serverId"], @"测试001", @"获取serverId失败");
    STAssertEqualObjects([record1 valueForKey:@"timeStamp"], [NSDate dateWithTimeIntervalSince1970:0], @"i获取timeStamp失败");
    STAssertEqualObjects([record1 valueForKey:@"recordTitle"], @"i测试Title", @"获取recordTitle失败",[record1 valueForKey:@"recordTitle"]);
    STAssertEqualObjects([record1 valueForKey:@"recordStatus"], kHDRecordStatusNormal,@"没有正确设置recordStatus",[record1 valueForKey:@"recordStatus"]);
    STAssertEqualObjects([record1 valueForKey:@"storageStatus"] ,kHDStorageStatusNormal, @"没有正确设置storageStatus",[record1 valueForKey:@"storageStatus"]);
    ///////////////
    STAssertEqualObjects([record2 valueForKey:@"recordId"], @"test2", @"获取recordId失败");
    STAssertEqualObjects([record2 valueForKey:@"serverId"], @"测试002", @"获取serverId失败");
    
    //update
    [record1 setValue:[NSDate dateWithTimeIntervalSince1970:10] forKey:@"timeStamp"];
    [record1 setValue:@"u测试Title1" forKey:@"recordTitle"];
    [record1 setValue:kHDRecordStatusDifferent forKey:@"recordStatus"];
    [record1 setValue:kHDStorageStatusUpdate forKey:@"storageStatus"];
    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDUpdateTodoList recordSet:[NSArray arrayWithObject:record1]], @"update failed");
    //sync update
    [record2 setValue:[NSDate dateWithTimeIntervalSince1970:10] forKey:@"timeStamp"];
    [record2 setValue:@"u测试Title1" forKey:@"recordTitle"];
    [record2 setValue:kHDRecordStatusDifferent forKey:@"recordStatus"];
    [record2 setValue:kHDStorageStatusUpdate forKey:@"storageStatus"];
    [[HDCoreStorage shareStorage] excute:@"sync" recordSet:[NSArray arrayWithObject:record2]];
    resultList = [[HDCoreStorage shareStorage] query:kHDQueryTodoList conditions:nil];
    record1 = [resultList objectAtIndex:0];
    record2 = [resultList objectAtIndex:1];
    STAssertEqualObjects([record1 valueForKey:@"timeStamp"], [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
    STAssertEqualObjects([record1 valueForKey:@"recordTitle"], @"u测试Title1", @"获取recordTitle失败",[record1 valueForKey:@"recordTitle"]);
    STAssertEqualObjects([record1 valueForKey:@"recordStatus"], kHDRecordStatusDifferent,@"没有正确设置recordStatus",[record1 valueForKey:@"recordStatus"]);
    STAssertEqualObjects([record1 valueForKey:@"storageStatus"] ,kHDStorageStatusNormal, @"没有正确设置storageStatus",[record1 valueForKey:@"storageStatus"]);
    ////////////////
    STAssertEqualObjects([record2 valueForKey:@"timeStamp"], [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
    STAssertEqualObjects([record2 valueForKey:@"recordTitle"], @"u测试Title1", @"获取recordTitle失败",[record1 valueForKey:@"recordTitle"]);
    STAssertEqualObjects([record2 valueForKey:@"recordStatus"], kHDRecordStatusDifferent,@"没有正确设置recordStatus",[record2 valueForKey:@"recordStatus"]);
    STAssertEqualObjects([record2 valueForKey:@"storageStatus"] ,kHDStorageStatusNormal, @"没有正确设置storageStatus",[record2 valueForKey:@"storageStatus"]);

    //remove
    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDRemoveTodoList recordSet:[NSArray arrayWithObject:record1]], @"remove failed");
    [record2 setValue:kHDStorageStatusRemove forKey:@"storageStatus"];
    [[HDCoreStorage shareStorage] excute:kHDSyncTodoList recordSet:[NSArray arrayWithObject:record2]];
    
    STAssertTrue(![[HDCoreStorage shareStorage] query:kHDQueryTodoList conditions:nil], @"删除记录失败") ;
}


@end
