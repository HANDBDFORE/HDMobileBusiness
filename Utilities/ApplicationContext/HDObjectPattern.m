//
//  HDBeanFactory.m
//  Three20Lab
//
//  Created by Plato on 11/16/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDObjectPattern.h"

@implementation HDObjectPattern
@synthesize url = _url;
@synthesize values = _values;
@synthesize beans = _beans;
@synthesize objectMode = _objectMode;
- (id)init
{
    self = [super init];
    if (self) {
        _objectMode = HDObjectModeShare;
    }
    return self;
}

- (void)dealloc
{
    [_url release];
    [_values release];
    [_beans release];
    [super dealloc];
}

+(id)patternWithURL:(NSString *)url propertyValues:(NSDictionary *)values propertyRefBeans:(NSDictionary *)beans objectMode:(NSInteger)mode
{
    return [[[self alloc]initWithURL:url propertyValues:values propertyRefBeans:beans objectMode:mode] autorelease];
}

-(id)initWithURL:(NSString *) url propertyValues:(NSDictionary *)values propertyRefBeans:(NSDictionary *)beans objectMode:(NSInteger)mode{
    if (self = [self init]) {
        _url = [url copy];
        _values = [values retain];
        _beans = [beans retain];
        _objectMode = mode;
    }
    return self;
}

-(NSString *)description{
    NSString * str = [NSString stringWithFormat:@"[url:%@$$values:%@$$beans:%@]$$",_url,_values,_beans];
    
    return str;
}

-(id)copyWithZone:(NSZone *)zone
{
    return [[HDObjectPattern alloc] initWithURL:self.url propertyValues:self.values propertyRefBeans:self.beans objectMode:self.objectMode];
}
@end
