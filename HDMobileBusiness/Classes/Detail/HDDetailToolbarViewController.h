//
//  HDDetaiViewController.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDDetailToolbarModel.h"
#import "HDDetailInfoViewController.h"

@interface HDDetailToolbarViewController : HDDetailInfoViewController <TTMessageControllerDelegate,TTPostControllerDelegate>
{
    HDDetailToolbarModel * _toolBarModel;
    UIBarButtonItem * _spaceItem;
}

@property(nonatomic,copy) NSString * queryActionURLTemplate;

@property (nonatomic,retain) id<HDTodoListService,HDPageTurning> listModel;

@end
