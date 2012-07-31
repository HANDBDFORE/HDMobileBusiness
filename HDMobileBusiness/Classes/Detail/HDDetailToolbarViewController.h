//
//  HDDetaiViewController.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HDDetailSubmitModel.h"
#import "HDDetailToolbarModel.h"
#import "HDDetailInfoViewController.h"

static NSString * kApproveDetailWebPagePath = @"APPROVE_DETIAL_WEB_PAGE_PATH";
static NSString * kEmployeeInfoWebPagePath = @"EMPLOYEE_INFO_WEB_URL";

@interface HDDetailToolbarViewController : HDDetailInfoViewController <TTPostControllerDelegate>
{
    @protected
    HDDetailSubmitModel * _submitModel;
    HDDetailToolbarModel * _toolBarModel;
}

@property(nonatomic,copy)NSNumber * employeeID;
@property(nonatomic,retain)NSNumber * rowID;
@property(nonatomic,retain)NSNumber * recordID;
@property(nonatomic,retain)NSNumber * instanceID;

@property(nonatomic,copy)NSString * localStatus;
@property(nonatomic,retain)HDDetailSubmitModel * submitModel;

-(id)initWithSignature:(NSString *) signature 
                 query:(NSDictionary *) query;

@end
