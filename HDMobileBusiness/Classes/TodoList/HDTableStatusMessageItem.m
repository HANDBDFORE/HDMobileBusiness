//
//  HDTableStatusMessageItem.m
//  hrms
//
//  Created by Rocky Lee on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTableStatusMessageItem.h"

@implementation HDTableStatusMessageItem
@synthesize message = _message;
@synthesize state = _state;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    TT_RELEASE_SAFELY(_message);
    TT_RELEASE_SAFELY(_state);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
           selector:(SEL) selector
           delegate:(id)delegate
            message:(NSString *)message 
              state:(NSString *) state
{
    HDTableStatusMessageItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.selector = selector;
    item.delegate = delegate;
    item.message = message;
    item.state = state;
    return item;
}

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                URL:(NSString*)URL
            message:(NSString *)message 
              state:(NSString *) state
{
    HDTableStatusMessageItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.URL = URL;
    item.message = message;
    item.state = state;
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
           imageURL:(NSString*)imageURL 
                URL:(NSString*)URL 
            message:(NSString*)message 
              state:(NSString*) state
{
    HDTableStatusMessageItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.imageURL = imageURL;
    item.URL = URL;
    item.message = message;
    item.state = state;
    return item;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding
///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithCoder:(NSCoder*)decoder {
	self = [super initWithCoder:decoder];
    if (self) {
        self.message = [decoder decodeObjectForKey:@"message"];
        self.state = [decoder decodeObjectForKey:@"state"];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (self.message) {
        [encoder encodeObject:self.message forKey:@"message"];
    }
    if (self.state) {
        [encoder encodeObject:self.state forKey:@"state"];
    }
}

@end
