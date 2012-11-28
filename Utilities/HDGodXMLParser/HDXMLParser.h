//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by MHJ on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//
@interface HDXMLParser : NSObject<NSXMLParserDelegate>
@property (retain, nonatomic) NSDictionary *patternes;
@property (retain, nonatomic) NSError *parseError;
-(id)initWithXmlPath:(NSString *)xmlpath;
-(BOOL)parse;
@end
