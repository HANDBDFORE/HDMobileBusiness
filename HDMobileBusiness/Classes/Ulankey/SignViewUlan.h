//
//  SignViewUlan.h
//  UlanKitDemoForiPhone
//
//  Created by LiChuang on 10/18/13.
//  Copyright (c) 2013 cfca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULANKey.h"
#import "ULANKeyDelegate.h"

#define CERT_TYPE_SM2           @"SM2"
#define CERT_TYPE_RSA1024       @"RSA1024"
#define CERT_TYPE_RSA2048       @"RSA2048"

#define HASH_ALGORITHM_SHA1     @"SHA1"
#define HASH_ALGORITHM_SHA256   @"SHA256"

enum {
    kSignSucess = 0,
    kFetchCertSuccess,
    kCancel,
    kFailure,
    kDisconnected
};

@protocol SignViewUlanDelegate <NSObject>
@optional
-(void) afterDone:(ULANKeyError*)err type:(int)type result:(NSObject *)result;
@end

@interface SignViewUlan : UIViewController

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicator;

@property (strong, nonatomic) ULANKey *ulanKey;
@property (assign, nonatomic) id<SignViewUlanDelegate>  signDelegator;

@property (strong, nonatomic) NSString * certType;
@property (strong, nonatomic) NSString * keyID;
@property (strong, nonatomic) NSString * connectKeyID;


//////////add by jtt 标记位判断是是否来自登陆，如果是登陆，这个不需要进行键盘上堆
@property (nonatomic) BOOL  fromLogin;


- (void)sign:(NSData *)dataToSign
  parentView:(UIView *)parent
parentViewController:(UIViewController *)parentViewController
   delegator:(id<SignViewUlanDelegate>)delegator
    signType:(NSString *)signType
    certType:(NSString *)certType
        hash:(NSString *)hash
       keyID:(NSString *)keyID
 useCachePin:(BOOL)cachepin;

-(void)AutoSign:(NSData *)dataToSign
     parentView:(UIView *)parent
      delegator:(id<SignViewUlanDelegate>)delegator
        pinCode:(NSString *)pinCode
       signType:(NSString *)signType
       certType:(NSString *)certType
           hash:(NSString *)hash
          keyID:(NSString *)keyID;

- (void)setLable:(int)index isHighLight:(BOOL)isHighLight text:(NSString*)text;
- (void)removeSelfView:(double)duration;

-(void)disConnectKey;
@end
