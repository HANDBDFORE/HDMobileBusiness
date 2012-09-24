//
//  HDRequestDelegateMap.h
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//request config map
@interface HDRequestMap: NSObject

@property (nonatomic,copy) NSString * urlPath;

//post data,filter will parser it and convert it into really post data.
@property (nonatomic,retain) id postData;

//the delegate list
@property (nonatomic,readonly) NSMutableArray *delegates;

@property (nonatomic,copy) NSString *httpMethod;

@property (nonatomic,assign) BOOL multiPartForm;

@property (nonatomic) TTURLRequestCachePolicy cachePolicy;

/**
 * An object that handles the response data and may parse and validate it.
 *
 * @see TTURLDataResponse
 * @see TTURLImageResponse
 * @see TTURLXMLResponse
 */
@property (nonatomic, retain) id<TTURLResponse> response;

@property (nonatomic, readonly) NSMutableDictionary * userInfo;

+(id)map;

+(id)mapWithDelegate:(id) delegate;

@end
