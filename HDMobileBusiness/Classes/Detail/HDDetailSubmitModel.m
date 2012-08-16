//
//  HDDetailCommitModel.m
//  hrms
//
//  Created by Rocky Lee on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailSubmitModel.h"
#import "ApproveDatabaseHelper.h"

@implementation HDDetailSubmitModel
@synthesize rowID = _rowID;
@synthesize recordID = _recordID;
@synthesize actionID = _actionID;
@synthesize comment = _comment;
@synthesize submitURL = _submitURL;

@synthesize submitData = _submitData;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_rowID);
    TT_RELEASE_SAFELY(_recordID);
    TT_RELEASE_SAFELY(_actionID);
    TT_RELEASE_SAFELY(_comment);
    TT_RELEASE_SAFELY(_submitURL);
    
    TT_RELEASE_SAFELY(_submitData);
    [super dealloc];
}

-(void)submit
{
    [self.submitData setValue:[[HDHTTPRequestCenter sharedURLCenter] requestURLWithKey:kSubmitPath query:nil] forKey:@"submitUrl"];
    [self.submitData setValue:[self.actionID stringValue] forKey:@"action"];
    [self.submitData setValue:self.comment forKey:@"comment"];
    
//    [self configRequest];
//    [self updateApproveRecord];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submitNotification" object:self.submitData];
}

//配置请求
//-(void) configRequest
//{
//    id approveObject =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[self.recordID stringValue],@"record_id", [self.actionID stringValue],@"action_id",self.comment,@"comment",nil],nil];
//    
//    HDRequestConfigMap * map = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestConfigMap];
//    HDRequestConfig * execActionRequestConfig  = [map configForKey:@"detial_ready_post"];
//    [execActionRequestConfig setRequestURL:self.submitURL];
//    [execActionRequestConfig setRequestData:approveObject];
//    [execActionRequestConfig setTag:self.rowID.integerValue];
//}

//修改数据库记录状态 
//-(void) updateApproveRecord
//{
//    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
//    [dbHelper.db open];
//    NSString *sql = [NSString stringWithFormat:@"update approve_list set local_status = '%@',action = '%@' ,submit_url = '%@' ,comment = '%@' where rowid = %@",
//                     @"WAITING",
//                     self.actionID,
//                     self.submitURL,
//                     self.comment,
//                     self.rowID];
//    //    NSLog(@"%@",sql);
//    [dbHelper.db executeUpdate:sql];
//    [dbHelper.db close];
//    TT_RELEASE_SAFELY(dbHelper);
//}
@end
