//
//  UIDevice+CXUIKit.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "UIDevice+CXUIKit.h"
#import <objc/runtime.h>
#import <CXFoundation/CXFoundation.h>
#import "UIScreen+CXUIKit.h"
#import "CXAlertControllerUtils.h"
#import "CXAppUtils.h"
#import <sys/mount.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

#define CX_UI_DEVICE_IDENTIFIER_KEY    @"device.identifier"
#define CX_UI_DEVICE_KEYCHAIN_SERVICE  @"cx.uikit.keychain"

@implementation UIDevice (CXUIKit)

- (void)cx_callPhone:(NSString *)phone{
    if(CXStringIsEmpty(phone)){
        return;
    }
    
    static NSLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    
    if([lock tryLock]){
        NSURL *url = [NSURL cx_validURL:[NSString stringWithFormat:@"tel:%@", phone]];
        if(@available(iOS 10.2, *)){
            [CXAppUtils openURL:url];
        }else{
            [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
                config.title = phone;
                config.buttonTitles = @[@"取消", @"呼叫"];
            } completion:^(NSUInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [CXAppUtils openURL:url];
                }
            }];
        }
        
        [lock cx_unlock:0.5];
    }
}

- (NSString *)cx_identifier{
    NSString *identifier = [CXKeychain stringForKey:CX_UI_DEVICE_IDENTIFIER_KEY
                                            service:CX_UI_DEVICE_KEYCHAIN_SERVICE];
    if(!identifier){
        identifier = [CXUCryptor SHA1:self.identifierForVendor.UUIDString];
        [CXKeychain setValue:identifier
                      forKey:CX_UI_DEVICE_IDENTIFIER_KEY
                     service:CX_UI_DEVICE_KEYCHAIN_SERVICE];
    }
    
    return identifier;
}

- (NSString *)cx_resolution{
    NSString *resolution = objc_getAssociatedObject(self, _cmd);
    if(resolution){
        return resolution;
    }
    
    resolution = [NSString stringWithFormat:@"%@x%@", @([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale), @([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale)];
    objc_setAssociatedObject(self, _cmd, resolution, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return resolution;
}

- (NSNumber *)cx_jailbreak{
    __block NSNumber *jailbreak = objc_getAssociatedObject(self, _cmd);
    if(jailbreak != nil){
        return jailbreak;
    }
    
    jailbreak = @(0);
    [@[@"/Applications/Cydia.app",
       @"/Library/MobileSubstrate/MobileSubstrate.dylib",
       @"/bin/bash",
       @"/usr/sbin/sshd",
       @"/etc/apt"
    ] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[NSFileManager defaultManager] fileExistsAtPath:obj]){
            jailbreak = @(1);
            *stop = YES;
        }
    }];
    
    objc_setAssociatedObject(self, _cmd, jailbreak, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return jailbreak;
}

- (NSNumber *)cx_platform{
    return @(1);
}

- (NSString *)cx_currentLanguage{
    NSArray<NSString *> *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return languages.firstObject;
}

- (uint64_t)cx_physicalMemory{
    return [NSProcessInfo processInfo].physicalMemory;
}

- (uint64_t)cx_availableMemory{
    vm_statistics_data_t vms_data;
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    if(host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vms_data, &count) == KERN_SUCCESS){
        return (vm_page_size * vms_data.free_count + vm_page_size * vms_data.inactive_count);
    }
    
    return 0;
}

- (uint64_t)cx_totalDiskSize{
    struct statfs buffer;
    if(statfs("/var", &buffer) >= 0){
        return (buffer.f_bsize * buffer.f_blocks);
    }
    
    return 0;
}

- (uint64_t)cx_availableDiskSize{
    struct statfs buffer;
    if(statfs("/var", &buffer) >= 0){
        return (buffer.f_bsize * buffer.f_bavail);
    }
    
    return 0;
}

- (NSString *)cx_cpuType{
    host_basic_info_data_t host_data;
    mach_msg_type_number_t count = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&host_data, &count);
    switch(host_data.cpu_type){
        case CPU_TYPE_ARM:
            return @"ARM";
        case CPU_TYPE_ARM64:
            return @"ARM64";
        case CPU_TYPE_X86:
            return @"X86";
        case CPU_TYPE_X86_64:
            return @"X86_64";
        default:
            return @"UNKNOWN";
    }
}

@end
