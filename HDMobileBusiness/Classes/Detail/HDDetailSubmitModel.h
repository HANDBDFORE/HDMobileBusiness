//
//  HDDetailCommitModel.h
//  hrms
//
//  Created by Rocky Lee on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * kSubmitPath = @"EXEC_ACTION_UPDATE_PATH";

@interface HDDetailSubmitModel : NSObject

@property(nonatomic,retain) id submitData;

@property(nonatomic,retain) NSNumber * rowID;

@property(nonatomic,retain) NSNumber * recordID;
//动作ID
@property(nonatomic,retain) NSNumber * actionID;
//审批内容
@property(nonatomic,copy) NSString * comment;

@property(nonatomic,copy) NSString * submitURL;

//提交审批
-(void)submit;
@end
