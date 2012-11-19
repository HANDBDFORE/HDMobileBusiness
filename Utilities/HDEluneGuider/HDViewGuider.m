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

- (void)dealloc
{
    TT_RELEASE_SAFELY(_identifier);
    TT_RELEASE_SAFELY(_sourceController);
    TT_RELEASE_SAFELY(_destinationController);
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

@end
