//
//  HDTextFieldDelegate.h
//  HDMobileBusiness
//
//  Created by Plato on 10/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDTextFieldDelegate : NSObject<UITextFieldDelegate>
{
    id _target;
    SEL _selector;
}

-(id)initWithTarget:(id) target selector:(SEL) selector;

@end
