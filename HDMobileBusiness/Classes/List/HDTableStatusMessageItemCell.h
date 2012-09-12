//
//  HDTableStatusMessageItemCell.h
//  hrms
//
//  Created by Rocky Lee on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTableStatusMessageItem.h"

@interface HDTableStatusMessageItemCell : TTTableMessageItemCell
{
    TTLabel*      _stateLabel;
    TTActivityLabel * _activityLabel;
}

@property(nonatomic,readonly,retain) TTLabel * stateLabel;
@property(nonatomic,readonly,retain) TTActivityLabel * activityLabel;

@end
