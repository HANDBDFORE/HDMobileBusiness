//
//  HDTableImageSectionDataSource.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListDataSource.h"
#import "HDTableConfirmViewCell.h"

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
        map.requestPath = self.queryURL;
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
    TT_RELEASE_SAFELY(_itemDictionary);
    [super dealloc];
}

-(id)init
{
    if (self= [super init]) {
        HDFunctionListModel * model = [[[HDFunctionListModel alloc]init] autorelease];
        self.model = model;
        self.listModel = model;
        self.itemDictionary =
        @{ @"typeField" : @"${function_type}",
        @"sectionFlag" : @"SECTION",
        @"sectionText" : @"${text}",
        @"text":@"${text}",
        @"URL" : [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"],@"${url}"],
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
        NSString * recordType = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"typeField"] query:record];
        
        if ([recordType isEqualToString:[self.itemDictionary valueForKey:@"sectionFlag"]]) {
            NSString * sectionText = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"sectionText"] query:record];
            [sections addObject:sectionText];
            section = [NSMutableArray array];
            [items addObject:section];
        } else {
            NSString * text = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"text"] query:record];
            
            NSString * imageURL = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"imageURL"] query:record];
            
            NSString * URL = [self createCellItemWithTemplete:[self.itemDictionary valueForKey:@"URL"] query:record];
            
            TTTableImageItem * imageItem =
            [TTTableImageItem itemWithText:text
                                  imageURL:imageURL
                                       URL:URL];
            imageItem.imageStyle =TTSTYLE(functionListCellImageStyle);

            [section addObject:imageItem];
        }
    }
    
    self.items = items;
    self.sections = sections;
    [self addBasicItems];
    [self addLogoutItem];
}

-(NSString *)createCellItemWithTemplete:(NSString *) templete
                                  query:(NSDictionary *)query
{
    NSEnumerator * e = [query keyEnumerator];
    for (NSString * key; (key = [e nextObject]);) {
        NSString * replaceString = [NSString stringWithFormat:@"${%@}",key];
        NSString * valueString = [NSString stringWithFormat:@"%@",[query valueForKey:key]];
        
        templete = [templete stringByReplacingOccurrencesOfString:replaceString withString:valueString];
    }
    return templete;
}

-(void)addBasicItems{
    TTTableImageItem * todoListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Todo List", @"待办事项")
                          imageURL:@"bundle://mailclosed.png"
                               URL:@"guide://createViewControler/TODO_LIST_VC_PATH"];
    todoListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    
   TTTableImageItem * doneListItem =
    [TTTableImageItem itemWithText:TTLocalizedString(@"Approved List", @"审批完成")
                          imageURL:@"bundle://mailopened.png"
                               URL:@"guide://createViewControler/DONE_LIST_VC_PATH"];
    doneListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    
    [self.sections insertObject:[TTTableSection sectionWithHeaderTitle:TTLocalizedString(@"Approve", @"审批") footerTitle:nil] atIndex:0];
    [self.items insertObject:@[todoListItem,doneListItem] atIndex:0];
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
    [[TTNavigator navigator]openURLAction:[TTURLAction actionWithURLPath:@"init://LoadingViewController"]];
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
}


@end
