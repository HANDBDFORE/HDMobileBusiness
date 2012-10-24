//
//  HDImageConfigObject.h
//  HDMobileBusiness
//
//  Created by Plato on 10/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseConfigObject.h"

static NSString * kHDImageURL = @"remoteURL";
static NSString * kHDImageName = @"saveFileName";
static NSString * kHDRetinaImageURL = @"retinaRemoteURL";
static NSString * kHDRetinaImageName = @"retinaSaveFileName";

@interface HDImageConfigObject : HDBaseConfigObject

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children;

@end
