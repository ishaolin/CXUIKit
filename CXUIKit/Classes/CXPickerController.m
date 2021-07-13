//
//  CXPickerController.m
//  Pods
//
//  Created by wshaolin on 2021/7/6.
//

#import "CXPickerController.h"
#import <CXFoundation/CXLog.h>
#import "UIViewController+CXUIKit.h"
#import <objc/runtime.h>

@implementation CXPickerController

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController{
    if(self = [super init]){
        _fromViewController = fromViewController;
    }
    
    return self;
}

- (void)invoke{
    self.fromViewController.cx_pickerController = self;
}

- (void)finish{
    self.fromViewController.cx_pickerController = nil;
}

- (void)setContentController:(UIViewController *)contentController{
    [self.fromViewController presentViewController:contentController
                                          animated:YES
                                        completion:NULL];
}

- (void)dealloc{
#ifdef DEBUG
    LOG_INFO(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

@end

@implementation UIViewController (CXPickerController)

- (void)setCx_pickerController:(CXPickerController *)cx_pickerController{
    objc_setAssociatedObject(self, @selector(cx_pickerController), cx_pickerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CXPickerController *)cx_pickerController{
    return objc_getAssociatedObject(self, _cmd);
}

@end
