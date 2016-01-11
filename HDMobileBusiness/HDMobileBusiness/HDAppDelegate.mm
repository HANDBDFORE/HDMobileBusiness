//
//  HDAppDelegate.m
//  HDMobileBusiness
//
//  Created by Plato on 7/30/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDAppDelegate.h"

//styleSheet
#import "HDDefaultStyleSheet.h"

#import "HDLoadingViewController.h"
@implementation HDAppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    //register notification
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }  else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes]
        ;
    }
    
    NSString * Version2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"Version2"];

    
     ////版本2的第一次进入
    if(Version2 == nil){
        //初次更新完后,删除之前的表
        
        [[HDCoreStorage shareStorage] excute:@selector(SQLDrop:) recordList:nil];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Version2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    
    //Views Managment by Three20
    [TTStyleSheet setGlobalStyleSheet:[[[HDDefaultStyleSheet alloc]init]autorelease]];
    //create database
    [[HDCoreStorage shareStorage]excute:@selector(SQLCreatTable:) recordList:nil];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    
    self.window.rootViewController = [[[HDLoadingViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    //    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"appVersion"] isEqualToString:kVersion]) {
    //    [self showLoadingView];
    //    }else {
    //        [[NSUserDefaults standardUserDefaults]setValue:kVersion forKey:@"appVersion"];
    //        [self showHelpView];
    //    }
    
    [self.window makeKeyAndVisible];
}

-(void)showHelpView
{
    HDViewGuider * guider = [[HDApplicationContext shareObject] objectForIdentifier:@"firstRootGuider"];
    [guider perform];
}

-(void)showLoadingView
{
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"rootGuider"];
    [guider perform];
}

//获取token成功,格式化token,放入用户设置中
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //get the deivcetoken
    TTDPRINT(@"My token is: %@", deviceToken);
    
    //format token
    NSString *tokenWithBlank = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *tokenWithoutBlank = [tokenWithBlank stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //save deviceToken to userDefaults
    [[NSUserDefaults standardUserDefaults] setValue:tokenWithoutBlank forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setValue:tokenWithoutBlank forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    TTDPRINT(@"Error in registration.Error: %@" ,error.localizedDescription);
    [[NSUserDefaults standardUserDefaults] setValue:@"null" forKey:@"deviceToken"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

@end
