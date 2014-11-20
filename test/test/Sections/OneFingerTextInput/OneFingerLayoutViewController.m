//
//  OneFingerLayoutViewController.m
//  test
//
//  Created by XiangqiTu on 14-11-20.
//
//

#import "OneFingerLayoutViewController.h"
#import "UIView+Frame.h"
#import "BaseFlowTextInputView.h"

@interface OneFingerLayoutViewController ()

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UIButton          *addTextButton;
@property (nonatomic, strong) UIView            *workspaceView;

@end

@implementation OneFingerLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect r = [[UIScreen mainScreen] bounds];
    
    self.workspaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, r.size.width , r.size.width)];
    [self.workspaceView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.700]];
    [self.view addSubview:self.workspaceView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.workspaceView.frame];
    [self.imageView setImage:[UIImage imageNamed:@"nonomori"]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setBackgroundColor:[UIColor clearColor]];
    [self.workspaceView addSubview:self.imageView];
    
    self.addTextButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.addTextButton.center = self.view.center;
    self.addTextButton.bottom = self.view.bottom - self.addTextButton.height ;
    [self.addTextButton addTarget:self action:@selector(responseToAddTextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addTextButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseToTapBackground:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)responseToAddTextButton:(UIButton *)button
{
    BaseFlowTextInputView *textView = [[BaseFlowTextInputView alloc] init];
    [textView setBackgroundColor:[UIColor colorWithWhite:0.667 alpha:0.200]];
    textView.center = self.workspaceView.center;
    [self.workspaceView addSubview:textView];
}

- (void)responseToTapBackground:(UIGestureRecognizer *)tap
{
    [BaseFlowTextInputView setActiveTextView:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
