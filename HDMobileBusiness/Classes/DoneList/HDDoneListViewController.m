//
//  HDApprovedListViewControllerViewController.m
//  hrms
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListViewController.h"
#import "HDDoneListDataSource.h"
#import "Approve.h"

@implementation HDDoneListViewController

-(void)dealloc
{
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@/(%@:)",kOpenDidApprovedDetailViewPath ,@"openDetailViewForKey",nil]];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"审批完成";
        self.variableHeightRows = YES;
        self.tabBarItem.image = [UIImage imageNamed:@"mailopened.png"];
        
        [[TTNavigator navigator].URLMap 
         from:[NSString stringWithFormat:@"%@/(%@:)",kOpenDidApprovedDetailViewPath ,@"openDetailViewForKey",nil]
         toSharedViewController:self 
         selector:@selector(openDetailViewForKey:)];
    }
    return self;
}

-(UIViewController *)openDetailViewForKey:(NSString *) key
{
    HDDoneListModel * _approvedListModel = (HDDoneListModel *)self.model;
    Approve * _approve = [_approvedListModel.resultList objectAtIndex:[key intValue]];
    
    NSDictionary * dataInfo = [NSDictionary dictionaryWithObject:_approve forKey:@"data"];
    
    UIViewController * viewController = [[TTNavigator navigator]viewControllerForURL:@"init://didApprovedDetail" query:dataInfo];
    //    //get webpage url
    NSDictionary * urlQuery = [_approve dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"docPageUrl",@"instanceId", nil]];
    
    NSString * webPageUrl = [[HDHTTPRequestCenter sharedURLCenter] requestURLWithKey:kTodoListDetailWebPagePath query:urlQuery];
    
    NSString * employeeURLPath = [[HDHTTPRequestCenter sharedURLCenter] requestURLWithKey:kUserInfoWebPagePath query:[NSDictionary dictionaryWithObject:_approve.employeeId forKey:@"employeeID"]];
    
    [viewController setValue:webPageUrl forKeyPath:@"webPageURLPath"];
    
    [viewController setValue:_approve.employeeName forKeyPath:@"employeeName"];
    [viewController setValue:employeeURLPath forKeyPath:@"employeeURLPath"];
    return viewController;
}

-(void)createModel
{
    self.dataSource = [[[HDDoneListDataSource alloc]init] autorelease];
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    [super model:model didFailLoadWithError:error];
    TTAlert([error localizedDescription]);
}

-(id<UITableViewDelegate>)createDelegate
{
  return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}
@end
