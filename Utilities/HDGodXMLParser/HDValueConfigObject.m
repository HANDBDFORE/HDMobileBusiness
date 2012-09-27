//
//  HDValueConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDValueConfigObject.h"

@implementation HDValueConfigObject
@synthesize key = _key;
@synthesize propertyValue = _propertyValue;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_key);
    TT_RELEASE_SAFELY(_propertyValue);
    [super dealloc];
}

-(id)initWithKey:(NSString *) key value:(id)value
{
    self = [self init];
    if (self) {
        self.key = key;
        self.propertyValue = value;
    }
    return self;
}

+(id<HDConfig>)configWithKey:(NSString *)key value:(id)value
{
    return [[[HDValueConfigObject alloc]initWithKey:key value:value] autorelease];
}

-(NSDictionary *)createPropertyDictionary
{
    if (_propertyValue) {
        return @{self.key : _propertyValue};
    }
    return nil;
}

-(void)addPropertyConfig:(id<HDConfig>)configObject
{
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"base:%@ \n %@",self.key,self.propertyValue];
}
@end
