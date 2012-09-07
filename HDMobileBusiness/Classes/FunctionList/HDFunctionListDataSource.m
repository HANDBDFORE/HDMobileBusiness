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
        [_loadedTime release];
        _loadedTime = [[NSDate dateWithTimeIntervalSinceNow:0] retain];
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
@synthesize functionListModel = _functionListModel;
@synthesize cellItemMap = _cellItemMap;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_cellItemMap);
    TT_RELEASE_SAFELY(_functionListModel)
    [super dealloc];
}

-(id)init
{
    if (self= [super init]) {
        _functionListModel = [[HDFunctionListModel alloc]init];
        self.model = _functionListModel;
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{    
    NSMutableArray* itemsArray = [NSMutableArray array];
    NSMutableArray* sectionArray = [NSMutableArray array];
    
    for (id section in _functionListModel.resultList) {
        [sectionArray addObject:[TTTableSection sectionWithHeaderTitle:[section valueForKeyPath:@"head_title"] footerTitle:nil]];
        NSMutableArray* itemArray =[NSMutableArray array];
        for (id item in [section valueForKeyPath:@"record"]) {
            NSString *prefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"];
            NSString *endfix = [item valueForKeyPath:@"url"];
            NSString *url = [NSString stringWithFormat:@"%@%@",prefix,endfix] ;

            TTTableImageItem * imageItem =
            [TTTableImageItem itemWithText:[item valueForKeyPath:@"text"]
                                  imageURL:[item valueForKeyPath:@"image_url"]
                                       URL:url];
            imageItem.imageStyle =TTSTYLE(functionListCellImageStyle);

            [itemArray addObject: imageItem];                     
        }
        [itemsArray addObject:itemArray];
    }
    
    self.sections = sectionArray;
    self.items = itemsArray;
    
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
    [TTTableImageItem itemWithText:@"待办事项"
                          imageURL:@"bundle://mailclosed.png"
                               URL:@"guide://createViewControler/TODO_LIST_VC_PATH"];
    todoListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    
   TTTableImageItem * doneListItem =
    [TTTableImageItem itemWithText:@"审批完成"
                          imageURL:@"bundle://mailopened.png"
                               URL:@"guide://createViewControler/DONE_LIST_VC_PATH"];
    doneListItem.imageStyle = TTSTYLE(functionListCellImageStyle);
    
    [self.sections insertObject:[TTTableSection sectionWithHeaderTitle:@"审批" footerTitle:nil] atIndex:0];
    [self.items insertObject:@[todoListItem,doneListItem] atIndex:0];
}

-(void)addLogoutItem
{
    NSString * userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    HDTableConfirmViewCell * logoutCell = [[HDTableConfirmViewCell alloc]initWithlableText:userName buttonTitle:@"注销"];
    [logoutCell addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sections addObject:[TTTableSection sectionWithHeaderTitle:@" " footerTitle:nil]];
    [self.items addObject:@[logoutCell]];
}

//TODO:注销，目前先复制原来的退出功能，之后改为退回到登录界面
-(void) logout:(id) sender
{
    TTDPRINT(@"logout");
    [self performAnimationAndClean];

}

-(void)performAnimationAndClean{
    UIWindow * window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    CALayer *animationLayer = window.layer;
    //动画处理
    [UIView animateWithDuration:0.3 animations:^{
        
        animationLayer.affineTransform =CGAffineTransformMakeScale(1, 0.005);
        animationLayer.backgroundColor = [[UIColor whiteColor]CGColor];
    }
                     completion:^(BOOL isFinished){
                         if (isFinished) {
                             [UIView animateWithDuration:0.2 animations:^{
                                 animationLayer.affineTransform = CGAffineTransformScale(animationLayer.affineTransform, 0.001, 1);
                             } completion:^(BOOL isAllFinished){
                                 if (isAllFinished) {
                                     [self clearDatas];
                                     exit(0);
                                 }
                             }];
                         }
                     }];
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
