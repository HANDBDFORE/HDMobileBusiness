//
//  HDDeleverCommentViewController.m
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import "HDDeleverCommentViewController.h"
#import "HDDeleverViewController.h"

@interface HDDeleverCommentViewController (){
    UITextView * _textview;
    
    UIView * _view;
}

@end

@implementation HDDeleverCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                       target: self
                                                       action: @selector(cancel)] autorelease];
        self.navigationItem.rightBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle: TTLocalizedString(@"Done", @"")
                                          style: UIBarButtonItemStyleDone
                                         target: self
                                         action: @selector(post)] autorelease];
        
        self.title = @"转交意见";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, self.view.bounds.size.height/2-40) ];
    
                 [_textview setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_textview];
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, 40)];
    [_view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_view];
    
    UILabel * _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, _view.bounds.origin.y/3, _view.bounds.size.width, _view.bounds.size.height)];
    _lable.text = @"请选择转交人";
    [_view addSubview:_lable];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress)];
    
    [_view addGestureRecognizer:singleTap];
    
    [_textview becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonpress
{
    HDDeleverViewController * plPicker =    [[HDDeleverViewController alloc] init];
    [self.navigationController pushViewController:plPicker animated:YES];
    
}


-(void)cancel
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
