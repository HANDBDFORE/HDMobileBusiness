//
//  HDViewControllerMap.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuiderMap.h"

@implementation HDGuiderMap

@synthesize urlPath = _urlPath;
@synthesize propertyMap = _propertyMap;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_propertyMap);
    [super dealloc];
}

-(id)propertyForkey:(NSString *)key query:(NSDictionary *) query
{
    id object = [_propertyMap valueForKey:key];
    if ([object conformsToProtocol:@protocol(propertyMap)]) {
        return  [object performSelector:@selector(propertyValueWithQuery:)
                             withObject:query];
    }else{
        return object;
    }
}
@end
