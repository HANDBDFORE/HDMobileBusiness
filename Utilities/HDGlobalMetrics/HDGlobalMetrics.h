//
//  HDGlobalMetrics.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
BOOL HDIsInch4();
/**
 * @return the frame below the navigation bar with device orientation factored in.
 */
CGRect HDNavigationFrame();

/**
 * @return the frame below the navigation bar + status bar with device orientation factored in.
 */
CGRect HDNavigationStatusbarFrame();

/**
 * @return the frame below the navigation bar and above a toolbar with device orientation factored in.
 */
CGRect HDToolbarNavigationFrame();

/**
 * @return the frame below the navigation bar + status bar and above a toolbar with device orientation factored in.
 */
CGRect HDToolbarNavigationStatusbarFrame();
