//
//  UIImage+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#define CX_LOAD_IMAGE(imageName, bundleName, frameworkName)  \
[UIImage cx_imageNamed:imageName inBundle:bundleName forframework:frameworkName]

#define CX_POD_IMAGE(imageName, podName) CX_LOAD_IMAGE(imageName, podName, podName)

#define CX_NAME_IMAGE(imageName) CX_POD_IMAGE(imageName, nil) // [UIImage cx_imageNamed:imageName]

typedef void(^CXPhotosAlbumAuthorizeResultBlock)(BOOL isAuthorised);

typedef void(^CXPhotosAlbumAccessAuthorizationBlock)(PHAuthorizationStatus status,
                                                     CXPhotosAlbumAuthorizeResultBlock authorizeResultBlock);

typedef void(^CXWriteToSavedPhotosAlbumCompletionBlock)(NSError *error);

/// 颜色渐变方向
typedef NS_ENUM(NSInteger, CXColorGradientDirection) {
    CXColorGradientHorizontal,   // 横向，从左向右（→）
    CXColorGradientVertical,     // 纵向，从上向下（↓）
    CXColorGradientUpDiagonal,   // 对角线，从左下向右上（↗）
    CXColorGradientDownDiagonal  // 对角线，从左上向右下（↘）
};

@interface UIImage (CXExtensions)

+ (UIImage *)cx_imageNamed:(NSString *)imageName;

+ (UIImage *)cx_imageNamed:(NSString *)imageName
                  inBundle:(NSString *)bundleName;

+ (UIImage *)cx_imageNamed:(NSString *)imageName
                  inBundle:(NSString *)bundleName
              forframework:(NSString *)frameworkName;

+ (UIImage *)cx_noCacheImage:(NSString *)imageName;

+ (UIImage *)cx_noCacheImage:(NSString *)imageName
                   extension:(NSString *)extension;

+ (UIImage *)cx_noCacheImage:(NSString *)imageName
                   extension:(NSString *)extension
                    inBundle:(NSBundle *)bundle;

+ (UIImage *)cx_imageWithColor:(UIColor *)color;

+ (UIImage *)cx_imageWithColor:(UIColor *)color
                          size:(CGSize)size;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
               gradientEndPoint:(CGPoint)endPoint;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
             gradientStartPoint:(CGPoint)startPoint
               gradientEndPoint:(CGPoint)endPoint;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
               gradientEndPoint:(CGPoint)endPoint
                           size:(CGSize)size;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
             gradientStartPoint:(CGPoint)startPoint
               gradientEndPoint:(CGPoint)endPoint
                           size:(CGSize)size;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
              gradientDirection:(CXColorGradientDirection)gradientDirection;

+ (UIImage *)cx_imageWithColors:(NSArray<UIColor *> *)colors
              gradientDirection:(CXColorGradientDirection)gradientDirection
                           size:(CGSize)size;

- (UIImage *)cx_imageForTintColor:(UIColor *)tintColor;

- (UIImage *)cx_imageForTintColor:(UIColor *)tintColor
                        blendMode:(CGBlendMode)blendMode;

- (UIImage *)cx_resizableImage;
- (UIImage *)cx_resizeImage:(CGSize)size;

- (UIImage *)cx_roundImage;
- (UIImage *)cx_roundImageWithRadius:(CGFloat)radius;
- (UIImage *)cx_composeImage:(UIImage *)image rect:(CGRect)rect;

- (void)cx_writeToSavedPhotosAlbum:(CXPhotosAlbumAccessAuthorizationBlock)authorization
                        completion:(CXWriteToSavedPhotosAlbumCompletionBlock)completion;

@end
