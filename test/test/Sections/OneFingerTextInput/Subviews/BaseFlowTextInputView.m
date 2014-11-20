//
//  BaseFlowTextInputView.m
//  test
//
//  Created by XiangqiTu on 14-11-20.
//
//

#import "BaseFlowTextInputView.h"
#import "CLTextLabel.h"
#import "CLCircleView.h"
#import "UIView+Frame.h"

static NSString* const CLTextViewActiveViewDidChangeNotification = @"CLTextViewActiveViewDidChangeNotificationString";
static NSString* const CLTextViewActiveViewDidTapNotification = @"CLTextViewActiveViewDidTapNotificationString";

@interface BaseFlowTextInputView ()
{
    CLTextLabel *_label;
    UIButton *_deleteButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@end

@implementation BaseFlowTextInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

+ (void)setActiveTextView:(BaseFlowTextInputView*)view
{
    static BaseFlowTextInputView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
        
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidChangeNotification object:view userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 132, 132)];
    if(self){
        _label = [[CLTextLabel alloc] init];
        [_label setTextColor:[UIColor blackColor]];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.layer.borderColor = [[UIColor blackColor] CGColor];
        _label.layer.cornerRadius = 3;
        _label.font = [UIFont systemFontOfSize:200];
        _label.minimumScaleFactor = 1/200.0;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        self.text = @"";
        [self addSubview:_label];
        
        CGSize size = [_label sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
        _label.frame = CGRectMake(16, 16, size.width, size.height);
        self.frame = CGRectMake(0, 0, size.width + 32, size.height + 32);
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _label.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_label.width + _label.left, _label.height + _label.top);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor blackColor];
        _circleView.borderWidth = 3;
        [self addSubview:_circleView];
        
        _arg = 0;
        [self setScale:1];
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _label.userInteractionEnabled = YES;
    [_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_label addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
//    [self sizeToFitWithMaxWidth:self.superview.width lineHeight:self.superview.height *0.2];
}

#pragma mark- Properties

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _label.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}

- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    double diff1 = [[NSDate date] timeIntervalSince1970];
    self.transform = CGAffineTransformIdentity;
    _label.transform = CGAffineTransformIdentity;
    
    CGSize size = [_label sizeThatFits:CGSizeMake(width / (15/200.0), FLT_MAX)];
    _label.frame = CGRectMake(16, 16, size.width, size.height);
    
    CGFloat viewW = (_label.width + 32);
    CGFloat viewH = _label.font.lineHeight;
    
    CGFloat ratio = MIN(width / viewW, lineHeight / viewH);
    
    NSLog(@"%lf          method one",diff1 - [[NSDate date] timeIntervalSince1970]);
    [self setScale:ratio];
}

- (void)setScale:(CGFloat)scale
{
    double diff1 = [[NSDate date] timeIntervalSince1970];
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _label.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_label.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_label.height + 32)) / 2;
    rct.size.width  = _label.width + 32;
    rct.size.height = _label.height + 32;
    self.frame = rct;
    
    _label.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _label.layer.borderWidth = 1/_scale;
    _label.layer.cornerRadius = 3/_scale;
    
    NSLog(@"%lf---------method two",diff1 - [[NSDate date] timeIntervalSince1970]);
}

- (void)setFillColor:(UIColor *)fillColor
{
    _label.textColor = fillColor;
}

- (UIColor*)fillColor
{
    return _label.textColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _label.outlineColor = borderColor;
}

- (UIColor*)borderColor
{
    return _label.outlineColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _label.outlineWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return _label.outlineWidth;
}

- (void)setFont:(UIFont *)font
{
    _label.font = [font fontWithSize:200];
}

- (UIFont*)font
{
    return _label.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _label.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return _label.textAlignment;
}

- (void)setText:(NSString *)text
{
    if(![text isEqualToString:_text]){
        _text = text;
        _label.text = (_text.length>0) ? _text : @"NO\nNO\n✋\n☀️";
    }
}

#pragma mark- gesture events

- (void)pushedDeleteBtn:(id)sender
{
    BaseFlowTextInputView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[BaseFlowTextInputView class]]){
            nextTarget = (BaseFlowTextInputView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[BaseFlowTextInputView class]]){
                nextTarget = (BaseFlowTextInputView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveTextView:nextTarget];
    [self removeFromSuperview];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if(self.active){
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 15/200.0)];
}

@end
