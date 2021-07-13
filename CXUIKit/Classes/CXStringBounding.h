//
//  CXStringBounding.h
//  Pods
//
//  Created by wshaolin on 2021/7/9.
//

#import <UIKit/UIKit.h>

@interface CXStringBounding : NSObject

+ (CGRect)bounding:(NSString *)string
      rectWithSize:(CGSize)size
              font:(UIFont *)font;

+ (CGRect)bounding:(NSString *)string
      rectWithSize:(CGSize)size
        attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes;

@end
