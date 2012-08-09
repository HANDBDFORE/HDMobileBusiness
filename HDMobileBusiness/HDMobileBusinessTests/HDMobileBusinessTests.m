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
    HDApprovalRecord * record1 = [[[HDApprovalRecord alloc]init] autorelease];
    record1.recordId = @"test1";
    record1.serverId = @"测试001";
    record1.timeStamp = [NSDate dateWithTimeIntervalSince1970:0];
    record1.recordTitle = @"i测试Title";
    record1.recordStatus = HDRecordStatusNormal;
    STAssertTrue([[HDCoreStorage shareStorage] insert:[NSArray arrayWithObject:record1]],@"insert failed");
    HDApprovalRecord * record2 = [[[HDApprovalRecord alloc]init] autorelease];
    record2.recordId = @"test2";
    record2.serverId = @"测试002";
    record2.timeStamp = [NSDate dateWithTimeIntervalSince1970:0];
    record2.recordTitle = @"i测试Title";
    record2.recordStatus = HDRecordStatusNormal;
    [[HDCoreStorage shareStorage] sync:[NSArray arrayWithObject:record2]];
    //query
    NSArray * resultList = [[HDCoreStorage shareStorage] query:nil];
    //列表长度为2
    STAssertTrue(resultList.count == 2,@"list count is:%i",resultList.count);
    //记录对象是HDApprovalRecord
    TTDASSERT([[resultList objectAtIndex:0] isKindOfClass:[HDApprovalRecord class]]);
    //数据校验
    record1 = [resultList objectAtIndex:0];
    record2 = [resultList objectAtIndex:1];
    
    STAssertEqualObjects(record1.recordId, @"test1", @"获取recordId失败");
    STAssertEqualObjects(record1.serverId, @"测试001", @"获取serverId失败");
    STAssertEqualObjects(record1.timeStamp, [NSDate dateWithTimeIntervalSince1970:0], @"i获取timeStamp失败");
    STAssertEqualObjects(record1.recordTitle, @"i测试Title", @"获取recordTitle失败",record1.recordTitle);
    STAssertTrue(record1.recordStatus == HDRecordStatusNormal,@"没有正确设置recordStatus",record1.recordStatus);
    STAssertTrue(record1.storageStatus == HDStorageStatusNormal, @"没有正确设置storageStatus",record1.storageStatus);
    ///////////////
    STAssertEqualObjects(record2.recordId, @"test2", @"获取recordId失败");
    STAssertEqualObjects(record2.serverId, @"测试002", @"获取serverId失败");
    
    //update
    record1.timeStamp = [NSDate dateWithTimeIntervalSince1970:10];
    record1.recordTitle = @"u测试Title1";
    record1.recordStatus = HDRecordStatusDifferent;
    record1.storageStatus = HDStorageStatusUpdate;
    STAssertTrue([[HDCoreStorage shareStorage] update:[NSArray arrayWithObject:record1]], @"update failed");
    //sync update
    record2.timeStamp = [NSDate dateWithTimeIntervalSince1970:10];
    record2.recordTitle = @"u测试Title2";
    record2.recordStatus = HDRecordStatusDifferent;
    record2.storageStatus = HDStorageStatusUpdate;
    [[HDCoreStorage shareStorage] sync:[NSArray arrayWithObject:record2]];
    resultList = [[HDCoreStorage shareStorage] query:nil];
    record1 = [resultList objectAtIndex:0];
    record2 = [resultList objectAtIndex:1];
    
    STAssertEqualObjects(record1.timeStamp, [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
    STAssertEqualObjects(record1.recordTitle, @"u测试Title1", @"获取recordTitle失败",record1.recordTitle);
    STAssertTrue(record1.recordStatus == HDRecordStatusDifferent,@"没有正确设置recordStatus",record1.recordStatus);
    STAssertTrue(record1.storageStatus == HDStorageStatusNormal, @"没有正确设置storageStatus",record1.storageStatus);
    ////////////////
    STAssertEqualObjects(record2.timeStamp, [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
    STAssertEqualObjects(record2.recordTitle, @"u测试Title2", @"获取recordTitle失败",record1.recordTitle);
    STAssertTrue(record2.recordStatus == HDRecordStatusDifferent,@"没有正确设置recordStatus",record1.recordStatus);
    STAssertTrue(record2.storageStatus == HDStorageStatusNormal, @"没有正确设置storageStatus",record1.storageStatus);
    
    //remove
    STAssertTrue([[HDCoreStorage shareStorage] remove:[NSArray arrayWithObject:record1]], @"remove failed");
    record2.storageStatus = HDStorageStatusRemove;
    [[HDCoreStorage shareStorage] sync:[NSArray arrayWithObject:record2]];
    
    STAssertTrue(![[HDCoreStorage shareStorage] query:nil], @"删除记录失败") ;
}


@end
