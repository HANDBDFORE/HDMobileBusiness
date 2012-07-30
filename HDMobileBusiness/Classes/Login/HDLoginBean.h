//
//  HDLoginBean.h
//  hrms
//
//  Created by Rocky Lee on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * HDChineseSimplified = @"ZHS";
static NSString * HDEnglish = @"US";


@interface HDLoginBean : NSObject

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,readonly) NSString *deviceType;
@property (nonatomic,copy) NSString *language;

@end
