//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by MHJ on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//
#import "HDObjectPattern.h"
#import "HDParserProtocal.h"

@interface HDXMLParser : NSObject<HDParserProtocal>

@property (retain, nonatomic) NSMutableDictionary *patternes;
@property (retain, nonatomic) NSError *parseError;

-(id)initWithXmlPath:(NSString *)xmlpath;

-(BOOL)parse;

@end
