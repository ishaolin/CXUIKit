//
//  CXUIFontName.m
//  Pods
//
//  Created by wshaolin on 2017/6/21.
//
//

#import "CXUIFontName.h"

CXUIFontName const CXUIFontNamePingFangHK_Ultralight = @"PingFangHK-Ultralight";
CXUIFontName const CXUIFontNamePingFangHK_Light = @"PingFangHK-Light";
CXUIFontName const CXUIFontNamePingFangHK_Thin = @"PingFangHK-Thin";
CXUIFontName const CXUIFontNamePingFangHK_Regular = @"PingFangHK-Regular";
CXUIFontName const CXUIFontNamePingFangHK_Medium = @"PingFangHK-Medium";
CXUIFontName const CXUIFontNamePingFangHK_Semibold = @"PingFangHK-Semibold";

CXUIFontName const CXUIFontNamePingFangSC_Ultralight = @"PingFangSC-Ultralight";
CXUIFontName const CXUIFontNamePingFangSC_Light = @"PingFangSC-Light";
CXUIFontName const CXUIFontNamePingFangSC_Thin = @"PingFangSC-Thin";
CXUIFontName const CXUIFontNamePingFangSC_Regular = @"PingFangSC-Regular";
CXUIFontName const CXUIFontNamePingFangSC_Medium = @"PingFangSC-Medium";
CXUIFontName const CXUIFontNamePingFangSC_Semibold = @"PingFangSC-Semibold";

CXUIFontName const CXUIFontNamePingFangTC_Ultralight = @"PingFangTC-Ultralight";
CXUIFontName const CXUIFontNamePingFangTC_Light = @"PingFangTC-Light";
CXUIFontName const CXUIFontNamePingFangTC_Thin = @"PingFangTC-Thin";
CXUIFontName const CXUIFontNamePingFangTC_Regular = @"PingFangTC-Regular";
CXUIFontName const CXUIFontNamePingFangTC_Medium = @"PingFangTC-Medium";
CXUIFontName const CXUIFontNamePingFangTC_Semibold = @"PingFangTC-Semibold";

CXUIFontName const CXUIFontNameHelvetica = @"Helvetica";
CXUIFontName const CXUIFontNameHelvetica_Bold = @"Helvetica-Bold";
CXUIFontName const CXUIFontNameHelvetica_BoldOblique = @"Helvetica-BoldOblique";
CXUIFontName const CXUIFontNameHelvetica_Light = @"Helvetica-Light";
CXUIFontName const CXUIFontNameHelvetica_LightOblique = @"Helvetica-LightOblique";
CXUIFontName const CXUIFontNameHelvetica_Oblique = @"Helvetica-Oblique";

CXUIFontName const CXUIFontNameHelveticaNeue = @"HelveticaNeue";
CXUIFontName const CXUIFontNameHelveticaNeue_Bold = @"HelveticaNeue-Bold";
CXUIFontName const CXUIFontNameHelveticaNeue_BoldItalic = @"HelveticaNeue-BoldItalic";
CXUIFontName const CXUIFontNameHelveticaNeue_CondensedBlack = @"HelveticaNeue-CondensedBlack";
CXUIFontName const CXUIFontNameHelveticaNeue_CondensedBold = @"HelveticaNeue-CondensedBold";
CXUIFontName const CXUIFontNameHelveticaNeue_Italic = @"HelveticaNeue-Italic";
CXUIFontName const CXUIFontNameHelveticaNeue_Light = @"HelveticaNeue-Light";
CXUIFontName const CXUIFontNameHelveticaNeue_LightItalic = @"HelveticaNeue-LightItalic";
CXUIFontName const CXUIFontNameHelveticaNeue_Medium = @"HelveticaNeue-Medium";
CXUIFontName const CXUIFontNameHelveticaNeue_MediumItalic = @"HelveticaNeue-MediumItalic";
CXUIFontName const CXUIFontNameHelveticaNeue_UltraLight = @"HelveticaNeue-UltraLight";
CXUIFontName const CXUIFontNameHelveticaNeue_UltraLightItalic = @"HelveticaNeue-UltraLightItalic";
CXUIFontName const CXUIFontNameHelveticaNeue_Thin = @"HelveticaNeue-Thin";
CXUIFontName const CXUIFontNameHelveticaNeue_ThinItalic = @"HelveticaNeue-ThinItalic";

CXUIFontStyle CXUIFontStyleFromFontName(CXUIFontName fontName){
    NSString *component = [fontName componentsSeparatedByString:@"-"].lastObject.lowercaseString;
    if(!component || component.length == 0){
        return CXUIFontStyleNormal;
    }
    
    if([component rangeOfString:@"italic"].location != NSNotFound){
        return CXUIFontStyleItalic;
    }
    
    if([component rangeOfString:@"medium"].location != NSNotFound){
        return CXUIFontStyleBold;
    }
    
    if([component rangeOfString:@"bold"].location != NSNotFound){
        return CXUIFontStyleBold;
    }
    
    return CXUIFontStyleNormal;
}
