//
//  SignViewUlanController.m
//  UlanKitDemoForiPhone
//
//  Created by LiChuang on 10/18/13.
//  Copyright (c) 2013 cfca. All rights reserved.
//

#import "SignViewUlan.h"

#define cancelBtFrame_iPhone        CGRectMake(140, 160, 90, 40);
#define cancelBtFrame_Single_iPhone CGRectMake(40, 160, 170, 40);
#define cancelBtFrame_iPad          CGRectMake(234, 284, 124, 50);
#define cancelBtFrame_Single_iPad   CGRectMake(105, 284, 216, 50);

@interface SignViewUlan ()<ULANKeyDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *alertPinField;
@property (strong, nonatomic) IBOutlet UIButton    *commitBt;
@property (strong, nonatomic) IBOutlet UIButton    *cancelBt;
@property (strong, nonatomic) IBOutlet UILabel     *pinHint;
@property (strong, nonatomic) IBOutlet UIView      *midView;

@property (strong, nonatomic) NSData    *dataToSigan;
@property (strong, nonatomic) NSString  *singatureBase64;
@property (strong, nonatomic) NSString  *signType;
@property (strong, nonatomic) NSString  *hashAlgorithm;
@property (assign, nonatomic) UIView    *parentView;
@property (assign,nonatomic) UIViewController * myParentViewController;


@property (assign, nonatomic) BOOL isPad;

@property (assign, nonatomic) BOOL isAutoTest;
@property (strong, nonatomic) NSString *pinCode;

@property (assign,nonatomic) BOOL useCachePin;



-(IBAction)onPinCommit:(id)sender;
-(IBAction)onCancel:(id)sender;

@end

@implementation SignViewUlan

NSString* TTLocalizedString(NSString* key, NSString* comment) {
    static NSBundle* bundle = nil;
    if (nil == bundle) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"Three20.bundle"];
        bundle = [[NSBundle bundleWithPath:path] retain];
    }
    
    return [bundle localizedStringForKey:key value:key table:nil];
}

-(void)dealloc{
    TT_RELEASE_SAFELY(_alertPinField);
    TT_RELEASE_SAFELY(_commitBt);
    TT_RELEASE_SAFELY(_cancelBt);
    TT_RELEASE_SAFELY(_pinHint);
    TT_RELEASE_SAFELY(_midView);
    
    
    [super dealloc];
}

- (void)sign:(NSData *)dataToSign
  parentView:(UIView *)parent
parentViewController:(UIViewController *)parentViewController
   delegator:(id<SignViewUlanDelegate>)delegator
    signType:(NSString *)signType
    certType:(NSString *)certType
        hash:(NSString *)hash
       keyID:(NSString *)keyID
 useCachePin:(BOOL)cachepin
{
    self.keyID = keyID;
    self.dataToSigan = dataToSign;
    self.signDelegator = delegator;
    self.parentView = parent;
    self.myParentViewController = parentViewController;
    self.signType = signType;
    self.certType = certType;
    self.hashAlgorithm = hash;
    self.pinCode = nil;
    self.isAutoTest = NO;
    
    self.useCachePin = cachepin;
    
	[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.0f];
	self.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
	[UIView commitAnimations];
    
	[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	[UIView commitAnimations];
    
	[parent addSubview:self.view];
    self.view.frame = CGRectMake(0, 0, parent.frame.size.width, parent.frame.size.height);
    self.midView.center = parent.center;
    
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ];
    [self.view setAutoresizesSubviews:YES];
    [self.midView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ];
}

- (void)AutoSign:(NSData *)dataToSign
      parentView:(UIView *)parent
       delegator:(id<SignViewUlanDelegate>)delegator
         pinCode:(NSString *)pinCode
        signType:(NSString *)signType
        certType:(NSString *)certType
            hash:(NSString *)hash
           keyID:(NSString *)keyID
{
    self.keyID = keyID;
    self.dataToSigan = dataToSign;
    self.signDelegator = delegator;
    self.parentView = parent;
    self.signType = signType;
    self.certType = certType;
    self.hashAlgorithm = hash;
    self.pinCode  = pinCode;
    self.isAutoTest = YES;
        
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.0f];
    self.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
    
    [parent addSubview:self.view];
    self.view.frame = CGRectMake(0, 0, self.midView.frame.size.width, self.midView.frame.size.height);
    self.view.center = parent.center;
    self.midView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ];
    [self.view setAutoresizesSubviews:YES];
    [self.midView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]){
            self.isPad = YES;
        }
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initLayout];
    
    
    [super viewWillAppear:animated];

    
    if(self.myParentViewController !=nil){
        
        self.myParentViewController.navigationController.toolbar.userInteractionEnabled = NO;
        
        self.myParentViewController.navigationController.navigationBar.userInteractionEnabled = NO;
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    if(self.myParentViewController !=nil){
        
        self.myParentViewController.navigationController.toolbar.userInteractionEnabled = YES;
        
        self.myParentViewController.navigationController.navigationBar.userInteractionEnabled = YES;
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initLayout
{
    self.alertPinField.text = nil;
    [self.alertPinField setHidden:YES];
    [self.commitBt setHidden:YES];
    [self.pinHint setHidden:YES];
    [self.activeIndicator setHidden:YES];
    self.pinHint.text = nil;
    
    for (UILabel *label in self.labels) {
        [label setHidden:YES];
    }
    
    CGRect cancelBtFrame = cancelBtFrame_Single_iPhone;
    
    
    
    if (self.isPad) {
        cancelBtFrame=cancelBtFrame_Single_iPad;
    }
    self.cancelBt.frame = cancelBtFrame ;
    [self setLable:0 isHighLight:YES text:nil];
    
    self.ulanKey = [ULANKey sharedULANKit:self];
    if ([self.ulanKey isConnected] == NO) {
        [self.ulanKey connectKey:self.keyID];
    } else if (self.keyID != nil && [self.keyID isEqualToString:self.connectKeyID] == NO) {
        [self.ulanKey disConnect];
        sleep(1);
        [self.ulanKey connectKey:self.keyID];
    } else {
        [self didConnected:0 keyID:self.connectKeyID];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //登陆接口不进行动画
    if (self.isPad == NO && !self.fromLogin) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.midView.frame = CGRectMake(self.midView.frame.origin.x, self.midView.frame.origin.y - 70, self.midView.frame.size.width, self.midView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!self.isPad) {
        
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.midView.center=self.view.center;
        [UIView commitAnimations];
            
    }
}

- (void)didConnected:(ULANKeyError *)err keyID:(NSString *)keyID
{
    if (err != nil) {
        [self removeSelfView:1.0];
        [self.signDelegator afterDone:err type:kFailure result:@"Connect failed!"];
        return;
    }
    
    if (keyID != nil) {
        self.connectKeyID = keyID;
    }
    
    [UIView beginAnimations:@"animationCancel" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5f];
    
    CATransition *animationPin = [CATransition animation];
    animationPin.duration = 1.0f;
    animationPin.type = kCATransitionReveal;
    
    CATransition *animationCommit = [CATransition animation];
    animationCommit.duration = 0.5f;
    animationCommit.type = kCATransitionMoveIn;
    animationCommit.subtype = kCATransitionFromRight;
    
    CGRect cancelBtFrame=cancelBtFrame_iPhone;
    if (self.isPad){
        cancelBtFrame = cancelBtFrame_iPad;
    }
    
    self.alertPinField.hidden = NO;
    self.pinHint.hidden = NO;
    self.commitBt.hidden = NO;
    self.cancelBt.frame = cancelBtFrame;
    [UIView commitAnimations];
    
    [self.alertPinField.layer addAnimation:animationPin forKey:@"animationPin"];
    [self.commitBt.layer addAnimation:animationCommit forKey:@"animationCommit"];
    
    [self setLable:1 isHighLight:YES text:nil];
    if (self.isAutoTest) {
        [self removePin];
        
        [self.ulanKey signData:self.dataToSigan
                           pin:self.pinCode
                      signType:self.signType
                 hashAlgorithm:self.hashAlgorithm
                      certType:self.certType];
        
        [self setLable:2 isHighLight:YES text:nil];
        [self.activeIndicator setHidden:NO];
        [self.activeIndicator startAnimating];
    }else if(self.useCachePin  && [HDApplicationContext shareContext].cacheKey != nil){
        [self removePin];

        [self.ulanKey signData:self.dataToSigan
                           pin:[HDApplicationContext shareContext].cacheKey
                      signType:self.signType
                 hashAlgorithm:self.hashAlgorithm
                      certType:self.certType];
        
        [self setLable:2 isHighLight:YES text:nil];
        [self.activeIndicator setHidden:NO];
        [self.activeIndicator startAnimating];
    
    }else {
        [self.alertPinField becomeFirstResponder];
    }
}

- (void)removeSelfView:(double)duration
{
    [self performSelectorInBackground:@selector(removeSelfViewThread:) withObject:[NSNumber numberWithDouble:duration]];
}

- (void)removeSelfViewThread:(NSNumber *)duration
{
    sleep(duration.doubleValue);
    [self performSelectorOnMainThread:@selector(removeSelfViewMainThread) withObject:nil waitUntilDone:YES];
}

- (void)removeSelfViewMainThread
{
    [self.parentView setAlpha:1.0];
    [self.view removeFromSuperview];
}

#pragma mark - Ulan delegate
- (void)didDisConnected:(ULANKeyError *)err
{
//    self.pinHint.text = @"已断开连接!";
    self.pinHint.hidden = NO;
    [self.activeIndicator stopAnimating];
    [self removeSelfView:0.1];
    [self.signDelegator afterDone:err type:kDisconnected result:@"BLE 断开连接"];
}



- (void)pinIsUnmodified
{
    //default pin should be modified first.
    NSLog(@"%@",@"pinStatus is ULAN_PIN_STATUS_NOT_MODIFIED !!!  ");
    
}

- (void)didSigned:(ULANKeyError*)err result:(NSString *)signature
{
    if (err == nil) {
        [self setLable:3 isHighLight:YES text:TTLocalizedString(@"Digital signature failure", @"Digital signature failure") ];
        self.singatureBase64 = signature;
//        NSString* result= [NSString stringWithFormat:@"签名结果：%@",self.singatureBase64];
//        [self setLable:4 isHighLight:NO text:result ];
//        [self.ulanKey disConnect];
        [self.signDelegator afterDone:err type:kSignSucess result:signature];
    } else {
        if (err.errorCode == CFIST_ERROR_INVALID_PIN) {
            [self didConnected:nil keyID:self.connectKeyID];
            [self setLable:4 isHighLight:YES text:[NSString stringWithFormat:TTLocalizedString(@"PIN code error! \n Residual can retry:%i", @"PIN code error! \n Residual can retry:%i"),err.pinCanRetries]];
        } else if (err.errorCode == CFIST_ERROR_PIN_LOCKED) {
            [self setLable:4 isHighLight:YES text:[NSString stringWithFormat:TTLocalizedString(@"PINCode has been locked:%@", @"PINCode has been locked:%@"), [err toString]]];
            [self.ulanKey disConnect];
            [self.signDelegator afterDone:err type:kFailure result:signature];
            [self.activeIndicator stopAnimating];
            [self removeSelfView:1.0];
        } else if (err.errorCode == CFIST_ERROR_USER_CANCEL) {
//            [self setLable:4 isHighLight:YES text:[NSString stringWithFormat:@"用户已取消交易%@", [err toString]]];
            [self.ulanKey disConnect];
            [self.signDelegator afterDone:err type:kFailure result:signature];
            [self.activeIndicator stopAnimating];
            [self removeSelfView:1.0];
        } else {
            [self setLable:4 isHighLight:YES text:[NSString stringWithFormat:TTLocalizedString(@"Digital signature failure:%@", @"Digital signature failure:%@"), [err toString]]];
            [self.ulanKey disConnect];
            [self.signDelegator afterDone:err type:kFailure result:signature];
            [self.activeIndicator stopAnimating];
            [self removeSelfView:1.0];
        }
    }
}

- (IBAction)onPinCommit:(id)sender
{
    if (self.alertPinField.text.length == 0) {
        self.pinHint.text = @"Pin码不可为空!";
        return;
    }
    
    [self.ulanKey signData:self.dataToSigan
                       pin:self.alertPinField.text
                  signType:self.signType
             hashAlgorithm:self.hashAlgorithm
                  certType:self.certType];
    
    [self setLable:2 isHighLight:YES text:nil];
    [self.activeIndicator setHidden:NO];
    [self.activeIndicator startAnimating];
    [self removePin];
    
    /////cache key
    
    [HDApplicationContext shareContext].cacheKey = self.alertPinField.text;
    
    
}

- (IBAction)onCancel:(id)sender
{
    if (self.ulanKey) {
        [self.ulanKey disConnect];
    }
    if (self.signDelegator) {
        [self.signDelegator afterDone:nil type:kCancel result:@"用户取消本次测试"];
    }
    
    [self removeSelfView:0];
}

- (void)removePin
{
    [UIView beginAnimations:@"animationCancelRemove" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35f];
    
    CATransition *animationPin = [CATransition animation];
    animationPin.removedOnCompletion=YES;
    animationPin.duration = 0.35f;
    animationPin.type = kCATransitionFade;

    CATransition *animationCommit = [CATransition animation];
    animationCommit.delegate=self;
    animationCommit.duration = 0.5f;
    animationCommit.type = kCATransitionMoveIn;
    animationCommit.subtype = kCATransitionFromLeft;
    
    [self.alertPinField setHidden:YES];
    [self.pinHint setHidden:YES];
    [self.commitBt setHidden:YES];
    
    CGRect cancelBtFrame = cancelBtFrame_Single_iPhone;
    if (self.isPad) {
        cancelBtFrame = cancelBtFrame_Single_iPad;
    }
    self.cancelBt.frame = cancelBtFrame ;
    
    [UIView commitAnimations];
    
    [self.alertPinField.layer addAnimation:animationPin forKey:@"animationPinRemove"];
    [self.pinHint.layer addAnimation:animationPin forKey:@"animationPinHintRemove"];
    [self.commitBt.layer addAnimation:animationCommit forKey:@"animationCommitRemove"];
    [self.alertPinField resignFirstResponder];
    
}

//设置制定的lable高亮，同时其余变暗
- (void)setLable:(int)index isHighLight:(BOOL)isHighLight text:(NSString*)text
{
    UIColor *targetColor = (isHighLight ? [UIColor whiteColor] : [UIColor grayColor]);
    for (int i=0; i<self.labels.count; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        if (i == index) {
            label.textColor = targetColor;
            if (text) {
                label.text = text;
            }
            label.hidden = NO;
        } else if(i < index) {
            label.textColor = [UIColor grayColor];
        } else {
            label.hidden = YES;
        }
    }
}

-(void) didCertFetched:(ULANKeyError*)err cert:(ULANKeyCertificate *)cert

{
    NSLog(@"read");
    
    
}

@end
