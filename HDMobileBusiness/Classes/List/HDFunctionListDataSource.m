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

static NSString * kTodoListControllerIdentifier = @"todoListViewController";
static NSString * kDoneListControllerIdentifier = @"doneListViewController";

@implementation HDFunctionListModel

@synthesize resultList = _resultList;
@synthesize queryURL = _queryURL;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.queryURL = nil;
        _resultList = [[NSMutableArray alloc]init];
    }
    return self;
}

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

-(void)requestResultMap:(HDResponseMap *)map
{
    [_resultList removeAllObjects];
    [_resultList addObjectsFromArray:map.result];
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    TTAlert(@"更多功能加载失败");
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDFunctionListDataSource
@synthesize listModel = _listModel;
@synthesize itemDictionary = _itemDictionary;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_listModel);
    TT_RELEASE_SAFELY(_itemDictionary);
    [super dealloc];
}

-(id)init
{
    if (self= [super init]) {
        self.itemDictionary =
        @{ @"typeField" : @"${function_type}",
        @"sectionFlag" : @"SECTION",
        @"sectionText" : @"${text}",
        @"text":@"${text}",
        @"URL" :
//        [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"],
        @"${url}"
//        ]
        ,
        @"imageURL" : @"${image_url}"};
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    NSArray * functionList = [self.listModel resultList];
    
    NSMutableArray* items = [NSMutableArray array];
    NSMutableArray* sections = [NSMutableArray array];
    NSMutableArray* section = nil;
   
    for (NSDictionary * record in functionList) {
        NSString * recordType = [[self.itemDictionary valueForKey:@"typeField"] stringByReplacingSpaceHodlerWithDictionary:record];
        
        if ([recordType isEqualToString:[self.itemDictionary valueForKey:@"sectionFlag"]]) {
            NSString * sectionText = [[self.itemDictionary valueForKey:@"sectionText"] stringByReplacingSpaceHodlerWithDictionary:record];
            [sections addObject:sectionText];
            section = [NSMutableArray array];
            [items addObject:section];
        } else {
            NSString * text = [[self.itemDictionary valueForKey:@"text"] stringByReplacingSpaceHodlerWithDictionary:record];
            
            NSString * imageURL = [[self.itemDictionary valueForKey:@"imageURL"] stringByReplacingSpaceHodlerWithDictionary:record];
            
            NSString * URL = [[[self.itemDictionary valueForKey:@"URL"] stringByReplacingSpaceHodlerWithDictionary:record] stringByReplacingSpaceHodlerWithDictionary:@{@"base_url":[[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"]}];
            
            
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

-(void)addBasicItems{
    TTTableImageItem * todoListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Todo List", @"待办事项")
                          delegate:self
                          selector:@selector(openURLForItem:)];
    todoListItem.imageURL = @"bundle://mailclosed.png";
    todoListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    todoListItem.userInfo = kTodoListControllerIdentifier;
    
//    ///////////////////////////
   TTTableImageItem * doneListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Approved List", @"审批完成")
                          delegate:self
                          selector:@selector(openURLForItem:)];
    doneListItem.imageURL = @"bundle://mailopened.png";
    doneListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    doneListItem.userInfo = kDoneListControllerIdentifier;
    
    ///////////////////////////////
    [self.sections insertObject:[TTTableSection sectionWithHeaderTitle:TTLocalizedString(@"Approve", @"审批") footerTitle:nil] atIndex:0];
    [self.items insertObject:@[todoListItem,doneListItem] atIndex:0];
}

-(void)openURLForItem:(TTTableItem *) item
{
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"functionListTableGuider"];
    [guider setDestinationController:item.userInfo];
    [guider perform];
}

-(void)addLogoutItem
{
    NSString * userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    HDTableConfirmViewCell * logoutCell = [[[HDTableConfirmViewCell alloc]initWithlableText:userName buttonTitle:TTLocalizedString(@"Logout", @"注销")] autorelease];
    [logoutCell addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sections addObject:[TTTableSection sectionWithHeaderTitle:@" " footerTitle:nil]];
    [self.items addObject:@[logoutCell]];
}

-(void) logout:(id) sender
{
    [self clearDatas];

    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"rootGuider"];
    [guider perform];
}

-(void)clearDatas{
    //删除保存账户名密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"password"];
    [defaults synchronize];
    
    //删除本地数据库
    [[HDCoreStorage shareStorage] excute:@selector(SQLCleanTable:) recordList:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[HDApplicationContext shareContext] clearObjects];
}


@end
