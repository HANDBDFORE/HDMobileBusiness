//
//  HDRequestDelegateMap.h
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//request config map
@interface HDRequestMap: NSObject

@property (nonatomic,copy) NSString * requestPath;

//the key of url .It may be id in the config file
@property (nonatomic,copy) NSString * urlName;

//parameters of url ,replace the key in url
@property (nonatomic,retain) NSDictionary * urlParameters;

//post data,filter will parser it and convert it into really post data.
@property (nonatomic,retain) id postData;

//post bean,if use bean to be the post parameter
//@property (nonatomic,retain) id postBean;

//sign the request,three20 dose not has it.it appears in ASIHTTPRequest
//@property (nonatomic,assign) NSUInteger tag;

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

//-(id)initWithDelegate:(id) delegate;

@end
