//
//  HDBaseConfigNode.m
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseConfigObject.h"

@implementation HDBaseConfigObject
{
    NSMutableArray * _children;
}

@synthesize propertyKey = _propertyKey;
@synthesize propertyValue = _propertyValue;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_children);
    TT_RELEASE_SAFELY(_propertyKey);
    TT_RELEASE_SAFELY(_propertyValue);
    [super dealloc];
}

-(id)initWithKey:(NSString *) key value:(id)value
{
    self = [self init];
    if (self) {
        self.propertyKey = key;
        self.propertyValue = value;
    }
    return self;
}

+(id<HDConfig>)configWithKey:(NSString *) key value:(id)value
{
    return [[[self alloc]initWithKey:key value:value]autorelease];
}

-(NSDictionary *)createPropertyDictionary
{
    if (self.propertyKey && self.propertyValue) {
        return @{self.propertyKey : self.propertyValue};
    }
    if (_children.count) {
        return [self configPropertyDictionaryWithChildren:_children];
    }
    return nil;
}

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children;
{
    return nil;
}

-(void)addSubConfig:(id<HDConfig>)configObject
{
    if (!_children) {
        _children = [[NSMutableArray alloc]init];
    }
    if (configObject) {
        [_children addObject:configObject];
    }
}

-(NSString *)description
{
    NSMutableString * str = [NSMutableString stringWithFormat:@"class:%@ \n key:%@ \n value:%@ \n",NSStringFromClass([self class]),self.propertyKey,self.propertyValue];
    for (id <HDConfig> child in _children) {
        [str appendFormat:@"child: %@ \n ",[child description]];
    }
    return str;
}
@end
