//
//  HDToolBarItem.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDToolbarItem.h"

@implementation HDToolbarItem
@synthesize tag = _tag;
@synthesize title = _title;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_title);
    [super dealloc];
}
@end
