//
//  HDApprovalRecord.h
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseRecord.h"

typedef enum{
    HDRecordStatusNormal = 0,
    HDRecordStatusWaiting = 1,
    HDRecordStatusError = 2,
    HDRecordStatusDifferent = 3,
} HDRecordStatus;

@interface HDApprovalRecord : HDBaseRecord

/*
 *服务端唯一标示,考虑到可能会存在多个服务端接入 的情况,需要标识出该记录属于哪个服务端
 */
@property(nonatomic,copy) NSString * serverId;
/*
 *意见
 */
@property(nonatomic,copy) NSString * comments;
/*
 *提交人的 id
 */
@property(nonatomic,copy) NSString * userId;
/*
 *提交人的姓名
 */
@property(nonatomic,copy) NSString * userName;
/*
 *时间戳,提交日期,在 cell 右上角显示
 */
@property(nonatomic,copy) NSString * timeStamp;
/*
 *记录标题:cell 大标题
 */
@property(nonatomic,copy) NSString * recordTitle;
/*
 *记录附标题:cell 附标题
 */
@property(nonatomic,copy) NSString * recordCaption;
/*
 *记录的简短描述
 */
@property(nonatomic,copy) NSString * recordText;
/*
 *记录的图片地址:cell 的图片
 */
@property(nonatomic,copy) NSString * recordImagePath;
/*
 *异常消息:记录已经被审批,审批动作不存在
 */
@property(nonatomic,copy) NSString * exceptionMessage;
/*
 *NORMAL,WAITING,DIFFERENT,ERROR,LATE
 */
@property(nonatomic) HDRecordStatus recordStatus;
/*
 *单据明细的 url
 */
@property(nonatomic,copy) NSString * docPageUrl;

@property(nonatomic) BOOL isLate;

@end
