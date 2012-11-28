//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by MHJ on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//
@interface HDXMLParser : NSObject<NSXMLParserDelegate>
//解析成功
@property (retain, nonatomic) NSDictionary *Patternes;
@property (retain, nonatomic) NSError *parseError;
@end
