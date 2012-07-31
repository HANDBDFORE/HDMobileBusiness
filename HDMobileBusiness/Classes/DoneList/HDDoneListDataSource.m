//
//  ApprovedListDataSource.m
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListDataSource.h"
#import "HDURLCenter.h"
#import "Approve.h"

////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HDDoneListDataSource
@synthesize approvedListModel = _approvedListModel;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_approvedListModel);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _approvedListModel = [[HDDoneListModel alloc]init];
        self.model = _approvedListModel;
        
    }
    return self;
}

-(void)tableViewDidLoadModel:(UITableView *)tableView
{
    self.items = [NSMutableArray array];
    /* yy 如果返回数据不转化为对象,而在这里通过配置文件转换
    for (NSDictionary * record in _approvedListModel.dataList) {
#pragma get the map,mpa应该是外部加载的变量
        HDFiledsMap * fieldMap =  [[HDGodXMLFactory shareBeanFactory] fieldsMappingWithKey:@"HDApprovedListDataSource"];
        
        [self.map createItemWithData:record];
        
#pragma 这里url考虑从guider打开..  可以在map中指定哪些字段是点击cell后需要传递给下一个页面的变量    
        [self.items addObject:
         [TTTableMessageItem  itemWithTitle:fieldMap.title  
                                    caption:fieldMap.caption                                
                                       text:fieldMap.text
                                  timestamp:fieldMap.timestamp
                                        URL:fieldMap.URL]];
    }
     */
    for (Approve * approvedRecord in _approvedListModel.resultList) {
        NSString * textContent = [NSString stringWithFormat:@"%@ %@",
                                  (nil == approvedRecord.statusName)?@"":approvedRecord.statusName,
                                  (nil ==approvedRecord.instanceDesc)?@"":approvedRecord.instanceDesc];
        
       
        
        NSString * url = [NSString stringWithFormat:@"%@/%i",kOpenDidApprovedDetailViewPath,[_approvedListModel.resultList indexOfObject:approvedRecord]];
        
        [self.items addObject:
         [TTTableMessageItem  itemWithTitle:approvedRecord.orderType  
                                    caption:approvedRecord.workflowName                                
                                       text:textContent 
                                  timestamp:nil
                                        URL:url]];
    }
    [self.items addObject:[TTTableMoreButton itemWithText:@"更多..."]];
}

-(UIImage *)imageForError:(NSError *)error
{
    return [UIImage imageNamed:@"network_server.png"];
}
@end
