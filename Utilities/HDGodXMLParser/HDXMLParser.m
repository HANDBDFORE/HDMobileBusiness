//
//  HDXMLParser.m
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDXMLParser.h"
#import "TouchXML.h"

#import "HDContainerConfigObject.h"
#import "HDNumberConfigObject.h"
#import "HDDictionaryConfigObject.h"
#import "HDArrayConfigObject.h"
#import "HDImageConfigObject.h"

@interface HDXMLParser()
{
    CXMLDocument * _document;
    NSDictionary * _dataTypeDictionary;
}

@end

@implementation HDXMLParser
@synthesize delegate = _delegate;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_configDictionary);
    TT_RELEASE_SAFELY(_dataTypeDictionary);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _dataTypeDictionary =
        @{
        @"NSString" : [HDBaseConfigObject class],
        @"NSNumber" : [HDNumberConfigObject class],
        @"NSArray" : [HDArrayConfigObject class],
        @"NSDictionary" : [HDDictionaryConfigObject class],
        @"UIImage" : [HDImageConfigObject class]
        };
        _configDictionary = [[NSMutableDictionary alloc]init];
        TTDPRINT(@"%@",TTPathForDocumentsResource(@"ios-backend-config.xml"));

        _document = [[HDXMLParser document] retain];
        
        //解析配置文件
        if ([[[_document rootElement] name] isEqualToString:@"backend-config"]) {
            NSError * error = nil;
            NSArray * vcArray = [_document nodesForXPath:@"//viewController" error:&error];
            for (CXMLElement * element in vcArray) {
                [self parserConfigXML:element];
            }
        }
        TT_RELEASE_SAFELY(_document);
    }
    return self;
}

+(CXMLDocument *)document
{
    TTDPRINT(@"%@",TTPathForDocumentsResource(@"ios-backend-config.xml"));
    NSData * data = [NSData dataWithContentsOfFile:TTPathForDocumentsResource(@"ios-backend-config.xml")];
    //        NSData * data = [NSData dataWithContentsOfFile:@"/Users/Leo/Projects/xcode/Hand/HDMobileBusiness/HDMobileBusiness/Documents/ConfigFiles/backend-config-hr-sprite-pad.xml"];
    
    NSError * error = nil;
    
    return [[[CXMLDocument alloc]initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error] autorelease];
}

//
+(BOOL)hasParsedSuccess
{
    return !![[HDXMLParser document] nodeForXPath:@"//backend-config" error:nil];
}


-(BOOL)parserForXmlPath:(NSString *)xmlPath
{
    HDObjectPattern * loadingGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"loginViewCtrl"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:loadingGuiderPattern forIdentifier:@"loadingGuider"];
    
    //login guider
    HDObjectPattern * loginGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"navigator"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:loginGuiderPattern forIdentifier:@"loginGuider"];
    
    //functionlistGuider
    HDObjectPattern * functionCellGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/functionListTableGuider"
                     propertyValues:@{@"animated" : @1}
                   propertyRefBeans:@{@"sourceController":@"functionListViewController"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:functionCellGuiderPattern forIdentifier:@"functionListTableGuider"];
    
    //todo list guider
    HDObjectPattern * todolistGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/todolistTableGuider"
                     propertyValues:@{@"animated" : @1}
                   propertyRefBeans:@{@"sourceController":@"todoListViewController",
     @"destinationController":@"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:todolistGuiderPattern forIdentifier:@"todolistTableGuider"];
    
    //todo list post guider
    HDObjectPattern * todoListPostGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://showInViewGuider/todoListPostGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"postController"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:todoListPostGuiderPattern forIdentifier:@"todoListPostGuider"];
    
    //todoDetailListPostGuiderPattern
    HDObjectPattern * todoDetailPostGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://showInViewGuider/todoDetailPostGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"postController"}
                   propertyRefBeans:@{@"sourceController" : @"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:todoDetailPostGuiderPattern forIdentifier:@"todoDetailPostGuider"];
    
    //deliver guider
    HDObjectPattern * todoDetailDeliverGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://modalGuider/todoDetailDeliverGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"deliverNavigator"}
                   propertyRefBeans:@{@"sourceController" : @"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:todoDetailDeliverGuiderPattern forIdentifier:@"todoDetailDeliverGuider"];
    
    //done list guider
    HDObjectPattern * donelistGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/doneListTableGuider"
                     propertyValues:@{@"animated":@1}
                   propertyRefBeans:@{@"sourceController":@"doneListViewController",
     @"destinationController":@"doneDetailController"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:donelistGuiderPattern forIdentifier:@"doneListTableGuider"];
    
    /////////////////////
    //viewControllers
    ///loginVC
    HDObjectPattern * login =
    [HDObjectPattern patternWithURL:@"tt://nib/HDLoginViewController/HDLoginViewController"
                     propertyValues:@{@"titleLabel.text" : @"hand"}
                   propertyRefBeans:@{@"loginModel":@"loginModel",
     @"backgroundImageLoader":@"loginBackImage",
     @"loginButtonNormalImageLoader":@"loginButton",
     @"loginButonHighlightedImageLoader":@"loginHighLightButton"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:login forIdentifier:@"loginViewCtrl"];
    
    //loginM
    HDObjectPattern * loginM = [HDObjectPattern patternWithURL:@"tt://loginModel" propertyValues:@{@"submitURL":@"${base_url}modules/ios/public/login_iphone.svc"} propertyRefBeans:nil objectMode:HDObjectModeCreate];
    [self.delegate setPattern:loginM forIdentifier:@"loginModel"];
    
    //NavigatorVC
    HDObjectPattern * navigatorPattern =
    [HDObjectPattern patternWithURL:@"tt://navigator"
                     propertyValues:@{@"pushedViewControllers" : @[@"functionListViewController",@"todoListViewController"]}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:navigatorPattern forIdentifier:@"navigator"];
    
    ///functionListVC 这个是share的
    HDObjectPattern * functionlistPattern =
    [HDObjectPattern patternWithURL:@"tt://functionListViewController"
                     propertyValues:@{@"title" : @"function"}
                   propertyRefBeans:@{@"dataSource":@"functionDataSource"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:functionlistPattern forIdentifier:@"functionListViewController"];
    
    //function dataSource
    HDObjectPattern * functionDataSource =
    [HDObjectPattern patternWithURL:@"tt://functionDataSource"
                     propertyValues:nil
                   propertyRefBeans:@{@"model":@"functionModel",@"listModel" : @"functionModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:functionDataSource forIdentifier:@"functionDataSource"];
    
    //function model
    HDObjectPattern * functionModel =
    [HDObjectPattern patternWithURL:@"tt://functionModel"
                     propertyValues:@{@"queryURL":@"${base_url}autocrud/ios.ios_function_center.ios_function_center_list/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:functionModel forIdentifier:@"functionModel"];
    
    //todolistVC
    HDObjectPattern * todolistPattern =
    [HDObjectPattern patternWithURL:@"tt://todoListViewController"
                     propertyValues:@{@"title" : @"todo"}
                   propertyRefBeans:@{@"dataSource":@"todoListDataSource",
     @"listModel" : @"todoListModel",
     @"searchViewController":@"todoListSearchViewController"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todolistPattern forIdentifier:@"todoListViewController"];
    
    //todolist dataSource
    HDObjectPattern * todoListDataSource =
    [HDObjectPattern patternWithURL:@"tt://todoListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}",@"isLate":@"${is_late}"}}
                   propertyRefBeans:@{@"listModel" : @"todoListModel",
     @"model" : @"todoListModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todoListDataSource forIdentifier:@"todoListDataSource"];
    
    //todoList model
    HDObjectPattern * todoListModel =
    [HDObjectPattern patternWithURL:@"tt://todoListModel"
                     propertyValues:@{@"primaryField":@"record_id",
     @"searchFields":@[@"order_type",@"node_name",@"employee_name"],
     @"queryURL":@"${base_url}autocrud/ios.ios_test.ios_todo_list_test/query?_fetchall=true&amp;_autocount=false",
     @"submitURL":@"${base_url}modules/ios/ios_test/ios_todo_list_commit.svc"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todoListModel forIdentifier:@"todoListModel"];
    
    //todolistVC search
    HDObjectPattern * todolistSearchPattern =
    [HDObjectPattern patternWithURL:@"tt://todoListSearchViewController"
                     propertyValues:@{@"title" : @"todoSearch"}
                   propertyRefBeans:@{@"dataSource":@"todoListSearchDataSource",
     @"listModel":@"todoListSearchModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todolistSearchPattern forIdentifier:@"todoListSearchViewController"];
    
    //todolist dataSource search
    HDObjectPattern * todoListSearchDataSource =
    [HDObjectPattern patternWithURL:@"tt://todoListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}",@"isLate":@"${is_late}"}}
                   propertyRefBeans:@{@"listModel" : @"todoListSearchModel",
     @"model" : @"todoListSearchModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todoListSearchDataSource forIdentifier:@"todoListSearchDataSource"];
    
    //todoList model search
    [self.delegate setPattern:todoListModel forIdentifier:@"todoListSearchModel"];
    
    //done list view controller
    HDObjectPattern *doneListViewCtrl =
    [HDObjectPattern patternWithURL:@"tt://doneListViewController"
                     propertyValues:@{@"title" : @"done list"}
                   propertyRefBeans:@{@"dataSource" : @"doneListDataSource"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:doneListViewCtrl forIdentifier:@"doneListViewController"];
    
    //done list datasource
    HDObjectPattern *doneListDataSource =
    [HDObjectPattern patternWithURL:@"tt://doneListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}"}}
                   propertyRefBeans:@{@"listModel" : @"doneListModel",
     @"model" : @"doneListModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:doneListDataSource forIdentifier:@"doneListDataSource"];
    
    //done list model
    HDObjectPattern *doneListModel =
    [HDObjectPattern patternWithURL:@"tt://doneListModel"
                     propertyValues:@{@"queryURL" : @"${base_url}autocrud/ios.ios_test.ios_done_list_test/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:doneListModel forIdentifier:@"doneListModel"];
    
    //done detail
    HDObjectPattern * doneDetailViewCtrlPattern =
    [HDObjectPattern patternWithURL:@"tt://doneDetailViewController"
                     propertyValues:@{@"userInfoItemTitle" : @"record_id",
     @"userInfoPageURLTemplate":@"${base_url}modules/mobile/hr_lbr_employee.screen?employee_id=${user_id}",@"webPageURLTemplate":@"${base_url}${screen_name}"}
                   propertyRefBeans:@{@"listModel" : @"doneListModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:doneDetailViewCtrlPattern forIdentifier:@"doneDetailController"];
    
    //todo detail,这个model从不同的todolistVC接收，因为有search的存在，所以不能在这里配置
    HDObjectPattern * todoDetailViewCtrlPattern =
    [HDObjectPattern patternWithURL:@"tt://todoDetailViewController"
                     propertyValues:@{@"userInfoItemTitle" : @"record_id",
     @"queryActionURLTemplate":@"${base_url}autocrud/ios.ios_test.ios_detail_action_query/query?record_id=${record_id}",
     @"userInfoPageURLTemplate":@"${base_url}modules/mobile/hr_lbr_employee.screen?employee_id=${user_id}",
     @"webPageURLTemplate":@"${base_url}${screen_name}"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:todoDetailViewCtrlPattern forIdentifier:@"todoDetailController"];
    
    //post view controller
    HDObjectPattern * postControllerPattern =
    [HDObjectPattern patternWithURL:@"tt://postController"
                     propertyValues:nil
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:postControllerPattern forIdentifier:@"postController"];
    
    //deliver Navigator VC
    HDObjectPattern * deliverNavigatorPattern =
    [HDObjectPattern patternWithURL:@"tt://navigator"
                     propertyValues:@{@"pushedViewControllers" : @[@"deliverController"]}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:deliverNavigatorPattern forIdentifier:@"deliverNavigator"];
    
    //deliver view controller
    HDObjectPattern * deliverControllerPattern =
    [HDObjectPattern patternWithURL:@"tt://deliverController"
                     propertyValues:@{@"title":@"deliver",
     @"personPickerTextField.placeholder":@"451116"}
                   propertyRefBeans:@{@"delegate":@"todoDetailController",
     @"dataSource":@"personListDataSource"}
                         objectMode:HDObjectModeCreate];
    [self.delegate setPattern:deliverControllerPattern forIdentifier:@"deliverController"];
    
    //person list datasource
    HDObjectPattern * personListDataSourcePattern =
    [HDObjectPattern patternWithURL:@"tt://personListDataSource"
                     propertyValues:@{@"itemDictionary" :@{@"text" : @"${name}",
     @"subtitle":@"${position_name}",
     @"userInfo":@"${employee_id}"}}
                   propertyRefBeans:@{@"listModel" : @"personListModel",
     @"model":@"personListModel"}
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:personListDataSourcePattern forIdentifier:@"personListDataSource"];
    
    //person list model
    HDObjectPattern * personListModelPattern =
    [HDObjectPattern patternWithURL:@"tt://personListModel"
                     propertyValues:@{@"queryURL" : @"${base_url}autocrud/ios.ios_deliver.ios_workflow_deliver_query/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self.delegate setPattern:personListModelPattern forIdentifier:@"personListModel"];
    
    //resourceLoader
    HDObjectPattern * resourceLoaderPattern =
    [HDObjectPattern patternWithURL:@"tt://resourceLoader"
                     propertyValues:nil
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
  
    [self.delegate setPattern:resourceLoaderPattern forIdentifier:@"resourceLoader"];
    
    //loginBackgroundImage
    HDObjectPattern * loginBackgroundPattern =
    [HDObjectPattern patternWithURL:@"tt://imageLoader"
                     propertyValues:@{@"defaultFilePath" : @"bundle://login.png",
     @"filePath":@"documents://background.png",
     @"remoteURL":@"${base_url}images/mobile/login.png",
     @"saveFileName":@"background.png",
     @"retinaRemoteURL":@"${base_url}images/mobile/login@2x.png",
     @"retinaSaveFileName":@"background@2x.png"}
                   propertyRefBeans:@{@"resourceLoader" : @"resourceLoader"}
                         objectMode:HDObjectModeCreate];

    [self.delegate setPattern:loginBackgroundPattern forIdentifier:@"loginBackImage"];
    
    //loginBackgroundImage
    HDObjectPattern * loginButtonPattern =
    [HDObjectPattern patternWithURL:@"tt://imageLoader"
                     propertyValues:@{@"defaultFilePath" : @"bundle://loginButton.png",
     @"filePath":@"documents://normalButton.png",
     @"remoteURL":@"${base_url}images/mobile/loginButton.png",
     @"saveFileName":@"normalButton.png",
     @"retinaRemoteURL":@"${base_url}images/mobile/loginButton.png",
     @"retinaSaveFileName":@"normalButton@2x.png"}
                   propertyRefBeans:@{@"resourceLoader" : @"resourceLoader"}
                         objectMode:HDObjectModeCreate];
    
    [self.delegate setPattern:loginButtonPattern forIdentifier:@"loginButton"];
    
    //loginBackgroundImage
    HDObjectPattern * loginHighLightButtonPattern =
    [HDObjectPattern patternWithURL:@"tt://imageLoader"
                     propertyValues:@{@"defaultFilePath" : @"bundle://loginButtonActive.png",
     @"filePath":@"documents://highlightedButton.png",
     @"remoteURL":@"${base_url}images/mobile/loginButtonActive.png",
     @"saveFileName":@"highlightedButton.png",
     @"retinaRemoteURL":@"${base_url}images/mobile/loginButtonActive.png",
     @"retinaSaveFileName":@"highlightedButton@2x.png"}
                   propertyRefBeans:@{@"resourceLoader" : @"resourceLoader"}
                         objectMode:HDObjectModeCreate];
    
    [self.delegate setPattern:loginHighLightButtonPattern forIdentifier:@"loginHighLightButton"];
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSDictionary *) configDictionary
{
    return _configDictionary;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//创建配置 PropertyDictionary
+(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *)keyPath
{
    return [[HDXMLParser shareObject] createPropertyDictionaryForKeyPath:keyPath];
}

-(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *)keyPath
{
    return [[_configDictionary valueForKey:keyPath] createPropertyDictionary];
}

//解析配置文件，生成配置对象放到配置映射记录
-(id <HDConfig>)parserConfigXML:(CXMLElement *) viewControllerElement
{
    //从缓存获取
    NSString * shareTo = [[viewControllerElement attributeForName:@"shareTo"] stringValue];
    NSString * keyPath = [[viewControllerElement attributeForName:@"keyPath"] stringValue];
    TTDASSERT(keyPath);
    id <HDConfig> sharedConfig = nil;
    
    sharedConfig = [_configDictionary valueForKey:keyPath];
    if (nil != sharedConfig) {
        return sharedConfig;
    }
    
    //如果没有设置共享，创建一个配置
    if (!shareTo) {
        sharedConfig = [self createConfigs:viewControllerElement];
        [_configDictionary setValue:sharedConfig forKey:keyPath];
        return sharedConfig;
    }
    
    //如果有设置共享，获取共享链接的配置
    NSString * searchPath = [NSString stringWithFormat:@"//viewController[@keyPath='%@']",shareTo];
    sharedConfig = [self parserConfigXML:(CXMLElement *)[_document nodeForXPath:searchPath error:nil]];
    [_configDictionary setValue:sharedConfig forKey:keyPath];
    
    return sharedConfig;
}

-(id<HDConfig>)createConfigs:(CXMLElement *) element
{
    //根据数据类型创建配置对象，如果没有数据类型，创建容器对象
    Class class = [_dataTypeDictionary valueForKey:[[element attributeForName:@"dataType"] stringValue]];
    if (!class) {
        class = [HDContainerConfigObject class];
    }
    
    HDBaseConfigObject * configObject = [[[class alloc]init]autorelease];
    [configObject setPropertyKey:[element name]];
    [configObject setPropertyValue:[[element attributeForName:@"value"] stringValue]];
    
    //设置子节点，容器，数组，字典,之后如果有复杂类型对象，在添加子类
    for (CXMLNode * childNode in [element children]) {
        if ([childNode isKindOfClass:[CXMLElement class]]) {
            [configObject addSubConfig:[self createConfigs:(CXMLElement *)childNode]];
        }
    }

    //viewControoler节点设置key为nil，容器对象会对每一个子节点的字典key添加自己的key
    if ([[element name] isEqualToString:@"viewController"]) {
        [configObject setPropertyKey:nil];
    }
    return configObject;
}

@end
