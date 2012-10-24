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
    
    if ([[propertyDictionary objectForKey:@"remoteURL"] isKindOfClass:[NSString class]] && [[propertyDictionary objectForKey:@"saveFileName"] isKindOfClass:[NSString class]]) {
        [[HDResourceLoader shareLoader] addResource:propertyDictionary];
        [[HDResourceLoader shareLoader] startLoad];
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
