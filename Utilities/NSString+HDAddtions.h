//
//  NSString+HDAddtions.h
//  HDMobileBusiness
//
//  Created by Plato on 9/24/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HDAddtions)

//根据dictionary中的key,替换字符串中 ${key} 形式的占位符
-(NSString *) stringByReplacingSpaceHodlerWithDictionary:(NSDictionary *) dictionary;

@end
