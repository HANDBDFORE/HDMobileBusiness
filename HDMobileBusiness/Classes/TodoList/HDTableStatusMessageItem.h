//
//  HDTableStatusMessageItem.h
//  hrms
//
//  Created by Rocky Lee on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



static NSString *  kTableStatusMessageNormoal  = @"NORMAL";                       
static NSString *  kTableStatusMessageError  = @"ERROR";
static NSString *  kTableStatusMessageDifferent = @"DIFFERENT";
static NSString * kTableStatusMessageWaiting =@"WAITING";

@interface HDTableStatusMessageItem : TTTableMessageItem
{  
    NSString * _message;
    NSString * _state;
}

@property (nonatomic,retain) NSString * message;
@property (nonatomic,copy) NSString * state;

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
           selector:(SEL) selector
           delegate:(id)delegate
            message:(NSString *)message 
              state:(NSString *) state;

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
                URL:(NSString*)URL
            message:(NSString *)message 
              state:(NSString *) state;

+ (id)itemWithTitle:(NSString*)title 
            caption:(NSString*)caption 
               text:(NSString*)text
          timestamp:(NSDate*)timestamp 
           imageURL:(NSString*)imageURL 
                URL:(NSString*)URL 
            message:(NSString *)message 
              state:(NSString *) state;
@end
