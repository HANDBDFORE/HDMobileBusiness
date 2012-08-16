//
//  HDTableImageSectionDataSource.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListDataSource.h"
#import "HDGodXMLFactory.h"

static NSString * kFunctinoListQueryPath = @"MORE_FUNCTIONS_QUERY";

@implementation HDFunctionListModel

@synthesize resultList = _resultList;

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (!![[HDHTTPRequestCenter sharedURLCenter] requestURLWithKey:kFunctinoListQueryPath query:nil]) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlName = kFunctinoListQueryPath;
        
        [super requestWithMap:map];
    }else {
        [_loadedTime release];
        _loadedTime = [[NSDate dateWithTimeIntervalSinceNow:0] retain];
        self.cacheKey = @"read hardcode items";
        [self didFinishLoad];
    }        
}

-(void)requestResultMap:(HDResponseMap *)map
{
    self.resultList = map.result;
}
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDFunctionListDataSource

-(id)init
{
    if (self= [super init]) {
        self.model = [[[HDFunctionListModel alloc]init]autorelease];
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    HDFunctionListModel * tableImageModel = (HDFunctionListModel *)self.model;
    
    NSMutableArray* itemsArray = [NSMutableArray array];
    NSMutableArray* sectionArray = [NSMutableArray array];
    
    for (id section in tableImageModel.resultList) {
        [sectionArray addObject:[TTTableSection sectionWithHeaderTitle:[section valueForKeyPath:@"head_title"] footerTitle:nil]];
        NSMutableArray* itemArray =[NSMutableArray array];
        for (id item in [section valueForKeyPath:@"record"]) {
            NSString *prefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"];
            NSString *endfix = [item valueForKeyPath:@"url"];
            NSString *url = [NSString stringWithFormat:@"%@%@",prefix,endfix] ;

            [itemArray addObject: 
             [TTTableImageItem itemWithText:[item valueForKeyPath:@"text"] 
                                   imageURL:[item valueForKeyPath:@"image_url"] 
                                        URL:url]];
        }
        [itemsArray addObject:itemArray];
    }
    
    self.sections = sectionArray;
    self.items = itemsArray;
    
    [self addBasicItems];
    
}

-(void)addBasicItems{
    NSMutableArray *currentItems = [NSMutableArray arrayWithArray:self.items];
    NSMutableArray *currentSections = [NSMutableArray arrayWithArray:self.sections];
    
    NSMutableArray *todoItems = [NSMutableArray array];
    [todoItems addObject:[TTTableImageItem itemWithText:@"待办事项" 
                                               imageURL:@"bundle://mailclosed.png" 
                                                    URL:@"init://todoListViewController"]];
    [todoItems addObject:[TTTableImageItem itemWithText:@"审批完成" 
                                               imageURL:@"bundle://mailopened.png" 
                                                    URL:@"init://doneListViewController"]];
    
    [currentSections insertObject:[TTTableSection sectionWithHeaderTitle:@"审批" footerTitle:nil] atIndex:0];
    [currentItems insertObject:todoItems atIndex:0];
    
    
    NSMutableArray *settingItems = [NSMutableArray array];
    [settingItems addObject:[TTTableImageItem itemWithText:@"设置" 
                                                  imageURL:@"bundle://preferences.png" 
                                                       URL:@"init://shareNib/HDAccountSettingsController/HDAccountSettingsController"]];
    
    [currentSections insertObject:[TTTableSection sectionWithHeaderTitle:@"其他功能" footerTitle:nil] atIndex:currentSections.count];
    [currentItems insertObject:settingItems atIndex:currentItems.count];
    
    self.sections = currentSections;
    self.items = currentItems;
}

@end
