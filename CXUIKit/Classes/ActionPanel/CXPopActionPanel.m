//
//  CXPopActionPanel.m
//  Pods
//
//  Created by wshaolin on 2018/10/11.
//

#import "CXPopActionPanel.h"
#import "UIFont+CXUIKit.h"
#import "UIView+CXUIKit.h"
#import "UIImage+CXUIKit.h"
#import "CXStringBounding.h"

static const CGFloat CXPopActionPanelOuterEdge = 5.0;

typedef NS_ENUM(NSInteger, CXPopActionPanelArrowDirection){
    CXPopActionPanelArrowDirectionNone,
    CXPopActionPanelArrowDirectionUp,
    CXPopActionPanelArrowDirectionDown,
    CXPopActionPanelArrowDirectionLeft,
    CXPopActionPanelArrowDirectionRight
};

@interface CXPopActionPanel () {
    CXPopActionPanelArrowDirection _arrowDirection;
    CGFloat _arrowPosition;
    CGRect _fromRect;
    
    UIView *_contentView;
    NSArray<CXPopActionItem *> *_actionItems;
}

@end

@implementation CXPopActionPanel

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.alpha = 0;
        self.animationType = CXActionPanelAnimationCustom;
        self.overlayStyle = CXActionPanelOverlayStyleClear;
        self.itemContentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [super setBackgroundColor:[UIColor clearColor]];
        
        self.rowHeight = 44.0;
        self.titleFont = CX_PingFangSC_RegularFont(14.0);
        self.tintColor = [UIColor whiteColor];
        self.titleHighlightedColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.cornerRadius = 5.0;
        self.arrowSize = 12.0;
        self.itemImageTitleMargin = 5.0;
        self.contentEdgeInsets = (UIEdgeInsets){0, 12.0, 0, 12.0};
        
        _contentView = [[UIView alloc] init];
        _contentView.autoresizingMask = UIViewAutoresizingNone;
        _contentView.opaque = NO;
        _contentView.hidden = YES;
        [self addSubview:_contentView];
        
        self.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        _hideSeparator = NO;
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
}

- (void)showInView:(UIView *)view forRect:(CGRect)rect{
    _fromRect = rect;
    
    [self makeContentView];
    [self showInView:view];
}

- (void)showWithItems:(NSArray<CXPopActionItem *> *)items forRect:(CGRect)rect{
    _actionItems = items;
    _fromRect = rect;
    
    [self makeContentView];
    [self showInView:nil];
}

- (CGPoint)arrowPoint{
    switch (_arrowDirection) {
        case CXPopActionPanelArrowDirectionUp:
            return (CGPoint){CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame)};
        case CXPopActionPanelArrowDirectionDown:
            return (CGPoint){CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame)};
        case CXPopActionPanelArrowDirectionLeft:
            return (CGPoint){CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition};
        case CXPopActionPanelArrowDirectionRight:
            return (CGPoint){CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition};
        default:
            return self.center;
    }
}

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView{
    CGRect frame = self.frame;
    self.frame = (CGRect){[self arrowPoint], CGSizeZero};
    
    return ^{
        self.alpha = 1.0;
        self.frame = frame;
    };
}

- (void)didAddToSuperView:(UIView *)superView{
    [super didAddToSuperView:superView];
    
    [self setupFrameInView:superView forRect:_fromRect];
}

- (void)didPresent{
    [super didPresent];
    
    self->_contentView.hidden = NO;
}

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView{
    CGRect frame = (CGRect){[self arrowPoint], CGSizeZero};
    
    return ^{
        self.alpha = 0;
        self.frame = frame;
    };
}

- (void)setupFrameInView:(UIView *)view forRect:(CGRect)rect{
    CGSize contentSize = _contentView.frame.size;
    _arrowDirection = CXPopActionPanelArrowDirectionNone;
    CGRect frame = (CGRect){(view.bounds.size.width - contentSize.width) * 0.5, (view.bounds.size.height - contentSize.height) * 0.5, contentSize};
    
    if((contentSize.height  + self.arrowSize) < (view.bounds.size.height - CGRectGetMaxY(rect))){
        _arrowDirection = CXPopActionPanelArrowDirectionUp;
        
        CGPoint point = (CGPoint){CGRectGetMidX(rect) - contentSize.width * 0.5, CGRectGetMaxY(rect)};
        if(point.x < CXPopActionPanelOuterEdge){
            point.x = CXPopActionPanelOuterEdge;
        }
        if((point.x + contentSize.width + CXPopActionPanelOuterEdge) > view.bounds.size.width){
            point.x = view.bounds.size.width - contentSize.width - CXPopActionPanelOuterEdge;
        }
        
        _arrowPosition = CGRectGetMidX(rect) - point.x;
        _contentView.frame = (CGRect){0, self.arrowSize, contentSize};
        frame = (CGRect){point, contentSize.width, contentSize.height + self.arrowSize};
    }else if((contentSize.height  + self.arrowSize) < rect.origin.y){
        _arrowDirection = CXPopActionPanelArrowDirectionDown;
        
        CGPoint point = (CGPoint){CGRectGetMidX(rect) - contentSize.width * 0.5, rect.origin.y - contentSize.height};
        if(point.x < CXPopActionPanelOuterEdge){
            point.x = CXPopActionPanelOuterEdge;
        }
        if((point.x + contentSize.width + CXPopActionPanelOuterEdge) > view.bounds.size.width){
            point.x = view.bounds.size.width - contentSize.width - CXPopActionPanelOuterEdge;
        }
        
        _arrowPosition = CGRectGetMidX(rect) - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        frame = (CGRect){point, contentSize.width, contentSize.height + self.arrowSize};
    }else if((contentSize.width + self.arrowSize) < (view.bounds.size.width - CGRectGetMaxX(rect))){
        _arrowDirection = CXPopActionPanelArrowDirectionLeft;
        
        CGPoint point = (CGPoint){CGRectGetMaxX(rect), CGRectGetMidY(rect) - contentSize.height * 0.5};
        if(point.y < CXPopActionPanelOuterEdge){
            point.y = CXPopActionPanelOuterEdge;
        }
        if((point.y + contentSize.height + CXPopActionPanelOuterEdge) > view.bounds.size.height){
            point.y = view.bounds.size.height - contentSize.height - CXPopActionPanelOuterEdge;
        }
        
        _arrowPosition = CGRectGetMidY(rect) - point.y;
        _contentView.frame = (CGRect){self.arrowSize, 0, contentSize};
        frame = (CGRect){point, contentSize.width + self.arrowSize, contentSize.height};
    }else if((contentSize.width + self.arrowSize) < rect.origin.x) {
        _arrowDirection = CXPopActionPanelArrowDirectionRight;
        
        CGPoint point = (CGPoint){rect.origin.x - contentSize.width, CGRectGetMidY(rect) - contentSize.width * 0.5};
        if(point.y < CXPopActionPanelOuterEdge){
            point.y = CXPopActionPanelOuterEdge;
        }
        if((point.y + contentSize.height + CXPopActionPanelOuterEdge) > view.bounds.size.height){
            point.y = view.bounds.size.height - contentSize.height - CXPopActionPanelOuterEdge;
        }
        
        _arrowPosition = CGRectGetMidY(rect) - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        frame = (CGRect){point, contentSize.width + self.arrowSize, contentSize.height};
    }
    
    self.frame = frame;
}

- (void)didSelectPopItemBarButton:(UIButton *)itemBarButton{
    CXPopActionItem *actionItem = _actionItems[itemBarButton.tag];
    [actionItem invokeAction:self.context];
    
    [self dismissWithAnimated:NO];
}

- (void)makeContentView{
    for(UIView *view in _contentView.subviews){
        [view removeFromSuperview];
    }
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 60.0;
    __block CGFloat itemMaxWidth = 0;
    __block BOOL hasItemImage = NO;
    [_actionItems enumerateObjectsUsingBlock:^(CXPopActionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat imageWidth = 0;
        if(obj.image){
            hasItemImage = YES;
            imageWidth = obj.image.size.width;
        }
        
        CGSize size = [CXStringBounding bounding:obj.title
                                    rectWithSize:CGSizeMake(maxWidth, self.rowHeight)
                                            font:self.titleFont].size;
        
        itemMaxWidth = MAX(itemMaxWidth, imageWidth + size.width);
    }];
    
    itemMaxWidth = MIN(itemMaxWidth, maxWidth);
    
    CGSize itemSize = (CGSize){(itemMaxWidth + _contentEdgeInsets.left * (hasItemImage ? 2 : 1) + _contentEdgeInsets.right), self.rowHeight};
    __block CGFloat item_Y = _contentEdgeInsets.top;
    NSUInteger count = _actionItems.count;
    [_actionItems enumerateObjectsUsingBlock:^(CXPopActionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *itemBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBarButton setTitle:obj.title forState:UIControlStateNormal];
        [itemBarButton setTitleColor:self.titleColor forState:UIControlStateNormal];
        [itemBarButton setTitleColor:self.titleHighlightedColor forState:UIControlStateHighlighted];
        [itemBarButton setImage:obj.image forState:UIControlStateNormal];
        [itemBarButton setImage:[obj.image cx_imageForTintColor:self.titleHighlightedColor] forState:UIControlStateHighlighted];
        itemBarButton.titleLabel.font = self.titleFont;
        itemBarButton.enabled = obj.isEnabled;
        itemBarButton.opaque = NO;
        itemBarButton.contentHorizontalAlignment = self.itemContentHorizontalAlignment;
        itemBarButton.tag = idx;
        itemBarButton.frame = (CGRect){0, item_Y, itemSize.width, itemSize.height};
        itemBarButton.imageEdgeInsets = (UIEdgeInsets){0, self.contentEdgeInsets.left, 0, 0};
        CGFloat titleEdgeInsetsLeft = self.contentEdgeInsets.left;
        if(obj.image){
            titleEdgeInsetsLeft += self.itemImageTitleMargin;
        }
        itemBarButton.titleEdgeInsets = (UIEdgeInsets){0, titleEdgeInsetsLeft, 0, self.contentEdgeInsets.right};
        [itemBarButton addTarget:self action:@selector(didSelectPopItemBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self->_contentView addSubview:itemBarButton];
        item_Y += itemSize.height;
        
        if(!self.isHideSeparator && idx < count - 1){
            UIView *separator = [[UIView alloc] init];
            CGFloat separator_H = 0.5;
            separator.frame = (CGRect){self.contentEdgeInsets.left, item_Y - separator_H, itemSize.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right, separator_H};
            separator.backgroundColor = self.separatorColor;
            [self->_contentView addSubview:separator];
        }
    }];
    
    _contentView.frame = (CGRect){CGPointZero, itemSize.width, item_Y + self.contentEdgeInsets.bottom};
    [_contentView cx_roundedCornerRadii:self.cornerRadius];
}

- (void)drawRect:(CGRect)rect{
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawContentBackground:rect context:context];
}

- (void)drawContentBackground:(CGRect)frame context:(CGContextRef)context{
    CGFloat locations[] = {0.0, 1.0};
    CGFloat components[] = {
        0.267, 0.303, 0.335, 1.0,
        0.040, 0.040, 0.040, 1.0
    };
    
    if(self.backgroundColor1){
        [self.backgroundColor1 getRed:&components[0]
                                green:&components[1]
                                 blue:&components[2]
                                alpha:&components[3]];
    }
    
    if(self.backgroundColor2){
        [self.backgroundColor2 getRed:&components[4]
                                green:&components[5]
                                 blue:&components[6]
                                alpha:&components[7]];
    }
    
    CGFloat frame_x0 = CGRectGetMinX(frame);
    CGFloat frame_x1 = CGRectGetMaxX(frame);
    CGFloat frame_y0 = CGRectGetMinY(frame);
    CGFloat frame_y1 = CGRectGetMaxY(frame);
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    CGFloat offset = 3.0;
    switch (_arrowDirection) {
        case CXPopActionPanelArrowDirectionUp:{
            CGFloat arrow_x0 = _arrowPosition - self.arrowSize;
            CGFloat arrow_x1 = _arrowPosition + self.arrowSize;
            CGFloat arrow_y0 = frame_y0;
            CGFloat arrow_y1 = frame_y0 + self.arrowSize + offset;
            
            [arrowPath moveToPoint:(CGPoint){_arrowPosition, arrow_y0}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x1, arrow_y1}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x0, arrow_y1}];
            [arrowPath addLineToPoint:(CGPoint){_arrowPosition, arrow_y0}];
            
            [[UIColor colorWithRed:components[0]
                             green:components[1]
                              blue:components[2]
                             alpha:components[3]] set];
            
            frame_y0 += self.arrowSize;
        }
            break;
        case CXPopActionPanelArrowDirectionDown:{
            CGFloat arrowX0 = _arrowPosition - self.arrowSize;
            CGFloat arrowX1 = _arrowPosition + self.arrowSize;
            CGFloat arrowY0 = frame_y1 - self.arrowSize - offset;
            CGFloat arrowY1 = frame_y1;
            
            [arrowPath moveToPoint:(CGPoint){_arrowPosition, arrowY1}];
            [arrowPath addLineToPoint:(CGPoint){arrowX1, arrowY0}];
            [arrowPath addLineToPoint:(CGPoint){arrowX0, arrowY0}];
            [arrowPath addLineToPoint:(CGPoint){_arrowPosition, arrowY1}];
            
            [[UIColor colorWithRed:components[4]
                             green:components[5]
                              blue:components[6]
                             alpha:components[7]] set];
            
            frame_y1 -= self.arrowSize;
        }
            break;
        case CXPopActionPanelArrowDirectionLeft:{
            CGFloat arrow_x0 = frame_x0;
            CGFloat arrow_x1 = frame_x0 + self.arrowSize + offset;
            CGFloat arrow_y0 = _arrowPosition - self.arrowSize;
            CGFloat arrow_y1 = _arrowPosition + self.arrowSize;
            
            [arrowPath moveToPoint:(CGPoint){arrow_x0, _arrowPosition}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x1, arrow_y0}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x1, arrow_y1}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x0, _arrowPosition}];
            
            [[UIColor colorWithRed:components[0]
                             green:components[1]
                              blue:components[2]
                             alpha:components[3]] set];
            
            frame_x0 += self.arrowSize;
        }
            break;
        case CXPopActionPanelArrowDirectionRight:{
            CGFloat arrow_x0 = frame_x1;
            CGFloat arrow_x1 = frame_x1 - self.arrowSize - offset;
            CGFloat arrow_y0 = _arrowPosition - self.arrowSize;
            CGFloat arrow_y1 = _arrowPosition + self.arrowSize;
            
            [arrowPath moveToPoint:(CGPoint){arrow_x0, _arrowPosition}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x1, arrow_y0}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x1, arrow_y1}];
            [arrowPath addLineToPoint:(CGPoint){arrow_x0, _arrowPosition}];
            
            [[UIColor colorWithRed:components[4]
                             green:components[5]
                              blue:components[6]
                             alpha:components[7]] set];
            
            frame_x1 -= self.arrowSize;
        }
            break;
        default:
            break;
    }
    
    [arrowPath fill];
    
    CGRect borderRect = (CGRect){frame_x0, frame_y0, frame_x1 - frame_x0, frame_y1 - frame_y0};
    size_t count = sizeof(locations) / sizeof(locations[0]);
    [self drawBorder:borderRect context:context components:components locations:locations count:count];
}

- (void)drawBorder:(CGRect)rect context:(CGContextRef)context components:(const CGFloat[])components locations:(const CGFloat[])locations count:(size_t)count{
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadius];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    CGColorSpaceRelease(colorSpace);
    [borderPath addClip];
    
    CGPoint start = rect.origin;
    CGPoint end = (CGPoint){rect.origin.x, CGRectGetMaxY(rect)};
    if(_arrowDirection == CXPopActionPanelArrowDirectionLeft ||
       _arrowDirection == CXPopActionPanelArrowDirectionRight){
        end = (CGPoint){CGRectGetMaxX(rect), rect.origin.y};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGGradientRelease(gradient);
}

@end

@interface CXPopActionItem () {
    
}

@property (nonatomic, copy) CXPopItemActionBlock actionBlock;

@end

@implementation CXPopActionItem

- (instancetype)initWithActionBlock:(CXPopItemActionBlock)actionBlock{
    if(self = [super init]){
        self.enabled = YES;
        self.actionBlock = actionBlock;
    }
    
    return self;
}

- (void)invokeAction:(id)context{
    if(self.actionBlock){
        self.actionBlock(self, context);
    }
}

@end
