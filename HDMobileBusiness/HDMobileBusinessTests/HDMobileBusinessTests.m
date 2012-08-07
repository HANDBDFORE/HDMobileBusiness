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

- (void)testQuery
{
    NSArray * resultList = [[HDCoreStorage shareStorage] query:nil];

    //列表长度为1
    TTDASSERT(resultList.count == 1);
    //记录对象是HDApprovalRecord
    TTDASSERT([[resultList objectAtIndex:0] isKindOfClass:[HDApprovalRecord class]]);
    //数据校验
    HDApprovalRecord * record = [resultList objectAtIndex:0];
    STAssertEqualObjects(record.recordId, @"1", @"获取recordId失败");
    STAssertEqualObjects(record.serverId, @"test001", @"获取serverId失败");
    STAssertEqualObjects(record.comments, @"同意", @"获取comments失败");
    STAssertEqualObjects(record.userId, @"2991", @"获取userId失败");
    STAssertEqualObjects(record.userName, @"无", @"获取userName失败");
    STAssertEqualObjects(record.timeStamp, [NSDate dateWithTimeIntervalSince1970:0], @"获取timeStamp失败");
    STAssertEqualObjects(record.recordTitle, @"测试Title", @"获取recordTitle失败",record.recordTitle);
    STAssertEqualObjects(record.recordCaption, @"测试Caption", @"获取recordiCaption失败",record.recordCaption);
    STAssertEqualObjects(record.recordText, @"测试recordText", @"获取recordText失败",record.recordText);
    STAssertEqualObjects(record.recordImagePath, @"bundle://test.png", @"获取recordImagePath失败",record.recordImagePath);
    STAssertEqualObjects(record.exceptionMessage, @"记录已经被审批", @"获取exceptionMessage失败",record.exceptionMessage);
    STAssertEqualObjects(record.docPageUrl, @"module/test.screen", @"获取docPageUrl失败",record.docPageUrl);
    
    STAssertTrue(record.recordStatus == HDRecordStatusNormal,@"没有正确设置recordStatus",record.recordStatus);
    STAssertTrue(record.storageStatus == HDStorageStatusNormal, @"没有正确设置storageStatus",record.storageStatus);
    
//    STFail(@"Unit tests are not implemented yet in HDMobileBusinessTests");
}

@end
