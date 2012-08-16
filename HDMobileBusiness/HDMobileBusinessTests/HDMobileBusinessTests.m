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

-(void)testConvertor
{
    //convert prepare data
    NSData * responseSingleData = [@"{\"result\":{\"record\":{\"number_field\":1,\"string_field\":\"string_1\",\"date_field\":\"2012-08-13 00:00:00\"}},\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    NSData * responseMutableData = [@"{\"result\":{\"record\":[{\"number_field\":1,\"string_field\":\"string_1\",\"date_field\":\"2012-08-13 00:00:00\"},{\"number_field\":2,\"string_field\":\"string_2\",\"date_field\":\"2012-08-13 00:00:00\"}]},\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    NSData * responseErrorData = [@"{ \"success\":false,\"error\":{\"message\":\"没有权限访问，或登录已失效\",\"code\":\"login_required\"}}  " dataUsingEncoding:NSUTF8StringEncoding];
    NSData * responseEmptyData = [@"{\"result\":{},\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error = nil;
    id singleRes = nil;
    id mutableRes = nil;
    id errorRes = nil;
    id emptyRes = nil;
    
    //////////////////////////////////////////////////////////////////////////////////////
    //DataToJSONConvertor
    id<HDDataConvertor>  convert=[[[HDDataToJSONConvertor alloc]init]autorelease];
   
    singleRes  = [convert doConvertor:responseSingleData error:&error];
    mutableRes  = [convert doConvertor:responseMutableData error:&error];
    errorRes = [convert doConvertor:responseErrorData error:&error];
    emptyRes = [convert doConvertor:responseEmptyData error:&error];
    STAssertEqualObjects([singleRes valueForKeyPath:@"result.record.number_field"], [NSNumber numberWithInt:1], @"signleRes is %@\n",singleRes);
    
     //////////////////////////////////////////////////////////////////////////////////////
    //test error data
    error = nil;
    STAssertNil([convert doConvertor:nil error:&error], @"error description is:%@\n",error.description);

    error = nil;
    STAssertNil([convert doConvertor:@"i am error data" error:&error], @"error description is:%@\n",error.description);

    error = nil;
    STAssertNil([convert doConvertor:[@"{i am error data}" dataUsingEncoding:NSUTF8StringEncoding]  error:&error], @"error description is:%@\n",error.description);
    
    //AuroraResponseConvertor
    id<HDDataConvertor>  auroraResponseConvert = [[[HDAuroraResponseConvertor alloc]init]autorelease];
    
    //////////////////////////////////////////////////////////////////////////////////////
    singleRes = [auroraResponseConvert doConvertor:singleRes error:&error];
    STAssertTrue([singleRes isKindOfClass:[NSArray class]], @"single convert should return an array");
    STAssertTrue([singleRes count]==1, @"return array's count is :%i\n",[singleRes count]);
    STAssertEqualObjects([[singleRes objectAtIndex:0] valueForKey:@"number_field"], [NSNumber numberWithInt:1], @"signleRes is %@\n",singleRes);
    
    //////////////////////////////////////////////////////////////////////////////////////
    mutableRes = [auroraResponseConvert doConvertor:mutableRes error:&error];
    STAssertTrue([mutableRes isKindOfClass:[NSArray class]], @"mutable convert should return an array");
    STAssertTrue([mutableRes count]==2, @"return array's count is :%i\n",[mutableRes count]);
    STAssertEqualObjects([[mutableRes objectAtIndex:0] valueForKey:@"number_field"], [NSNumber numberWithInt:1], @"mutableRes is %@\n",mutableRes);
    
    //////////////////////////////////////////////////////////////////////////////////////
    error = nil;
    errorRes = [auroraResponseConvert doConvertor:errorRes error:&error];
    STAssertNil(errorRes, @"error description is:%@\n",error.description);
    STAssertEqualObjects(error.localizedDescription, @"没有权限访问，或登录已失效", @"error description is:%@\n",error.localizedDescription);
    
    //////////////////////////////////////////////////////////////////////////////////////
    error = nil;
    emptyRes = [auroraResponseConvert doConvertor:emptyRes error:&error];
    STAssertNil(emptyRes, @"emptyRes is %@\n",emptyRes);
    STAssertNil(error, @"error description is:%@\n",error);
    
    //////////////////////////////////////////////////////////////////////////////////////
    //test error data
    error = nil;
    STAssertNil([auroraResponseConvert doConvertor:nil error:&error], @"error description is:%@\n",error.description);
    
    error = nil;
    STAssertNil([auroraResponseConvert doConvertor:@"i am error data" error:&error], @"error description is:%@\n",error.description);

    error = nil;
    STAssertNil([auroraResponseConvert doConvertor:@[@"{i am error data}"]  error:&error], @"error description is:%@\n",error.description);
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    //FieldMapConvertor
    HDFieldMapConvertor * mapConvert = [[[HDFieldMapConvertor alloc]init]autorelease];
    
   NSArray * mapList =  [NSArray arrayWithObjects:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"number_field",kMapFrom,
      @"number_col",kMapTo,
      nil],
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"string_field",kMapFrom,
      @"string_col",kMapTo,
      nil],
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"date_field",kMapFrom,
      @"date_col",kMapTo,
      nil],
     nil];
    
    [mapConvert setFieldMapData:mapList];
    id numberValue = [singleRes valueForKey:@"number_field"];    
    singleRes = [mapConvert doConvertor:singleRes error:&error];
    STAssertEqualObjects([singleRes valueForKey:@"number_col"], numberValue, @"key change faild");
    
    numberValue = [[mutableRes objectAtIndex:0] valueForKey:@"number_field"];
    mutableRes = [mapConvert doConvertor:mutableRes error:&error];
    STAssertEqualObjects([[mutableRes objectAtIndex:0] valueForKey:@"number_col"], numberValue, @"key change faild");
    
    //确保错误信息不被覆盖
    id errorResBackup = errorRes;
    errorRes = [mapConvert doConvertor:errorRes error:&error];
    STAssertEqualObjects(errorRes, errorResBackup, @"map convert error");
    
    //确保传入nil是不被判定为错误
    error = nil;
    id emptyResBackup = emptyRes;
    emptyRes = [mapConvert doConvertor:emptyRes error:&error];
    STAssertEqualObjects(emptyRes, emptyResBackup, @"map convert error");
    STAssertNil(error, @"map convert error");
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    //AuroraRequestConvertor
    id<HDDataConvertor>  auroraRequestConvert = [[[HDAuroraRequestConvertor  alloc]init] autorelease];
    id auroraRequestRes = [auroraRequestConvert doConvertor:singleRes error:&error];
    STAssertTrue([auroraRequestRes isKindOfClass:[NSDictionary class]], @"auroraRequestRes is %@\n",auroraRequestRes);
    STAssertEqualObjects([auroraRequestRes valueForKey:@"parameter"], singleRes, @"auroraRequestRes is %@\n",auroraRequestRes);
    
    //////////////////////////////////////////////////////////////////////////////////////
    //JSONToDataConvertor
    id<HDDataConvertor>  toDataConvert = [[[HDJSONToDataConvertor alloc]init] autorelease];
    id requestData = [toDataConvert doConvertor:auroraRequestRes error:&error];
    STAssertTrue([requestData isKindOfClass:[NSData class]], @"request Data is not kind of NSData");
    
    //////////////////////////////////////////////////////////////////////////////////////
    //DataToStringConvertor
    id<HDDataConvertor>  requestStringConvert = [[[HDDataToStringConvertor alloc]init] autorelease];
    id requestString = [requestStringConvert doConvertor:requestData error:&error];
    STAssertTrue([requestString isKindOfClass:[NSString class]], @"request string is not kind of NSString");
    //这里的校验受map的影响,修改mapping测试的时候这里需要做相应的修改,map后map排序会倒置
    STAssertEqualObjects(requestString, @"{\"parameter\":[{\"date_col\":\"2012-08-13 00:00:00\",\"number_col\":1,\"string_col\":\"string_1\"}]}", @"requestString is : %@\n",requestString);
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    //united test
    NSData * unitedTestData = [@"{\"result\":{\"record\":{\"number_field\":1,\"string_field\":\"string_1\",\"date_field\":\"2012-08-13 00:00:00\"}},\"success\":true}" dataUsingEncoding:NSUTF8StringEncoding];
    id<HDDataConvertor> convertor =
    [[[HDDataToJSONConvertor alloc]initWithNextConvertor:
      [[[HDAuroraResponseConvertor alloc]initWithNextConvertor:
      [[[HDAuroraRequestConvertor alloc]initWithNextConvertor:
       [[[HDJSONToDataConvertor alloc]initWithNextConvertor:
        [[[HDDataToStringConvertor alloc]init]autorelease]
         ]autorelease]
        ]autorelease]
       ]autorelease]
      ]autorelease];
    
    error = nil;
    id result =  [convertor doConvertor:unitedTestData error:&error];
    STAssertEqualObjects(result, @"{\"parameter\":[{\"number_field\":1,\"date_field\":\"2012-08-13 00:00:00\",\"string_field\":\"string_1\"}]}", @"result is :\n%@",result);
    
    id<HDDataConvertor> convertor1 =[[[HDDataToJSONConvertor alloc]init]autorelease];
    id<HDDataConvertor> convertor2 =[[[HDAuroraResponseConvertor alloc]init]autorelease];
    id<HDDataConvertor> convertor3 =[[[HDAuroraRequestConvertor alloc]init]autorelease];
    id<HDDataConvertor> convertor4 =[[[HDJSONToDataConvertor alloc]init]autorelease];
    id<HDDataConvertor> convertor5 =[[[HDDataToStringConvertor alloc]init]autorelease];
      
    [convertor1 setNextConvertor:convertor2];
    [convertor2 setNextConvertor:convertor3];
    [convertor3 setNextConvertor:convertor4];
    [convertor4 setNextConvertor:convertor5];
    
    error = nil;
    id rs = [convertor1 doConvertor:unitedTestData error:&error];
    STAssertEqualObjects(rs, @"{\"parameter\":[{\"number_field\":1,\"date_field\":\"2012-08-13 00:00:00\",\"string_field\":\"string_1\"}]}", @"result is :\n%@",rs);
}

-(void)testCoreStorage
{
    HDCoreStorage *CoreStorage= [HDCoreStorage shareStorage];
    STAssertTrue([CoreStorage excute:@selector(SQLcreatTable:) recordSet:nil],@"insert failed");
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Column0",@"Column0",@"ID",@"Column1",nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Column1",@"Column0",@"NAME",@"Column1",nil];
    NSArray *ary = [NSArray arrayWithObjects:dic1,dic2,nil];
    STAssertTrue([CoreStorage excute:@selector(SQLColumnMapInsert:recordSet:) recordSet:ary],@"insert failed");
    dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"ID",@"罗洪超",@"NAME",nil];
    dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"ID",@"马豪杰",@"NAME",nil];
    ary = [NSArray arrayWithObjects:dic1,dic2,nil];
    STAssertTrue([CoreStorage excute:@selector(SQLDataPoolInsert:recordSet:) recordSet:ary],@"insert failed");
    //query

    NSArray * resultList = [CoreStorage query:@selector(SQLqueryPersons:) conditions:nil];
    //列表长度为2
    STAssertTrue(resultList.count == 2,@"list count is:%i",resultList.count);
    //记录对象是HDApprovalRecordb DIC
    TTDASSERT([[resultList objectAtIndex:0] isKindOfClass:[NSDictionary class]]);
    //数据校验
    id record1 = [resultList objectAtIndex:0];
    id record2 = [resultList objectAtIndex:1];

    STAssertEqualObjects([record1 valueForKey:@"ID"], @"1", @"获取Id失败");
    STAssertEqualObjects([record1 valueForKey:@"NAME"], @"罗洪超", @"获取Name失败");
    ///////////////
    STAssertEqualObjects([record2 valueForKey:@"ID"], @"2", @"获取Id失败");
    STAssertEqualObjects([record2 valueForKey:@"NAME"], @"马豪杰", @"获取Name失败");
    
//    //update
//    [record1 setValue:[NSDate dateWithTimeIntervalSince1970:10] forKey:@"timeStamp"];
//    [record1 setValue:@"u测试Title1" forKey:@"recordTitle"];
//    [record1 setValue:kHDRecordStatusDifferent forKey:@"recordStatus"];
//    [record1 setValue:kHDStorageStatusUpdate forKey:@"storageStatus"];
//    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDUpdateTodoList recordSet:[NSArray arrayWithObject:record1]], @"update failed");
//    //sync update
//    [record2 setValue:[NSDate dateWithTimeIntervalSince1970:10] forKey:@"timeStamp"];
//    [record2 setValue:@"u测试Title1" forKey:@"recordTitle"];
//    [record2 setValue:kHDRecordStatusDifferent forKey:@"recordStatus"];
//    [record2 setValue:kHDStorageStatusUpdate forKey:@"storageStatus"];
//    [[HDCoreStorage shareStorage] excute:@"sync" recordSet:[NSArray arrayWithObject:record2]];
//    resultList = [[HDCoreStorage shareStorage] query:kHDQueryTodoList conditions:nil];
//    record1 = [resultList objectAtIndex:0];
//    record2 = [resultList objectAtIndex:1];
//    STAssertEqualObjects([record1 valueForKey:@"timeStamp"], [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
//    STAssertEqualObjects([record1 valueForKey:@"recordTitle"], @"u测试Title1", @"获取recordTitle失败",[record1 valueForKey:@"recordTitle"]);
//    STAssertEqualObjects([record1 valueForKey:@"recordStatus"], kHDRecordStatusDifferent,@"没有正确设置recordStatus",[record1 valueForKey:@"recordStatus"]);
//    STAssertEqualObjects([record1 valueForKey:@"storageStatus"] ,kHDStorageStatusNormal, @"没有正确设置storageStatus",[record1 valueForKey:@"storageStatus"]);
//    ////////////////
//    STAssertEqualObjects([record2 valueForKey:@"timeStamp"], [NSDate dateWithTimeIntervalSince1970:10], @"获取timeStamp失败");
//    STAssertEqualObjects([record2 valueForKey:@"recordTitle"], @"u测试Title1", @"获取recordTitle失败",[record1 valueForKey:@"recordTitle"]);
//    STAssertEqualObjects([record2 valueForKey:@"recordStatus"], kHDRecordStatusDifferent,@"没有正确设置recordStatus",[record2 valueForKey:@"recordStatus"]);
//    STAssertEqualObjects([record2 valueForKey:@"storageStatus"] ,kHDStorageStatusNormal, @"没有正确设置storageStatus",[record2 valueForKey:@"storageStatus"]);
//
//    //remove
//    STAssertTrue([[HDCoreStorage shareStorage] excute:kHDRemoveTodoList recordSet:[NSArray arrayWithObject:record1]], @"remove failed");
//    [record2 setValue:kHDStorageStatusRemove forKey:@"storageStatus"];
//    [[HDCoreStorage shareStorage] excute:kHDSyncTodoList recordSet:[NSArray arrayWithObject:record2]];
//    
//    STAssertTrue(![[HDCoreStorage shareStorage] query:kHDQueryTodoList conditions:nil], @"删除记录失败") ;
}

@end
