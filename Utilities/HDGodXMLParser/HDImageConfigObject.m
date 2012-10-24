//
//  HDImageConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 10/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDImageConfigObject.h"
#import "HDResourceLoader.h"

@implementation HDImageConfigObject

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children
{
    NSMutableDictionary * propertyDictionary = [NSMutableDictionary dictionary];
    for (id<HDConfig> childConfig in children) {
        [propertyDictionary addEntriesFromDictionary:[childConfig createPropertyDictionary]];
    }
    
    if ([[propertyDictionary objectForKey:kHDImageURL] isKindOfClass:[NSString class]] && [[propertyDictionary objectForKey:kHDImageName] isKindOfClass:[NSString class]]) {
        [[HDResourceLoader shareLoader] loadResource:
         @{kResourceURL : [propertyDictionary objectForKey:kHDImageURL],
           kResourceName: [propertyDictionary objectForKey:kHDImageName]}];
    }
    
    if ([[propertyDictionary objectForKey:kHDRetinaImageURL] isKindOfClass:[NSString class]] && [[propertyDictionary objectForKey:kHDRetinaImageName] isKindOfClass:[NSString class]]) {
        [[HDResourceLoader shareLoader] loadResource:
         @{kResourceURL : [propertyDictionary objectForKey:kHDRetinaImageURL],
           kResourceName: [propertyDictionary objectForKey:kHDRetinaImageName]}];
    }
    
    if ([[propertyDictionary objectForKey:@"localFileName"] isKindOfClass:[NSString class]]) {
        UIImage * image = TTIMAGE([propertyDictionary objectForKey:@"localFileName"]);
        if (image) {
            return @{self.propertyKey : image};
        }
    }
    return nil;
}

-(id)propertyValue
{
    return TTIMAGE(_propertyValue);
}

@end
