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
@synthesize propertyDictionary = _propertyDictionary;
@synthesize shouldConfigWithQuery = _shouldConfigWithQuery;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_propertyDictionary);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _shouldConfigWithQuery = NO;
    }
    return self;
}

//-(id)propertyForkey:(NSString *)key query:(NSDictionary *) query
//{
//    id object = [_propertyMap valueForKey:key];
//    if ([object conformsToProtocol:@protocol(propertyMap)]) {
//        return  [object performSelector:@selector(propertyValueWithQuery:)
//                             withObject:query];
//    }else{
//        return object;
//    }
//}
@end
