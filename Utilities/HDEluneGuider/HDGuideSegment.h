//
//  HDGuideSegment.h
//  HDMobileBusiness
//
//  Created by Plato on 11/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDGuideSegment : NSObject

+(id)segmentWithKeyPath:(NSString *) keyPath;

-(id)initWithKeyPath:(NSString *) keyPath;


@property (nonatomic,copy) NSString * keyPath;
@property (nonatomic,retain) id invoker;
@property (nonatomic) BOOL animated;
@property (nonatomic,retain) NSDictionary * query;


@end
