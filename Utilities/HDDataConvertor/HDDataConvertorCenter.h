//
//  HDFilterCenter.h
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDDataConvertor.h"
#import "HDDataBaseConvertor.h"

typedef enum
{
    HDDataRequestConvertor,
    HDDataResponseConvertor,
}HDDataConvertorType;

@interface HDDataConvertorCenter : NSObject

+(id<HDDataConvertor>)convertorChainWithURLName:(NSString *)urlName 
                                           type:(HDDataConvertorType) type;

@end
