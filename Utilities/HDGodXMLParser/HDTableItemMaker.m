//
//  HDTableItemMaker.m
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTableItemMaker.h"

@implementation HDTableItemMaker

@synthesize itemClassName = _itemClassName;
@synthesize title = _title;
@synthesize caption = _caption;
@synthesize text = _text;
@synthesize timestamp = _timestamp;

-(TTTableItem *)itemWithQuery:(NSDictionary *)query
{
    NSString * title = [self createCellItemWithTemplete:_title query:query];
    NSString * caption = [self createCellItemWithTemplete:_caption query:query];
    NSString * text = [self createCellItemWithTemplete:_text query:query];
    //TODO:isLate没有处理
    
    
    
    
    NSString * stautMessage = nil;
//    if (![[query valueForKey:kRecordStatus] isEqualToString:kRecordNormal] &&![[query valueForKey:kRecordStatus] isEqualToString:kRecordWaiting]) {
//        stautMessage = [query valueForKey:kRecordServerMessage];
//    }
    
    
    return [NSClassFromString(_itemClassName) itemWithTitle:title
                                           caption:caption
                                              text:text
                                                  timestamp:[_timestamp date]
                                          selector:@selector(openURLForKey:)
                                          delegate:self
                                           message:stautMessage
                                                      state:[query valueForKey:@""]
                                            isLate:@"Y"];
    
}


-(NSString *)createCellItemWithTemplete:(NSString *) templete
                                  query:(NSDictionary *)query
{
    NSEnumerator * e = [query keyEnumerator];
    for (NSString * key; (key = [e nextObject]);) {
        NSString * replaceString = [NSString stringWithFormat:@"${%@}",key];
        NSString * valueString = [NSString stringWithFormat:@"%@",[query valueForKey:key]];
        
        templete = [templete stringByReplacingOccurrencesOfString:replaceString withString:valueString];
    }
    return templete;
}

@end

@implementation HDDateMaker

-(NSDate *) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate * timestamp = [dateFormatter dateFromString:[self createCellItemWithTemplete:[_cellItemMap valueForKey:@"timestamp"] query:object]];
    //    TT_RELEASE_SAFELY(dateFormatter);
    
}

@end