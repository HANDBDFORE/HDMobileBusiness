//
//  HDDeliverViewController.h
//  HDMobileBusiness
//
//  Created by Plato on 9/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "HDMessageSingleRecipientField.h"

@interface HDDeliverViewController : TTMessageController

@property(nonatomic,retain) HDMessageSingleRecipientField * personPickerTextField;

@end
