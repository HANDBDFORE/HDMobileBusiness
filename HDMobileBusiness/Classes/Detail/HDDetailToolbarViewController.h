//
//  HDDetaiViewController.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDDetailInfoViewController.h"
#import "HDActionModel.h"
#import "SignViewUlan.h"
@interface HDDetailToolbarViewController : HDDetailInfoViewController <TTMessageControllerDelegate,TTPostControllerDelegate,SignViewUlanDelegate>

@property(nonatomic,readonly) UIBarButtonItem * spaceItem;

@property(nonatomic,retain) HDActionModel * actionModel;



@property(nonatomic)BOOL ca_verification_necessity;


//因为某些原因无法审批
@property(nonatomic)BOOL cannot_approve;


-(void)postDeliverController:(NSString *)comment
                 delivereeid:(NSString *)delivereeid;
@end
