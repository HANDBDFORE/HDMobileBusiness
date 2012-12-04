//
//  HDViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDViewGuider.h"

@implementation HDViewGuider

@synthesize identifier = _identifier;
@synthesize sourceController = _sourceController;
@synthesize destinationController = _destinationController;
@synthesize animated = _animated;
@synthesize sourceQuery = _sourceQuery;
@synthesize destinationQuery = _destinationQuery;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_identifier);
    TT_RELEASE_SAFELY(_sourceController);
    TT_RELEASE_SAFELY(_destinationController);
    TT_RELEASE_SAFELY(_sourceQuery);
    TT_RELEASE_SAFELY(_destinationQuery);
    [super dealloc];
}

+(id)guiderWithKeyIdentifier:(NSString *)identifier
{
    return [[[self alloc]initWithKeyIdentifier:identifier]autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.animated = NO;
    }
    return self;
}

-(id)initWithKeyIdentifier:(NSString *)identifier
{
    if(self = [self init])
    {
        _identifier = [identifier copy];
    }
    return self;
}

-(void)perform{}

-(id)sourceController
{
    if ([_sourceController isKindOfClass:[NSString class]]) {
        self.sourceController = [[HDApplicationContext shareContext]objectForIdentifier:_sourceController query:self.sourceQuery];
    }
    if (![_sourceController isKindOfClass:[UIViewController class]]&&
        ![_sourceController isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    return _sourceController;
}

-(id)destinationController
{
    if ([_destinationController isKindOfClass:[NSString class]]) {
        self.destinationController = [[HDApplicationContext shareContext]objectForIdentifier:_destinationController query:self.destinationQuery];
    }
    return _destinationController;
}

@end
