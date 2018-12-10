//
//  PCH.swift
//  mh824appWithSwift
//
//  Created by wangyuanfei on 16/8/24.
//  Copyright © 2016年 www.16lao.com. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import SDWebImage

enum LoadDataType {
    case initialize
    case reload
    case loadMore
}
//MARK:常量字符串
let GDMessageCount = "GDMessageCount"
//MARK: swift3.0.1通知名字
let SCALE: CGFloat = (UIScreen.main.bounds.size.width > 375.0) ? 1.104:((UIScreen.main.bounds.size.width < 321) ? 0.8533:1)
let GDLanguageChanged = NSNotification.Name(rawValue:"languageChanged")
let DDTabBarItem1Reclick = NSNotification.Name("TabBarItem1Reclick")
let DDTabBarItem2Reclick = NSNotification.Name("TabBarItem2Reclick")
let DDTabBarItem3Reclick = NSNotification.Name("TabBarItem3Reclick")
let DDTabBarItem4Reclick = NSNotification.Name("TabBarItem4Reclick")
let DDTabBarItem5Reclick = NSNotification.Name("TabBarItem5Reclick")
let GDMessageCountChanged = NSNotification.Name("GDMessageCountChanged")
//let DDCurrentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.6"
let DDCurrentAppVersion = "1"
//let DDCurrentAppVersion =   "1"
//MARK: notificationName
let LoginSuccess = "LoginSuccess"
let LoginOutSuccess = "LoginOutSuccess"
let ShopcarChanged = "ShopcarChanged"
let HomeReclick = "HomeReclick"
let ClassifyReclick = "ClassifyReclick"
let LaoReclick = "LaoReclick"
let ShopcarReclick = "ShopcarReclick"
let ProfileReclick = "ProfileReclick"
let MessageChanged = "MessageChanged"
import Alamofire

//MARK: normalColor
//let MainTitleColor = UIColor.init(hexString: "333333")
//let SubTitleColor = UIColor.init(hexString: "7f7f7f")
let BackGrayColor = UIColor.init(red: 244.0/256.0, green: 244.0/256.0, blue: 244.0/256.0, alpha: 1.0) // UIColor.init(hexString: "f4f4f4")
//let THEMECOLOR = UIColor.init(hexString: "e95513")

let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height
//let TabBarHeight: CGFloat = (DDDevice.type == .iphoneX) ? 34 : 0
let TabBarHeight: CGFloat = DDDevice.isFullScreen ? 34 : 0
//let childVCHeightNoNaviAndTabBar: CGFloat = UIScreen.main.bounds.size.height - ((DDDevice.type == .iphoneX) ? 88 : 64) - ((DDDevice.type == .iphoneX) ? 34 : 0)
let childVCHeightNoNaviAndTabBar: CGFloat = UIScreen.main.bounds.size.height - (DDDevice.isFullScreen ? 88 : 64) - (DDDevice.isFullScreen  ? 34 : 0)
//let bottom: CGFloat = (DDDevice.type == .iphoneX) ? 34 : 0
let bottom: CGFloat = DDDevice.isFullScreen ? 34 : 0
//var  DDNavigationBarHeight : CGFloat =  DDDevice.type == .iphoneX ? 88 : 64
var  DDNavigationBarHeight : CGFloat =  DDDevice.isFullScreen ? 88 : 64

//let DDTabBarHeight: CGFloat = (DDDevice.type == .iphoneX) ?  83 : 49
let DDTabBarHeight: CGFloat = DDDevice.isFullScreen ?  83 : 49
/// iphone X 下的横杠高度
//let DDSliderHeight: CGFloat = (DDDevice.type == .iphoneX) ?  34 : 0
let DDSliderHeight: CGFloat = DDDevice.isFullScreen ?  34 : 0
//let StatusBarHeight : CGFloat = DDDevice.type == .iphoneX ? 44 : 20
let StatusBarHeight : CGFloat = DDDevice.isFullScreen ? 44 : 20
//let DDStateBarHeight: CGFloat = (DDDevice.type == .iphoneX) ? 44 : 20
let DDStateBarHeight: CGFloat = DDDevice.isFullScreen ? 44 : 20
let LCode = DDLanguageManager.text("language_identifier")
let CountryCode = Int(DDLanguageManager.text("country_code")) ?? 110


let placeImageUse = UIImage.init(named: "men_icon")

//颜色
let color1 = UIColor.colorWithHexStringSwift("e1805e")
let color2 = UIColor.colorWithHexStringSwift("000000")
let color3 = UIColor.colorWithHexStringSwift("dddddd")
let color4 = UIColor.colorWithHexStringSwift("f5f5f5")
let color5 = UIColor.colorWithHexStringSwift("777777")
let color6 = UIColor.colorWithHexStringSwift("fab114")
let color7 = UIColor.colorWithHexStringSwift("999999")
let color8 = UIColor.colorWithHexStringSwift("482d10")
let color9 = UIColor.colorWithHexStringSwift("e6d5cf")
let color10 = UIColor.colorWithHexStringSwift("d1714f")
let color11 = UIColor.colorWithHexStringSwift("333333")
let backColor  = UIColor.colorWithHexStringSwift("eaeef4")
///灰色
let ashColor = UIColor.colorWithRGB(red: 237, green: 237, blue: 237)
let lineColor = UIColor.colorWithHexStringSwift("e4e4e4")

//字号
let font13 = GDFont.systemFont(ofSize: 13)
let font17 = GDFont.systemFont(ofSize: 17)





var rootNaviVC : DDRootNavVC?{
    if let window = UIApplication.shared.delegate?.window as? UIWindow {
        if let rootNaviVC =  window.rootViewController as? DDRootNavVC{
            return rootNaviVC
        }
    }
    return nil
}
func imgStrConvertToUrl(_ imgStr:String) -> URL? {
    //#define ImageUrlWithString(url) [NSURL URLWithString:[NSString stringWithFormat:@"http://i0.zjlao.com/%@",(url)]]
    let imgStr = imgStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if imgStr.hasPrefix("http") {
        if let imgUrl = URL(string: imgStr) {
            return imgUrl
        }else{
            return nil
        }
    }else if (imgStr.hasPrefix("/")){
        let tempStr = "http://api.hilao.cc\(imgStr)"
        if let imgUrl = URL(string: tempStr) {
            return imgUrl
        }else{
            return nil
        }
    }else if (imgStr.hasPrefix("//")) {
        let tempStr = "http:\(imgStr)"
        if let imgUrl = URL(string: tempStr) {
            return imgUrl
        }else{
            return nil
        }
    }else {
        let tempStr = "http://w0.16lao.com/\(imgStr)"
        if let imgUrl = URL(string: tempStr) {
            return imgUrl
        }else{
            return nil
        }
    }
    
}



///判断是否是有效的电话号码


////MARK:当前语言包名
//var LanguageTableName : String?  {//当前语言包名(是LocalizableCH , 还是 LoaclizableEN)
////    UserDefaults.standard.set("LocalizableEN", forKey: "LanguageTableName")
//    guard let LanguageTableNameAny = UserDefaults.standard.value(forKey: "LanguageTableName") else{return FollowSystemLanguage}
//    guard let LanguageTableName  = LanguageTableNameAny as? String else {return FollowSystemLanguage}
//    mylog(LanguageTableName)
//    return LanguageTableName
//}
////MARK:通过国际化的方式获取对应key值的字符串
//func gotTitleStr(key : String) -> String? {
//    if LanguageTableName! == FollowSystemLanguage {
//        return NSLocalizedString(key, comment: "")
//    }else{
//        return   NSLocalizedString(key, tableName: LanguageTableName, bundle: Bundle.main, value: "", comment: "")
//    }
//}

////MARK:设置语言的方法
//func setsystemLnaguage(targetLanguageTableName : String) -> Bool {//changeLanguage1
//    if targetLanguageTableName == LanguageTableName {//切换前后语言相同 , 除了提示之外不做任何变化
//        alert("当前语言已经是\(targetLanguageTableName)", time: 2, complateBlock: nil)
//        
//    }else if (targetLanguageTableName == FollowSystemLanguage){//由自定义语言切换为跟随系统语言
//        if targetLanguageTableName ==  gotcurrentSystemLanguage() {//当切换前的自定义语言跟当前系统语言一样时 ,只保存 ,不重新切换 (如何获取系统语言??)
//             UserDefaults.standard.set(FollowSystemLanguage, forKey: "LanguageTableName")
//        }else{//否则即保存又重新切换
//            UserDefaults.standard.set(FollowSystemLanguage, forKey: "LanguageTableName")
//            performChangeTheLanguage(targetLanguageTableName:targetLanguageTableName)
//        }
//    }else{
//         UserDefaults.standard.set(targetLanguageTableName, forKey: "LanguageTableName")
//        performChangeTheLanguage(targetLanguageTableName:targetLanguageTableName)
//    }
//    return true
//}
////MARK:执行更改语言操作
//func performChangeTheLanguage(targetLanguageTableName:String) {//changeLanguage2
//    (UIApplication.shared.delegate as? AppDelegate)?.performChangeLanguage(targetLanguage: targetLanguageTableName)
////    (UIApplication.shared.delegate as? AppDelegate)?.resetKeyVC()
//}
//iOS 获取当前手机系统语言

/**
 *得到本机现在用的语言
 * en-CN 或en  英文  zh-Hans-CN或zh-Hans  简体中文   zh-Hant-CN或zh-Hant  繁体中文    ja-CN或ja  日本  ......
 */
// 获取当前设备支持语言数组
//let languagearr = NSLocale.availableLocaleIdentifiers
/*
 (
["eu", "hr_BA", "en_CM", "en_BI", "rw_RW", "ast", "en_SZ", "he_IL", "ar", "uz_Arab", "en_PN", "as", "en_NF", "ks_IN", "rwk_TZ", "zh_Hant_TW", "en_CN", "gsw_LI", "ta_IN", "th_TH", "es_EA", "fr_GF", "ar_001", "en_RW", "tr_TR", "de_CH", "ee_TG", "en_NG", "fr_TG", "az", "fr_SC", "es_HN", "en_AG", "ru_KZ", "gsw", "dyo", "so_ET", "zh_Hant_MO", "de_BE", "nus_SS", "km_KH", "my_MM", "mgh_MZ", "ee_GH", "es_EC", "kw_GB", "rm_CH", "en_ME", "nyn", "mk_MK", "bs_Cyrl_BA", "ar_MR", "en_BM", "ms_Arab", "en_AI", "gl_ES", "en_PR", "ff_CM", "ne_IN", "or_IN", "khq_ML", "en_MG", "pt_TL", "en_LC", "ta_SG", "iu_CA", "jmc_TZ", "om_ET", "lv_LV", "es_US", "en_PT", "vai_Latn_LR", "yue_HK", "en_NL", "to_TO", "cgg_UG", "ta", "en_MH", "zu_ZA", "shi_Latn_MA", "brx_IN", "ar_KM", "en_AL", "te", "chr_US", "yo_BJ", "fr_VU", "pa", "tg", "kea", "ksh_DE", "sw_CD", "te_IN", "fr_RE", "th", "ur_IN", "yo_NG", "ti", "guz_KE", "tk", "kl_GL", "ksf_CM", "mua_CM", "lag_TZ", "lb", "fr_TN", "es_PA", "pl_PL", "to", "hi_IN", "dje_NE", "es_GQ", "en_BR", "kok_IN", "pl", "fr_GN", "bem", "ha", "ckb", "lg", "tr", "en_PW", "en_NO", "nyn_UG", "sr_Latn_RS", "gsw_FR", "pa_Guru", "he", "sn_ZW", "qu_BO", "lu_CD", "mgo_CM", "ps_AF", "en_BS", "da", "ps", "ln", "pt", "hi", "lo", "ebu", "de", "gu_IN", "seh", "en_CX", "en_ZM", "fr_HT", "fr_GP", "lt", "lu", "ln_CD", "vai_Latn", "el_GR", "lv", "en_KE", "sbp", "hr", "en_CY", "es_GT", "twq_NE", "zh_Hant_HK", "kln_KE", "fr_GQ", "chr", "hu", "es_UY", "fr_CA", "ms_BN", "en_NR", "mer", "shi", "es_PE", "fr_SN", "bez", "sw_TZ", "wae_CH", "kkj", "hy", "teo_KE", "en_CZ", "dz_BT", "teo", "ar_JO", "mer_KE", "khq", "ln_CF", "nn_NO", "en_MO", "ar_TD", "dz", "ses", "en_BW", "en_AS", "ar_IL", "nnh", "bo_CN", "teo_UG", "hy_AM", "ln_CG", "sr_Latn_BA", "en_MP", "ksb_TZ", "ar_SA", "smn_FI", "ar_LY", "en_AT", "so_KE", "fr_CD", "af_NA", "en_NU", "es_PH", "en_KI", "en_JE", "lkt", "en_AU", "fa_IR", "uz_Latn_UZ", "zh_Hans_CN", "ewo_CM", "fr_PF", "ca_IT", "en_BZ", "ar_KW", "pt_GW", "fr_FR", "am_ET", "en_VC", "fr_DJ", "fr_CF", "es_SV", "en_MS", "pt_ST", "ar_SD", "luy_KE", "gd_GB", "de_LI", "fr_CG", "ckb_IQ", "zh_Hans_SG", "en_MT", "ha_NE", "ewo", "af_ZA", "os_GE", "om_KE", "nl_SR", "es_ES", "es_DO", "ar_IQ", "fr_CH", "nnh_CM", "es_419", "en_MU", "en_US_POSIX", "yav_CM", "luo_KE", "dua_CM", "et_EE", "en_IE", "ak_GH", "rwk", "es_CL", "kea_CV", "fr_CI", "ckb_IR", "fr_BE", "se", "en_NZ", "en_MV", "en_LR", "ha_NG", "en_KN", "nb_SJ", "sg", "sr_Cyrl_RS", "ru_RU", "en_ZW", "sv_AX", "si", "ga_IE", "en_VG", "ff_MR", "sk", "ky_KG", "agq_CM", "mzn", "fr_BF", "sl", "en_MW", "mr_IN", "az_Latn", "en_LS", "de_AT", "ka", "naq_NA", "sn", "sr_Latn_ME", "fr_NC", "so", "is_IS", "twq", "ig_NG", "sq", "fo_FO", "sr", "tzm", "ga", "om", "en_LT", "bas_CM", "se_NO", "ki", "nl_BE", "ar_QA", "gd", "sv", "kk", "sw", "es_CO", "az_Latn_AZ", "rn_BI", "or", "kl", "ca", "en_VI", "km", "os", "en_MY", "kn", "en_LU", "fr_SY", "ar_TN", "en_JM", "fr_PM", "ko", "fr_NE", "ce", "fr_MA", "gl", "ru_MD", "saq_KE", "ks", "fr_CM", "lb_LU", "gv_IM", "fr_BI", "en_LV", "en_KR", "es_NI", "en_GB", "kw", "nl_SX", "dav_KE", "tr_CY", "ky", "en_UG", "en_TC", "ar_EG", "fr_BJ", "gu", "es_PR", "fr_RW", "sr_Cyrl_BA", "lrc_IQ", "gv", "fr_MC", "cs", "bez_TZ", "es_CR", "asa_TZ", "ar_EH", "fo_DK", "ms_Arab_BN", "en_JP", "sbp_TZ", "en_IL", "lt_LT", "mfe", "en_GD", "cy", "ug_CN", "ca_FR", "es_BO", "fr_BL", "bn_IN", "uz_Cyrl_UZ", "lrc_IR", "az_Cyrl", "en_IM", "sw_KE", "en_SB", "pa_Arab", "ur_PK", "haw_US", "ar_SO", "en_IN", "fil", "fr_MF", "en_WS", "es_CU", "ja_JP", "fy_NL", "en_SC", "en_IO", "pt_PT", "en_HK", "en_GG", "fr_MG", "de_LU", "tzm_MA", "en_SD", "shi_Tfng", "ln_AO", "as_IN", "en_GH", "ms_MY", "ro_RO", "jgo_CM", "dua", "en_UM", "en_SE", "kn_IN", "en_KY", "vun_TZ", "kln", "lrc", "en_GI", "ca_ES", "rof", "pt_CV", "kok", "pt_BR", "ar_DJ", "yi_001", "fi_FI", "zh", "es_PY", "ar_SS", "mua", "sr_Cyrl_ME", "vai_Vaii_LR", "en_001", "nl_NL", "en_TK", "si_LK", "en_SG", "sv_SE", "fr_DZ", "ca_AD", "pt_AO", "vi", "xog_UG", "xog", "en_IS", "nb", "seh_MZ", "ars", "es_AR", "sk_SK", "en_SH", "ti_ER", "nd", "az_Cyrl_AZ", "zu", "ne", "nd_ZW", "el_CY", "en_IT", "nl_BQ", "da_GL", "ja", "rm", "fr_ML", "rn", "en_VU", "rof_TZ", "ro", "ebu_KE", "ru_KG", "en_SI", "sg_CF", "mfe_MU", "nl", "brx", "bs_Latn", "fa", "zgh_MA", "en_GM", "shi_Latn", "en_FI", "nn", "en_EE", "ru", "yue", "kam_KE", "fur", "vai_Vaii", "ar_ER", "rw", "ti_ET", "ff", "luo", "fa_AF", "nl_CW", "en_HR", "en_FJ", "fi", "pt_MO", "be", "en_US", "en_TO", "en_SK", "bg", "ru_BY", "it_IT", "ml_IN", "gsw_CH", "qu_EC", "fo", "sv_FI", "en_FK", "nus", "ta_LK", "vun", "sr_Latn", "fr", "en_SL", "bm", "ar_BH", "guz", "bn", "bo", "ar_SY", "lo_LA", "ne_NP", "uz_Latn", "be_BY", "es_IC", "sr_Latn_XK", "ar_MA", "pa_Guru_IN", "br", "luy", "kde_TZ", "bs", "fy", "fur_IT", "hu_HU", "ar_AE", "en_HU", "sah_RU", "zh_Hans", "en_FM", "sq_AL", "ko_KP", "en_150", "en_DE", "ce_RU", "en_CA", "hsb_DE", "fr_MQ", "en_TR", "ro_MD", "es_VE", "tg_TJ", "fr_WF", "mt_MT", "kab", "nmg_CM", "ms_SG", "en_GR", "ru_UA", "fr_MR", "zh_Hans_MO", "ff_GN", "bs_Cyrl", "sw_UG", "ko_KR", "en_DG", "bo_IN", "en_CC", "shi_Tfng_MA", "lag", "it_SM", "os_RU", "en_TT", "ms_Arab_MY", "sq_MK", "bem_ZM", "kde", "ar_OM", "kk_KZ", "cgg", "bas", "kam", "wae", "es_MX", "sah", "zh_Hant", "en_GU", "fr_MU", "fr_KM", "ar_LB", "en_BA", "en_TV", "sr_Cyrl", "mzn_IR", "dje", "kab_DZ", "fil_PH", "se_SE", "vai", "hr_HR", "bs_Latn_BA", "nl_AW", "dav", "so_SO", "ar_PS", "en_FR", "uz_Cyrl", "ff_SN", "en_BB", "ki_KE", "en_TW", "naq", "en_SS", "mg_MG", "mas_KE", "en_RO", "en_PG", "mgh", "dyo_SN", "mas", "agq", "bn_BD", "haw", "yi", "nb_NO", "da_DK", "en_DK", "saq", "ug", "cy_GB", "fr_YT", "jmc", "ses_ML", "en_PH", "de_DE", "ar_YE", "bm_ML", "yo", "lkt_US", "uz_Arab_AF", "jgo", "sl_SI", "uk", "en_CH", "asa", "lg_UG", "qu_PE", "mgo", "id_ID", "en_NA", "en_GY", "zgh", "pt_MZ", "fr_LU", "ta_MY", "mas_TZ", "en_DM", "dsb", "mg", "en_BE", "ur", "fr_GA", "ka_GE", "nmg", "en_TZ", "eu_ES", "ar_DZ", "id", "so_DJ", "hsb", "yav", "mk", "pa_Arab_PK", "ml", "en_ER", "ig", "se_FI", "mn", "ksb", "uz", "vi_VN", "ii", "qu", "en_PK", "ee", "ast_ES", "mr", "ms", "en_ES", "ha_GH", "it_CH", "sq_XK", "mt", "en_CK", "br_FR", "tk_TM", "sr_Cyrl_XK", "ksf", "en_SX", "bg_BG", "en_PL", "af", "el", "cs_CZ", "fr_TD", "zh_Hans_HK", "is", "ksh", "my", "mn_MN", "en", "it", "dsb_DE", "ii_CN", "smn", "iu", "eo", "en_ZA", "en_AD", "ak", "en_RU", "kkj_CM", "am", "es", "et", "uk_UA"]
)
 */
//MARK:获取当前系统语言
//func gotcurrentSystemLanguage() -> String{
//        let languages = UserDefaults.standard.object(forKey: "AppleLanguages")
//    guard  let languagesAny = languages else {return   "" }
//    guard let languagesArr = languagesAny as? [AnyObject] else { return "" }
//    let systemLanguage = languagesArr[0]
//    guard let systemLanguageStr  = systemLanguage as? String else { return "" }
//    return systemLanguageStr;
//}
//func performChangeLanguage(targetLanguage : String)  {
//    let noticStr_currentLanguageIs = NSLocalizedString("currentLanguageIs", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 :@"当前语言是"   , 英文的花 : @"currentLanguageIs" (提示语也要国际化)
//    let noticeStr_changeing = NSLocalizedString("languageChangeing", tableName: LanguageTableName, bundle: Bundle.main, value:"", comment: "") // 提示语 中文的话 @"语言更改中"  英文的话 @"languageChangeing" (提示语也要国际化)
//    
//    if let currentLanguage = followSystemLanguage {
//        
//    } if let currentLanguage = LanguageTableName  {//首先取出当前语言包的文件名
//        
//        if currentLanguage == targetLanguage {
//            self.showNotic(autoHide: true, showStr:"\(noticStr_currentLanguageIs)\(targetLanguage)" )
//            //                alert("\(noticStr_currentLanguageIs)\(targetLanguage)", time: 2)
//        }else{
//            UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
//            
//            self.resetKeyVC()
//            //                alert("\(noticeStr_changeing)", time: 3)
//            self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
//        }
//    }else{//如果取出的是nil(第一次取的时候)
//        
//        UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")//把第一次的语言包名存起来
//        
//        self.resetKeyVC()
//        //            alert("\(noticeStr_changeing)", time: 3)
//        self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)")
//    }
//    
//    
//    
//    
//    //        if let currentLanguage = LanguageTableName  {//首先取出当前语言包的文件名
//    //
//    //            if currentLanguage == targetLanguage {
//    //                self.showNotic(autoHide: true, showStr:"\(noticStr_currentLanguageIs)\(targetLanguage)" )
//    //                //                alert("\(noticStr_currentLanguageIs)\(targetLanguage)", time: 2)
//    //            }else{
//    //                UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")
//    //
//    //                self.resetKeyVC()
//    //                //                alert("\(noticeStr_changeing)", time: 3)
//    //                self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)" )
//    //            }
//    //        }else{//如果取出的是nil(第一次取的时候)
//    //
//    //            UserDefaults.standard.set(targetLanguage, forKey: "LanguageTableName")//把第一次的语言包名存起来
//    //
//    //            self.resetKeyVC()
//    //            //            alert("\(noticeStr_changeing)", time: 3)
//    //            self.showNotic(autoHide: false, showStr:"\(noticeStr_changeing)")
//    //        }
//}
















/// 测试图片地址
let DDTestImageUrl = URL(string : "http://ozstzd6mp.bkt.gdipper.com/timg.jpeg")
let DDPlaceholderImage = UIImage(named:"placeholder_image")


//MARK:自定义色值
func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor { return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

//let randomColor = UIColor(red: CGFloat(arc4random_uniform(225)) / 255.0, green: CGFloat(arc4random_uniform(225)) / 255.0, blue: CGFloat(arc4random_uniform(225)) / 255.0, alpha: 1)
//MARK:自定义打印方法
public func mylog <T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
        let  url = URL.init(fileURLWithPath: fileName)
        
        print("✅\(url.lastPathComponent)[\(lineNumber)]:👉\(message)")
    #endif
}

///?? 的增强版,值为空对象(如空字符串,空数组)时也返回默认值
infix operator ??? //中缀操作符,操作符前后连接两个参数 , 用关键词infix声明
func ??? <T:Collection>(num1 : T? , defaultValue : T ) -> T {
    if num1 == nil  {
        return defaultValue
    }else{
        if num1!.count == 0 {
            return defaultValue
        }else {
            return num1!
        }
    }
}
///?? 的增强版,值是否为空对象(包括空值和空字符串,空数组)
postfix operator ->?
postfix func ->? <T:Collection>(num1 : T?  ) -> Bool {
    if num1 == nil  {
        return false
    }else{
        if num1!.count == 0 {
            return false
        }else {
            return true
        }
    }
}
//MARK: 直接从Resource中获取文件

func gotResourceInSubBundle(_ name : String,type : String,directory : String) -> String? {
    guard let subBundlePath = Bundle.main.path(forResource: "Resource", ofType: "bundle") else {return nil}
    guard let subBundle = Bundle(path: subBundlePath) else {return nil  }
    guard let itemPath = subBundle.path(forResource: name, ofType: type, inDirectory: directory) else {return nil}
    return itemPath
  }


func testGitPush() {
    mylog("ceshi")
    mylog("ceshi2")
    mylog("masterCeshi!")
    mylog("ceshi3")
    mylog("firstCeshi1")
}


//MARK:获取当前系统版本
var  systemVersion : Float  {
    get{
        return  (Float(UIDevice.current.systemVersion))!
//        let systemVersion = Float(UIDevice.current.systemVersion)
//        mylog("当前iOS版本为\(systemVersion!)")
//        if systemVersion! <= 11.0 {
//            mylog("10+")
//        }else if (systemVersion! <= 10.0){
//            mylog("9+")
//        }else if (systemVersion! <= 9.0){
//            mylog("8+")
//        }else{
//            mylog("8-")
//        }
    }

}

/*#define gotResourceInSubBundle(name,type,directory)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"]] pathForResource:(name) ofType:(type) inDirectory:(directory)]*/
