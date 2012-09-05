//
//  HDSettingViewController.h
//  HDMobileBusiness
//
//  Created by Plato on 8/31/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface HDSettingsViewController : TTTableViewController
{
    UIBarButtonItem * _saveButton;
    UIBarButtonItem * _cancelButton;
}
@end

@interface HDTableViewLogoutCell : UIControl

-(id)initWithLogoutButtonTarget:(id) target selector:(SEL)selector;

@end
