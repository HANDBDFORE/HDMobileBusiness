//
//  HDViewGuider.h
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDViewGuider : NSObject

+(id)guiderWithKeyIdentifier:(NSString *) identifier;

-(id)initWithKeyIdentifier:(NSString *) identifier;


@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, retain) id sourceController;
@property (nonatomic, retain) id destinationController;

@property (nonatomic) BOOL animated;

- (void)perform;

@end
