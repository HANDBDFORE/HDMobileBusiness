//
//  UserHelpPageController.h
//  hrms
//
//  Created by mas apple on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDUserGuideViewController : TTViewController<TTScrollViewDataSource, TTScrollViewDelegate> {
    
    TTScrollView* _scrollView;
    TTPageControl* _pageControl;
    NSArray* _pages;
}

@end
