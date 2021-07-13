//
//  CXImageUtils.h
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import "UIImage+CXUIKit.h"

#define CX_UIKIT_IMAGE(name) CX_POD_IMAGE(name, @"CXUIKit")

typedef void(^CXImageBase64CompletionBlock)(NSArray<NSString *> *base64Images);

@interface CXImageUtils : NSObject

/**
 * base64 图片转换，转换过程中会进行压缩（质量和尺寸，compressMaxQuality = 300000，表示质量上限为300K）
 *
 * @param images 需要转换的图片
 * @param completion 回调
 *
 */
+ (void)imageBase64:(NSArray<UIImage *> *)images
         completion:(CXImageBase64CompletionBlock)completion;

/**
 * base64 图片转换，转换过程中会进行压缩（质量和尺寸，取决于compressMaxQuality参数）
 *
 * @param images 需要转换的图片
 * @param compressMaxQuality 最大保留的质量大小，小于等于0：不压缩
 * @param completion 回调
 *
 */
+ (void)imageBase64:(NSArray<UIImage *> *)images
 compressMaxQuality:(CGFloat)compressMaxQuality
         completion:(CXImageBase64CompletionBlock)completion;

/**
 * 图片压缩（质量和尺寸）
 *
 * @param image 需要压缩的图片
 * @param maxQuality 最大保留的质量大小，小于等于0：不压缩
 * @return 压缩之后的图片数据
 *
 */
+ (NSData *)compressImage:(UIImage *)image maxQuality:(CGFloat)maxQuality;

/**
 * 图片压缩（质量和尺寸）
 *
 * @param imageData 需要压缩的图片
 * @param maxQuality 最大保留的质量大小，小于等于0：不压缩
 * @return 压缩之后的图片数据
 *
 */
+ (NSData *)compressImageData:(NSData *)imageData maxQuality:(CGFloat)maxQuality;

/**
 * 拼接图片类型前缀（data:image/png;base64,[data]）
 *
 * @param base64 图片数据转换之后的原始字符串
 * @return 完成的base64图片数据
 *
 */
+ (NSString *)imageBase64PNG:(NSString *)base64;

/**
 * 拼接图片类型前缀（data:image/jpg;base64,[data]）
 *
 * @param base64 图片数据转换之后的原始字符串
 * @return 完成的base64图片数据
 *
 */
+ (NSString *)imageBase64JPG:(NSString *)base64;

/**
 * 拼接图片类型前缀（data:image/[type];base64,[data]）
 *
 * @param base64 图片数据转换之后的原始字符串
 * @param type 图片类型（例如：png, jpg）
 * @return 完成的base64图片数据
 *
 */
+ (NSString *)imageBase64:(NSString *)base64 type:(NSString *)type;

/**
 * 旋转图片，使方向朝上
 *
 * @param image 需要旋转的图片
 * @param orientation 当前的图片朝向
 * @return 旋转完成后的图片
 *
 */
+ (UIImage *)rotateImageOrientationToUp:(UIImage *)image orientation:(UIImageOrientation)orientation;

@end
