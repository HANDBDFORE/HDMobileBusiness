//
//  HDGlobalMetrics.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGlobalMetrics.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect HDNavigationFrame() {
    CGRect frame = TTScreenBounds();
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TTToolbarHeight());
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect HDNavigationStatusbarFrame() {
    CGRect frame = TTScreenBounds();
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TTToolbarHeight()-TTStatusHeight());
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect HDToolbarNavigationFrame() {
    CGRect frame = TTScreenBounds();
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TTToolbarHeight()*2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect HDToolbarNavigationStatusbarFrame() {
    CGRect frame = TTScreenBounds();
    return CGRectMake(0, 0, frame.size.width, frame.size.height - TTToolbarHeight()*2 - TTStatusHeight());
}