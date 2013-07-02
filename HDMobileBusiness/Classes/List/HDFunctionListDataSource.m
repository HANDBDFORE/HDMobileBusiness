//
//  HDTableImageSectionDataSource.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListDataSource.h"
#import "HDTableConfirmViewCell.h"
#import "HDLoadingViewController.h"

@implementation HDFunctionListModel

@synthesize resultList = _resultList;
@synthesize queryURL = _queryURL;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        self.queryURL = nil;
        _resultList = [[NSMutableArray alloc]init];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (!self.queryURL) {
        self.loadedTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.cacheKey = @"local items";
        [self didFinishLoad];
    }else{
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlPath = self.queryURL;
        [super requestWithMap:map];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)requestResultMap:(HDResponseMap *)map
{
    [_resultList removeAllObjects];
    [_resultList addObjectsFromArray:[[map result] valueForKey:@"list"]];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    TTAlert(@"更多功能加载失败");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDFunctionListDataSource
@synthesize itemDictionary = _itemDictionary;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_itemDictionary);
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    if (self= [super init]) {
        self.itemDictionary =
        @{ @"typeField" : @"${function_type}",
        @"sectionFlag" : @"SECTION",
        @"sectionText" : @"${text}",
        @"text":@"${text}",
        @"URL" :@"${url}",
        @"imageURL" : @"${image_url}"};
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    NSArray * sectionList = [self.model resultList];
    
    NSMutableArray* items = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    NSMutableArray* section = nil;
   
    for (NSDictionary * sectiondata in sectionList) {
        
        NSString * sectionText =  [sectiondata valueForKey:@"title"];
            [sections addObject:sectionText];
            section = [NSMutableArray array];
            [items addObject:section];
        NSArray * items = [sectiondata valueForKey:@"items"];
        for (NSDictionary * item in items) {
            NSString * text = [item valueForKey:@"title"];
            NSString * imageURL = [item valueForKey:@"image_url"];
            NSString * URL = [[item valueForKey:@"url"] stringByReplacingSpaceHodlerWithDictionary:@{@"base_url":[[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"]}];
            
            TTTableImageItem * imageItem =
            [TTTableImageItem itemWithText:text
                                  delegate:self
                                  selector:@selector(openURLForItem:)];
            imageItem.imageURL = imageURL;
            imageItem.imageStyle = TTSTYLE(functionListCellImageStyle);
            imageItem.userInfo = URL;
            [section addObject:imageItem];
        }

    }
    
    self.items = items;
    self.sections = sections;
    [self addBasicItems];
    [self addLogoutItem];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addBasicItems{
    TTTableImageItem * todoListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Todo List", @"待办事项")
                          delegate:self
                          selector:@selector(openURLForItem:)];
    todoListItem.imageURL = @"bundle://mail-5.png";
    todoListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    todoListItem.userInfo = @"functionTodoItemGuider";
    
    /////////////////////////////
   TTTableImageItem * doneListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Approved List", @"审批完成")
                          delegate:self
                          selector:@selector(openURLForItem:)];
    doneListItem.imageURL = @"bundle://mail-14.png";
    doneListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    doneListItem.userInfo = @"functionDoneItemGuider";
    
    ///////////////////////////////
    [self.sections insertObject:[TTTableSection sectionWithHeaderTitle:TTLocalizedString(@"Approve", @"审批") footerTitle:nil] atIndex:0];
    [self.items insertObject:@[todoListItem,doneListItem] atIndex:0];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)openURLForItem:(TTTableItem *) item
{
    HDViewGuider * guider = [self createGuiderWithItem:item];
    [guider perform];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(HDViewGuider *)createGuiderWithItem:(TTTableItem *)item
{
    if ([item.userInfo hasPrefix:@"http://"]) {
        HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"functionWebItemGuider"];
        if (TTIsPad()) {
            [guider.destinationController setValue:item.userInfo forKeyPath:@"webPageURLTemplate"];
        }else{
            guider.destinationController = item.userInfo;
        }
        
        return guider;
    }
    return [[HDApplicationContext shareContext]objectForIdentifier:item.userInfo];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addLogoutItem
{    
    TTTableImageItem * logoutItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Logout", @"注销")
                          delegate:self
                          selector:@selector(logout)];
    
    logoutItem.imageURL = @"bundle://logout256.png";
    logoutItem.imageStyle = TTSTYLE(functionListCellImageStyle);

    [self.sections addObject:[TTTableSection sectionWithHeaderTitle:@" " footerTitle:nil]];
    [self.items addObject:@[logoutItem]];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) logout
{
    UIAlertView* cancelAlertView =
    [[[UIAlertView alloc] initWithTitle:TTLocalizedString(@"Logout", @"注销")
                                message:TTLocalizedString(@"Are you sure you want to logout?", @"注销")
                               delegate:self
                      cancelButtonTitle:TTLocalizedString(@"Yes", @"是")
                      otherButtonTitles:TTLocalizedString(@"No", @"否"), nil] autorelease];
    [cancelAlertView show];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)clearDatas{
    //删除保存账户名密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"Token"];
    [defaults synchronize];
    
    //删除本地数据库
    [[HDCoreStorage shareStorage] excute:@selector(SQLCleanTable:) recordList:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[HDApplicationContext shareContext] clearObjects];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIAlertViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self clearDatas];
        HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"rootGuider"];
        [guider perform];
    }
}

@end
