//
//  UIDevice+CXUIKit.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (CXUIKit)

@property (nonatomic, copy, readonly) NSString *cx_identifier;
@property (nonatomic, copy, readonly) NSString *cx_resolution;          // @"2208x1240"
@property (nonatomic, copy, readonly) NSString *cx_currentLanguage;     // current system language
@property (nonatomic, strong, readonly) NSNumber *cx_jailbreak;         // 0 or 1
@property (nonatomic, strong, readonly) NSNumber *cx_platform;          // Always @(1)->iOS platform
@property (nonatomic, assign, readonly) uint64_t cx_physicalMemory;     // physical memory
@property (nonatomic, assign, readonly) uint64_t cx_availableMemory;    // available memory
@property (nonatomic, assign, readonly) uint64_t cx_totalDiskSize;      // total disk size
@property (nonatomic, assign, readonly) uint64_t cx_availableDiskSize;  // available disk size
@property (nonatomic, copy, readonly) NSString *cx_cpuType;             // CPU type, ARM/ARM64/X86/X86_64

- (void)cx_callPhone:(NSString *)phone;

@end
