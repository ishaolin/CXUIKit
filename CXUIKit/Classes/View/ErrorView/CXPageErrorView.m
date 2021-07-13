//
//  CXPageErrorView.m
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXPageErrorView.h"
#import "UIColor+CXUIKit.h"
#import "UIFont+CXUIKit.h"
#import "UIButton+CXUIKit.h"
#import "CXImageUtils.h"
#import "CXUIUtils.h"
#import "CXStringBounding.h"

@implementation CXPageErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = CX_UIKIT_IMAGE(@"ui_page_error_image");
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = CX_PingFangSC_RegularFont(14.0);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = CXHexIColor(0xCDD4DA);
        _textLabel.numberOfLines = 0;
        
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.titleLabel.font = CX_PingFangSC_RegularFont(16.0);
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        
        [_refreshButton setTitleColor:CXHexIColor(0x1DBEFF) forState:UIControlStateNormal];
        [_refreshButton cx_setBackgroundColor:CXHexIColor(0xFFFFFF) forState:UIControlStateNormal];
        [_refreshButton cx_setBackgroundColor:CXHexIColor(0xE8F8FF) forState:UIControlStateHighlighted];
        _refreshButton.layer.borderWidth = 1.0;
        _refreshButton.layer.borderColor = CXHexIColor(0x1DBDFF).CGColor;
        _refreshButton.layer.cornerRadius = 22.0;
        _refreshButton.clipsToBounds = YES;
        [_refreshButton addTarget:self action:@selector(handleActionForRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
        [self addSubview:_refreshButton];
    }
    
    return self;
}

- (void)showWithError:(NSError *)error{
    switch (error.code) {
        case NSURLErrorBadURL:{
            [self showWithErrorCode:CXPageErrorCodeBadURL];
        }
            break;
        case NSURLErrorTimedOut:{
            [self showWithErrorCode:CXPageErrorCodeTimedOut];
        }
            break;
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorDNSLookupFailed:{
            [self showWithErrorCode:CXPageErrorCodeInternetUnavailable];
        }
            break;
        default:{
            if(error.code != NSURLErrorCancelled){
                [self showWithErrorCode:CXPageErrorCodeInternetUnavailable];
            }
        }
            break;
    }
}

- (void)showWithErrorCode:(CXPageErrorCode)errorCode{
    NSString *title = nil;
    switch (errorCode) {
        case CXPageErrorCodeTimedOut:{
            title = @"服务器繁忙";
            _textLabel.text = [NSString stringWithFormat:@"%@\n请点击刷新进行重试", title];
            _refreshButton.hidden = NO;
        }
            break;
        case CXPageErrorCodeInternetUnavailable:{
            title = @"网络异常";
            _textLabel.text = [NSString stringWithFormat:@"%@\n请点击刷新进行重试", title];
            _refreshButton.hidden = NO;
        }
            break;
        case CXPageErrorCodeBadURL:{
            title = @"找不到页面";
            _textLabel.text = [NSString stringWithFormat:@"%@\n请稍后重试", title];
            _refreshButton.hidden = YES;
        }
            break;
        case CXPageErrorCodeNoData:{
            title = @"暂无数据";
            _textLabel.text = [NSString stringWithFormat:@"%@\n请点击按钮刷新", title];
            _refreshButton.hidden = NO;
        }
            break;
        default:{
            title = @"未知异常";
            _textLabel.text = [NSString stringWithFormat:@"%@\n请点击刷新进行重试", title];
            _refreshButton.hidden = NO;
        }
            break;
    }
    
    self.hidden = NO;
    
    if([self.delegate respondsToSelector:@selector(pageErrorView:showErrorWithPageTitle:)]){
        [self.delegate pageErrorView:self showErrorWithPageTitle:title];
    }
    
    [self setNeedsLayout];
}

- (void)handleActionForRefreshButton:(UIButton *)refreshButton{
    if([self.delegate respondsToSelector:@selector(pageErrorViewDidNeedsReload:)]){
        [self.delegate pageErrorViewDidNeedsReload:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat textLabel_X = CX_MARGIN(20.0);
    CGFloat textLabel_W = CGRectGetWidth(self.bounds) - textLabel_X * 2;
    CGFloat textLabel_H = [CXStringBounding bounding:_textLabel.text
                                        rectWithSize:CGSizeMake(textLabel_W, MAXFLOAT)
                                                font:_textLabel.font].size.height + 20.0;
    
    CGFloat imageView_W = CX_MARGIN_MIN(205.0);
    CGFloat imageView_H = imageView_W;
    CGFloat imageView_X = (CGRectGetWidth(self.bounds) - imageView_W) * 0.5;
    CGFloat imageView_Y = (CGRectGetHeight(self.bounds) - imageView_H - textLabel_H) * 0.25;
    _imageView.frame = (CGRect){imageView_X, imageView_Y, imageView_W, imageView_H};
    
    CGFloat textLabel_Y = CGRectGetMaxY(_imageView.frame);
    _textLabel.frame = (CGRect){textLabel_X, textLabel_Y, textLabel_W, textLabel_H};
    
    CGFloat refreshButton_W = 163.0;
    CGFloat refreshButton_H = 44.0;
    CGFloat refreshButton_X = (CGRectGetWidth(self.bounds) - refreshButton_W) * 0.5;
    CGFloat refreshButton_Y = CGRectGetMaxY(_textLabel.frame) + 15.0;
    _refreshButton.frame = (CGRect){refreshButton_X, refreshButton_Y, refreshButton_W, refreshButton_H};
}

@end
