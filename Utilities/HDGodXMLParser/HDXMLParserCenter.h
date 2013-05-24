//
//  HDXMLParserFactory.h
//  HDMobileBusiness
//
//  Created by Emerson Zhang on 13-5-24.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDParserProtocal.h"
#import "HDOriginalXMLParser.h"
#import "HDSpringLikeXMLParser.h"
#import "HDSingletonObject.h"


@interface HDXMLParserCenter : HDSingletonObject<NSXMLParserDelegate>

+(NSDictionary*)getParsedPattensWithXMLPath:(NSString*)path;


@end
