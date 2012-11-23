//
//  HDImageProxy.h
//  HDMobileBusiness
//
//  Created by Plato on 11/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDResourceLoader.h"

@protocol HDImageLoader <NSObject>

@property(nonatomic,readonly) UIImage * image;

@end

@interface HDImageLoader : NSObject <HDImageLoader>

@property(nonatomic,readonly) UIImage * image;

@property(nonatomic,copy) NSString * defaultFilePath;

@property(nonatomic,copy) NSString * filePath;

@property(nonatomic,copy) NSString * remoteURL;

@property(nonatomic,copy) NSString * saveFileName;

@property(nonatomic,copy) NSString * retinaRemoteURL;

@property(nonatomic,copy) NSString * retinaSaveFileName;

@property(nonatomic,assign) id<HDResourceLoader> resourceLoader;

@end
