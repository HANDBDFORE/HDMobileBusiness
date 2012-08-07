//
//  HDCoreStorage.h
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDCoreStorage : NSObject

+(id)shareStorage;

-(id)query:(id) conditions;

-(BOOL)insert:(id) data;

-(BOOL)update:(id) data;

-(BOOL)remove:(id) data;

-(void)sync:(id)data;

@end
