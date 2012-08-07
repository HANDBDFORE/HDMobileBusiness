//
//  HDBaseRecord.h
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HDStorageStatusNormal = 0,
    HDStorageStatusInsert = 1,
    HDStorageStatusUpdate = 2,
    HDStorageStatusRemove = 3,
} HDStorageStatus;

@interface HDBaseRecord : NSObject

/*
 *在服务端的记录主键
 */
@property(nonatomic,copy) NSString * recordId;

/*
 *存储状态,本地存储同步方法根据该状态同步数据
 */
@property(nonatomic) HDStorageStatus storageStatus;


@end
