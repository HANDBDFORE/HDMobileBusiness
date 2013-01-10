//
//  HDBaseService.m
//  HDMobileBusiness
//
//  Created by Plato on 12/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDBaseService.h"

@implementation HDBaseService

- (void)dealloc
{
    TT_RELEASE_SAFELY(_model);
    [super dealloc];
}

-(void)setModel:(id <TTModel,HDURLRequestModel>)model
{
    if (_model != model) {
        [_model.delegates removeObject:self];
        [_model release];
        _model = [model retain];
        [_model.delegates addObject:self];
    }
}

#pragma -mark TTModel protocol
-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    [_model load:cachePolicy more:more];
}

#pragma -mark TTURLRequestModel
-(NSDate *)loadedTime
{
    if ([self.model respondsToSelector:@selector(loadedTime)]) {
        return [self.model loadedTime];
    }
    return nil;
}

-(NSString *)cacheKey
{
    if ([self.model respondsToSelector:@selector(cacheKey)]) {
        return [self.model cacheKey];
    }
    return nil;
}

-(BOOL)hasNoMore
{
    if ([self.model respondsToSelector:@selector(hasNoMore)]) {
        return [self.model hasNoMore];
    }
    return NO;
}

-(void)reset
{
    if ([self.model respondsToSelector:@selector(reset)]) {
        [self.model reset];
    }
}

-(float)downloadProgress
{
    if ([self.model respondsToSelector:@selector(downloadProgress)]) {
        return [self.model downloadProgress];
    }
    return 0.0;
}

#pragma mark TTModelDelegate functions
-(void)modelDidFinishLoad:(id<HDListModelQuery>)model
{
    [self didFinishLoad];
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    [self didFailLoadWithError:error];
}

-(void)modelDidBeginUpdates:(id<TTModel>)model
{
    [self beginUpdates];
}

-(void)modelDidCancelLoad:(id<TTModel>)model
{
    [self didCancelLoad];
}

-(void)modelDidChange:(id<TTModel>)model
{
    [self didChange];
}

-(void)modelDidEndUpdates:(id<TTModel>)model
{
    [self endUpdates];
}

-(void)modelDidStartLoad:(id<TTModel>)model
{
    [self didStartLoad];
}

-(void)model:(id<TTModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didDeleteObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}

-(void)model:(id<TTModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [self.resultList indexOfObject:object];
    [self didInsertObject:object atIndexPath:[NSIndexPath indexPathForRow:index
                                                                inSection:0]];
}

#pragma -mark TTModel protocol
-(BOOL)isLoaded
{
    return [self.model isLoaded];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isLoading
{
    return [self.model isLoading];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isLoadingMore
{
    return [self.model isLoadingMore];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isOutdated
{
    return [self.model isOutdated];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)cancel
{
    [self.model cancel];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)invalidate:(BOOL)erase
{
    [self.model invalidate:erase];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
