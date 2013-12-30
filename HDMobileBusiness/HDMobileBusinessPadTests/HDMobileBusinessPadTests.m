//
//  HDMobileBusinessPadTests.m
//  HDMobileBusinessPadTests
//
//  Created by Plato on 11/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDMobileBusinessPadTests.h"
#import "HDTodoListSearchService.h"
#import "HDTodoListModel.h"

@implementation HDMobileBusinessPadTests

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

- (void)testExample
{
    HDTodoListSearchService * service = [[HDTodoListSearchService alloc]init];
    id<HDListModelSubmit,HDListModelQuery>  model = [[[HDTodoListModel alloc] init] autorelease];
    service.model = model;

    [service search:@"999"];
    STAssertTrue([[service resultList] count] > 0, @"can't find result with 999");
    [service search:nil];
    STAssertNil([service resultList], @"result is not nil");
    
}

@end
