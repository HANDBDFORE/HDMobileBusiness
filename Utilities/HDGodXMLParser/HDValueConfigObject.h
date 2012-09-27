//
//  HDValueConfigObject.h
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDConfig.h"

@interface HDValueConfigObject : NSObject <HDConfig>

@property(nonatomic,retain) id propertyValue;

+(id<HDConfig>)configWithKey:(NSString *) key value:(id) value;

@end
