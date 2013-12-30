//
//  HDTableDataSource.h
//  HDMobileBusiness
//
//  Created by Plato on 9/26/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDTableDataSource <NSObject>

//item字典，描述如何从record中获取数据设置到item中
@property(nonatomic,retain) NSDictionary * itemDictionary;

@end
