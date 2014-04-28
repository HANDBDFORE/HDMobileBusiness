//
//  HDTableStatusMessageItem.h
//  hrms
//
//  Created by Rocky Lee on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


//static NSString * kTableStatusMessageNormoal  = @"NORMAL";
//static NSString * kTableStatusMessageError  = @"ERROR";
//static NSString * kTableStatusMessageDifferent = @"DIFFERENT";
//static NSString * kTableStatusMessageWaiting =@"WAITING";

@interface HDTableStatusMessageItem : TTTableMessageItem
{
    NSString * _message;
    NSString * _state;
    NSString * _warning;
}

@property (nonatomic,retain) NSString * message;
@property (nonatomic,copy) NSString * state;
@property (nonatomic,copy) NSString * warning;

+ (id)itemWithTitle:(NSString*)title
            caption:(NSString*)caption
               text:(NSString*)text
          timestamp:(NSString*)timestamp
           selector:(SEL) selector
           delegate:(id)delegate
            message:(NSString *)message
              state:(NSString *)state
            warning:(NSString *)warning;


+ (id)itemWithTitle:(NSString*)title
            caption:(NSString*)caption
               text:(NSString*)text
          timestamp:(NSString*)timestamp
            message:(NSString *)message
              state:(NSString *)state
            warning:(NSString *)warning;
@end
