//
//  HDParserProtocal.h
//  HDMobileBusiness
//
//  Created by Emerson Zhang on 13-5-23.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDParserProtocal <NSObject,NSXMLParserDelegate>

@property (retain, nonatomic) NSMutableDictionary *patternes;
@property (retain, nonatomic) NSError *parseError;

@required
//指定xml文件路径，生成对象
-(id)initWithXmlPath:(NSString *)xmlpath;


//解析
-(BOOL)parse;


@end

