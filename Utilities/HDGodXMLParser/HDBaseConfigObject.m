//
//  HDBaseConfigNode.m
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseConfigObject.h"

@implementation HDBaseConfigObject
@synthesize key = _key;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_children);
    TT_RELEASE_SAFELY(_key);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _children = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithKey:(NSString *) key
{
    self = [self init];
    if (self) {
        self.key = key;
    }
    return self;
}

+(id<HDConfig>)configWithKey:(NSString *) key
{
    return [[[HDBaseConfigObject alloc]initWithKey:key]autorelease];
}

-(NSDictionary *)createPropertyDictionary
{
    if (_children.count == 0) {
        return nil;
    }
    
    NSMutableDictionary * propertyDictionary = [NSMutableDictionary dictionary];
    for (id<HDConfig> configObject in _children) {
        NSDictionary * properties = [configObject createPropertyDictionary];
        if ([self shouldAddKey]) {
            for (NSString * childPropertyKey in [properties allKeys]) {
                id value = [properties valueForKey:childPropertyKey];
                [propertyDictionary setValue:value
                                      forKey:[self.key stringByAppendingFormat:@".%@",childPropertyKey]];
            }
        }else{
            [propertyDictionary setValuesForKeysWithDictionary:properties];
        }
    }
    return propertyDictionary;
}

-(void)addPropertyConfig:(id<HDConfig>)configObject
{
    if (configObject) {
        [_children addObject:configObject];
    }
}

-(BOOL)shouldAddKey
{
    return !!self.key;
}

-(NSString *)description
{
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@ \n ",self.key];
    for (id <HDConfig> child in _children) {
        [str appendFormat:@"base:%@ \n ",[child description]];
    }
    return str;
}
@end
