//
//  HDApplicationContext.h
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDSingletonObject.h"

//附加到guider里面
@interface HDApplicationContext : HDSingletonObject
{
    NSMutableDictionary * _objectPatterns;
    TTURLMap * _objectFactoryMap;
    NSMutableDictionary * _objectMappings;
}

+(BOOL)configApplicationContextForXmlPath:(NSString *) xmlPath;

+(HDApplicationContext *)shareContext;

-(id)objectForIdentifier:(NSString *)identifier;


@end
