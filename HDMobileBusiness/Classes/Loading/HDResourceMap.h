//
//  SFResourceMap.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDResourceMap : NSObject

//资源名称
@property(nonatomic,copy) NSString * resourceName;

//网络路径
@property(nonatomic,copy) NSString * resourceURL;

//存放地址
//@property(nonatomic,copy) NSString * localPath;

//刷新间隔
//@property(nonatomic) NSTimeInterval refreshDelay;

//最后一次刷新时间
//@property(nonatomic,retain) NSDate * lastUpdateDate;

@end
