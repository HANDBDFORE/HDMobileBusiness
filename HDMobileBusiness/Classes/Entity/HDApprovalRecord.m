//
//  HDApprovalRecord.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDApprovalRecord.h"

@implementation HDApprovalRecord
@synthesize serverId = _serverId;
@synthesize comments = _comments;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize timeStamp = _timeStamp;
@synthesize recordTitle = _recordTitle;
@synthesize recordCaption = _recordCaption;
@synthesize recordText = _recordText;
@synthesize recordImagePath = _recordImagePath;
@synthesize exceptionMessage = _exceptionMessage;
@synthesize recordStatus = _recordStatus;
@synthesize docPageUrl = _docPageUrl;
@synthesize isLate = _isLate;

- (void)dealloc
{
    TT_RELEASE_CF_SAFELY(_serverId);
    TT_RELEASE_CF_SAFELY(_comments);
    TT_RELEASE_CF_SAFELY(_userId);
    TT_RELEASE_CF_SAFELY(_userName);
    TT_RELEASE_CF_SAFELY(_timeStamp);
    TT_RELEASE_CF_SAFELY(_recordTitle);
    TT_RELEASE_CF_SAFELY(_recordCaption);
    TT_RELEASE_CF_SAFELY(_recordText);
    TT_RELEASE_CF_SAFELY(_recordImagePath);
    TT_RELEASE_CF_SAFELY(_exceptionMessage);
    TT_RELEASE_CF_SAFELY(_docPageUrl);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.recordStatus = HDRecordStatusNormal;
    }
    return self;
}
@end
