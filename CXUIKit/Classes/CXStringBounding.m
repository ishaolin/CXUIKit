//
//  CXStringBounding.m
//  Pods
//
//  Created by wshaolin on 2021/7/9.
//

#import "CXStringBounding.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXStringBounding

+ (CGRect)bounding:(NSString *)string
      rectWithSize:(CGSize)size
              font:(UIFont *)font{
    NSDictionary<NSAttributedStringKey, id> *attributes = nil;
    if(font){
        attributes = @{NSFontAttributeName : font};
    }
    
    return [self bounding:string rectWithSize:size attributes:attributes];
}

+ (CGRect)bounding:(NSString *)string
      rectWithSize:(CGSize)size
        attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes{
    if(CXStringIsEmpty(string)){
        return CGRectZero;
    }
    
    return [string boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil];
}

@end
