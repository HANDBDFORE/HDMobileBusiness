//
//  HDAssignCommentViewController.m
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import "HDAssignCommentViewController.h"
#import "HDAssignViewController.h"

@interface HDAssignCommentViewController (){
    UITextView * _textview;
    
    UIView * _view;
}

@end

@implementation HDAssignCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    
    [_textview becomeFirstResponder];
    

}


/////////////////private

-(void)initViews
{
    
    self.navigationItem.leftBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle: TTLocalizedString(@"Cancel", @"")
                                      style: UIBarButtonItemStyleDone
                                     target: self
                                     action: @selector(Cancel)] autorelease];
    
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle: TTLocalizedString(@"Done", @"")
                                      style: UIBarButtonItemStyleDone
                                     target: self
                                     action: @selector(Done)] autorelease];

    
    

    
    self.title = @"转交意见";
    
    
    self.commentTv.delegate = self;
    self.commentTv.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    
    if(self.commentTv.text.length !=0){
        [self.viewholderLbl setHidden:true];
        
    }
    
    //初始化默认审批意见
    
    
//    self.commentTv.layer.borderWidth = 1.0f;
//    self.commentTv.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseDeliver)];
    
    [self.coverView addGestureRecognizer:tap];
    
    
    [self.navigationController setToolbarHidden:YES];
    
    
    
}

//选择返回时候，调用的函数
-(void)deliver:(NSString *)deliverid
       name:(NSString *)delivername
{
    
    self.deliverId =deliverid;
    self.delivereeLbl.text = delivername;
    
}


////////////////////textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        return NO;
        
    }
    
    return  YES;
    
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        [self.viewholderLbl setHidden:NO];
        
    }else{
        [self.viewholderLbl setHidden:YES];
        
    }
    
    
}



///////////////////click listener

-(void)Done
{
    if(self.deliverId == nil){
        
        TTAlert(@"请选择转交人");
        return;
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate postDeliverController:self.commentTv.text delivereeid:self.deliverId];


    
}


-(void)Cancel
{
    
   [self dismissModalViewControllerAnimated:YES];
    
}

////跳转选择审批人
-(void)chooseDeliver
{
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"AssignStoryboard" bundle:nil];
    HDAssignViewController * AssignView = [StoryBoard instantiateViewControllerWithIdentifier:@"HDAssignViewController"];
    AssignView.localId = self.localId;
    AssignView.superView = self;
    
    [self.navigationController pushViewController:AssignView animated:true];
    
}


/////////////////system auto create////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_coverView release];
    [_delivereeLbl release];
    [_commentTv release];
    [_viewholderLbl release];
    [super dealloc];
}
@end
