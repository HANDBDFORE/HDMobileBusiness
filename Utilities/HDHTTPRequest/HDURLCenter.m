//
//  HDURLCenter.m
//  hrms
//
//  Created by Rocky Lee on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLCenter.h"
#import "TouchXML.h"

@interface HDURLCenter()

@property (nonatomic,copy) NSString *basePath;

@end

@implementation HDURLCenter

@synthesize basePath = _basePath;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_basePath);
    [super dealloc];
}

-(NSString *) requestURLWithKey:(id)key
{
   return [self requestURLWithKey:key query:nil];
}

-(NSString *) requestURLWithKey:(id)key query:(NSDictionary *)query
{
    NSError *error = nil;
    NSString *url = nil;
    NSString *xpath = [NSString stringWithFormat:@"/backend-config/urls/url[@name='%@']",key];
    HDGodXMLFactory *factory = [HDGodXMLFactory shareBeanFactory];
    
    CXMLNode *node = [factory.document nodeForXPath:xpath error:&error];
    
    if ([node isKindOfClass:[CXMLElement class]]) {
        url = [[((CXMLElement *)node) attributeForName:@"value"]stringValue];
    }
    
    //处理query参数替换
    NSEnumerator * e = [query keyEnumerator];
    for (NSString * key; (key = [e nextObject]);) {
        NSString * replaceString = [NSString stringWithFormat:@"[%@]",key];
        NSString * valueString = [NSString stringWithFormat:@"%@",[query valueForKey:key]];
        url = [url stringByReplacingOccurrencesOfString:replaceString withString:valueString];
    }
    
    if (!url) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@%@",[self baseURLPath],url];
}

-(NSString *) baseURLPath
{
    return [self baseURLPathFormatter];
}

/*
 *formater base url even if the url has no prefix 'http://' or suffix '/'
 */
-(NSString *) baseURLPathFormatter
{
    self.basePath = [[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"];
    
    self.basePath = [self.basePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.basePath isEqualToString:@""]) {
        return self.basePath;
    }
    if (![self.basePath hasSuffix:@"/"]) {
        self.basePath = [self.basePath stringByAppendingString:@"/"];
    }
    if (![self.basePath hasPrefix:@"http://"]) {
        self.basePath = [@"http://" stringByAppendingString:self.basePath];
    }
    self.basePath = [self.basePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[NSUserDefaults standardUserDefaults]setValue:self.basePath 
                                            forKey:@"base_url_preference"];
    return self.basePath;
}

@end
