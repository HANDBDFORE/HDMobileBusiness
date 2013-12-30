//
//  HDImageProxy.m
//  HDMobileBusiness
//
//  Created by Plato on 11/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDImageLoader.h"

@implementation HDImageLoader

- (void)dealloc
{
    TT_RELEASE_SAFELY(_defaultFilePath);
    TT_RELEASE_SAFELY(_remoteURL);
    TT_RELEASE_SAFELY(_saveFileName);
    TT_RELEASE_SAFELY(_retinaRemoteURL);
    
//    [[[HDApplicationContext shareContext] objectFactoryMap]removeURL:[NSString stringWithFormat:@"tt://image/%@" ,_saveFileName]];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
//        [[[HDApplicationContext shareContext] objectFactoryMap] from:[NSString stringWithFormat:@"tt://image/%@" ,_saveFileName] toObject:self selector:@selector(image)];
    }
    return self;
}


-(UIImage *)image
{
    NSString *imagePath = [NSString stringWithFormat:@"documents://%@",_saveFileName];
    UIImage * image = TTIMAGE(imagePath);
    if (image) {
        return image;
    }else{
            if (_remoteURL && _saveFileName) {
                [_resourceLoader loadResource:
                 @{kResourceName : _saveFileName,kResourceURL:_remoteURL}];
            }
            if (_retinaRemoteURL && _saveFileName) {
                NSString * Ext=[[_saveFileName pathExtension] lowercaseString];
                NSString * fileName=[_saveFileName substringToIndex:([_saveFileName length]-[Ext length]-1)];
                NSString * retinaSaveFileName = [NSString stringWithFormat:@"%@@2x.%@",fileName,Ext];
                [_resourceLoader loadResource:
                 @{kResourceName : retinaSaveFileName,kResourceURL:_retinaRemoteURL}];
            }
        if(_defaultFilePath) {
            return  TTIMAGE(_defaultFilePath);
        }
    }
    TTDPRINT(@"没有配置正确的默认图片路径");
    return nil;
}
@end
