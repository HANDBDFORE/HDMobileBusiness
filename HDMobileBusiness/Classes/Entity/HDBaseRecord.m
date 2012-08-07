//
//  HDBaseRecord.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseRecord.h"

@interface HDBaseRecord()

@end

@implementation HDBaseRecord
@synthesize recordId = _recordId;
@synthesize storageStatus = _storageStatus;

- (void)dealloc
{
    TT_RELEASE_CF_SAFELY(_recordId);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.storageStatus = HDStorageStatusNormal;
    }
    return self;
}

@end
