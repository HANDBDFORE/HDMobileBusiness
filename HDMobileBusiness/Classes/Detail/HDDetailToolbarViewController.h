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

@interface HDDetailToolbarViewController : HDDetailInfoViewController <TTPostControllerDelegate>
{
    HDDetailToolbarModel * _toolBarModel;
}

-(id)initWithSignature:(NSString *) signature
                 query:(NSDictionary *) query;

@property(nonatomic,copy) NSString * queryActionURLTemplate;
@end
