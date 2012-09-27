//
//  HDBaseConfigNode.h
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDConfig.h"

@interface HDBaseConfigObject : NSObject <HDConfig>

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children;

@end
