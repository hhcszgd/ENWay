//
//  GDLocationManager.swift
//  zjlao
//
//  Created by WY on 16/10/31.
//  Copyright © 2016年 WY. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation



typealias closureType = (String , NSError) -> ()

class DDLocationManager: NSObject ,CLLocationManagerDelegate {
    
    static let GDLocationChanged = NSNotification.Name.init("LocationChanged")
    static let GDAuthorizationStatusChanged =  NSNotification.Name.init("AuthorizationStatusChanged")
    static let share : DDLocationManager = {
        let temp = DDLocationManager.init()
        
        return temp
    }()
    
    var locationServicesEnabled : Bool = {
        return  CLLocationManager.locationServicesEnabled() 
        }()
    func authorizationStatus() -> CLAuthorizationStatus {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case CLAuthorizationStatus.authorizedAlways:
                mylog("现在是前后台定位服务")
            case CLAuthorizationStatus.authorizedWhenInUse:
                mylog("现在是前台定位服务")
            case CLAuthorizationStatus.denied:
                mylog("现在是用户拒绝使用定位服务")
            case CLAuthorizationStatus.notDetermined:
                mylog("用户暂未选择定位服务选项")
            case CLAuthorizationStatus.restricted:
                mylog("现在是用户可能拒绝使用定位服务")
            }
        }else{
            mylog("请开启手机的定位服务")
        }

        return CLLocationManager.authorizationStatus()
    }
    
    lazy var geoCoder  = CLGeocoder.init()
    lazy var locationManager: CLLocationManager = {
        let localtionManagerTemp  =  CLLocationManager.init()
        //        self.localtionManager.requestWhenInUseAuthorization()//请求用户允许前台定位,如果此种授权下想要后台定位 , ios9 以后需要调用一个方法self.localtionManager.allowsBackgroundLocationUpdates = true
        //        NSFoundationVersionNumber
        //        if #available(iOS 9.0, *) {//记得在设置里勾选locationUpDates
        //            self.localtionManager.allowsBackgroundLocationUpdates = true
        //        }
//        localtionManagerTemp.requestAlwaysAuthorization ()//请求用户允许前后台 , info.plist指定NSLocationAlwaysUsageDescription
        
        localtionManagerTemp.requestWhenInUseAuthorization()//请求用户允许前后台 , info.plist指定NSLocationAlwaysUsageDescription
        return localtionManagerTemp
    }()
//    var getLocationCallback : ( (CLLocation? , NSError?) -> ())?//  = {  String , NSError in
    // mylog("")
    //}
    
    override init() {
        super.init()
        locationManager.delegate = self
        
    }
    
    func isInSomeRegion( call : @escaping  (String? , NSError?) -> () ) -> () {//是否在某个区域
        //CLCircularRegion 是 CLRegion的子类
        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33, longitude: 111);
        let  region : CLCircularRegion = CLCircularRegion(center: center, radius: 1000, identifier: "firstRegion")
        self.locationManager.requestState(for: region)
        
    }
    //是否在某个区域的代理方法
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
    
    }
    
    func motitorCurrentRegion( call : @escaping  (String? , NSError?) -> () ) -> () {//监听当前区域
        //CLCircularRegion 是 CLRegion的子类
        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33, longitude: 111);
        let  region : CLCircularRegion = CLCircularRegion(center: center, radius: 1000, identifier: "firstRegion")
        self.locationManager.startMonitoring(for: region)
        
    }
    
    //监听区域代理方法
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {//进入区域
        mylog("进入了这区域:\(region.identifier)")
    
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion){//离开区域
        mylog("离开了这个区域:\(region.identifier)")
    }
    
    
    
    func gotCurrentCouse( call : @escaping  (String? , NSError?) -> () ) -> () {//获取当前朝向
        self.locationManager.startUpdatingHeading()
    }
    //当前朝向的代理方法
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        /**
         magneticHeading:磁北 方向
         trueHeading:现实 方向
         */
    }

    func startUpdatingLocation()  {
        self.locationManager.startUpdatingLocation()//开始定位,
        self.locationManager.distanceFilter = 100 //每隔30米定位一次 , 默认
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation// kCLLocationAccuracyBest
    }
    
    //定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
    
    }
    //不断被调用的定位结果方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        mylog("距离超过临界值,更新位置(包括app重启或重新进入前台)")
//        if self.getLocationCallback != nil {
            if let  location = locations.last {//获取到位置时发送通知
                NotificationCenter.default.post(name: DDLocationManager.GDLocationChanged, object: nil, userInfo: ["userInfo" : location])
            }else{//获取不到时继续更新位置
                self.locationManager.startUpdatingLocation()
//                let error = NSError(domain: "GDLocationManager.com", code: -10001, userInfo: ["reason" : "locationError"])
//                 NotificationCenter.default.post(name: GDLocationManager.GDLocationChanged, object: nil, userInfo: ["userInfo" : error])
//                self.getLocationCallback!(nil,error)
            }
//            self.localtionManager.stopUpdatingLocation()
//        }
    }
    //授权状态改变时调用
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        NotificationCenter.default.post(name: DDLocationManager.GDAuthorizationStatusChanged, object: nil, userInfo:  ["userInfo":status])
        if CLLocationManager.locationServicesEnabled() {
            switch status {
            case CLAuthorizationStatus.authorizedAlways:
                mylog("现在是前后台定位服务")
            case CLAuthorizationStatus.authorizedWhenInUse:
                mylog("现在是前台定位服务")
            case CLAuthorizationStatus.denied:
                mylog("现在是用户拒绝使用定位服务")
            case CLAuthorizationStatus.notDetermined:
                mylog("用户暂未选择定位服务选项")
            case CLAuthorizationStatus.restricted:
                mylog("现在是用户可能拒绝使用定位服务")
            }
        }else{
            mylog("请开启手机的定位服务")
        }
        mylog("授权状态改变了\(status)")
    }
    
    
    ///反地理编码
    ///
    /// - placeStr 地点名称
    /// - complateHandle回调
    func placemarkFromString(placeStr:String , complateHandle:@escaping (CLPlacemark?)->()) {
        let geoCoder = CLGeocoder.init()
        geoCoder.geocodeAddressString(placeStr) { (placeMarks, error ) in
            if let placemark = placeMarks?.first{
                complateHandle(placemark)
                //locality 城市  subLocality 区
            }else{
                complateHandle(nil)
            }
        }
        
    }
    /// 地理编码
    ///
    /// - location 坐标
    /// - complateHandle回调
    func placemarkFromLocation(location: CLLocation,completHandle:@escaping (CLPlacemark?)->())  {
        let geoCoder = CLGeocoder.init()
        if #available(iOS 11.0, *) {
            let local = Locale.init(identifier: DDLanguageManager.languageIdentifier)
            geoCoder.reverseGeocodeLocation(location, preferredLocale: local)  { (placeMarks, error ) in
                //placeMarks只有一个元素
                if(error == nil ){
                    if let placeMark =  placeMarks?.first{completHandle(placeMark)}else{completHandle(nil )}
                }else{completHandle(nil )}
            }
        } else {
            // Fallback on earlier versions
            geoCoder.reverseGeocodeLocation(location) { (placeMarks, error ) in
                //placeMarks只有一个元素
                if(error == nil ){
                    if let placeMark =  placeMarks?.first{completHandle(placeMark)}else{completHandle(nil )}
                }else{completHandle(nil )}
            }
        }
        
        
    }
    
    func startNaviBySystemMap() {
        /**
         let MKLaunchOptionsDirectionsModeKey: String
         let MKLaunchOptionsMapTypeKey: String
         let MKLaunchOptionsMapCenterKey: String
         let MKLaunchOptionsMapSpanKey: String
         let MKLaunchOptionsShowsTrafficKey: String
         let MKLaunchOptionsCameraKey: String
         */
        var mapItems = [MKMapItem]()
        self.geoCoder.geocodeAddressString("北京") { (placeMarkArr, error ) in
            
            
            
            let placemark = MKPlacemark.init(placemark: (placeMarkArr?.first )!)
            let start = MKMapItem.init(placemark: placemark)
            mapItems.append(start)
            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving ,
                                 //MKLaunchOptionsMapTypeKey: "\(MKMapType.hybrid)" ,
                                 //MKLaunchOptionsMapCenterKey:"",
                                 //MKLaunchOptionsMapSpanKey:"",
                                 //MKLaunchOptionsShowsTrafficKey:"\(true)",
                                // MKLaunchOptionsCameraKey:""
                ] as [String : Any]
            
            
            self.geoCoder.geocodeAddressString("上海") { (placeMarkArr, error ) in
                let endplacemark = MKPlacemark.init(placemark: (placeMarkArr?.first)!)
                let end = MKMapItem.init(placemark: endplacemark)
                mapItems.append(end)
                
              let result =  MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions )
                mylog(result)
                }
        }
    }
}














/*    location             : CLLocation 类型, 位置对象信息, 里面包含经纬度, 海拔等等
 region                 : CLRegion 类型, 地标对象对应的区域
 addressDictionary  : NSDictionary 类型, 存放街道,省市等信息
 name                : NSString 类型, 地址全称
 thoroughfare        : NSString 类型, 街道名称
 locality            : NSString 类型, 城市名称//不太准 , 也可能是乡
 administrativeArea : NSString 类型, 省名称 //也可能是直辖市名 //
 country                : NSString 类型, 国家名称
 subLocality ://区
 
 取 addressDictionary 最靠谱
 addressDictionary["Country"] //国家
 addressDictionary["State"] //省/直辖市
 addressDictionary["City"] //城市
 addressDictionary["SubLocality"] //区
 addressDictionary["Name"] //乡镇
 addressDictionary["CountryCode"] //国家码(中国的是CN)
 
 addressDictionary["FormattedAddressLines"] //格式化后的全部地址 (是个数组,  .first取第一个)
 */
/*addressDictionary : Optional([AnyHashable("Country"): 中国, AnyHashable("City"): 郑州市, AnyHashable("Name"): 侯寨乡, AnyHashable("State"): 河南省, AnyHashable("FormattedAddressLines"): <__NSArrayM 0x60000024d140>(
 中国河南省郑州市二七区侯寨乡
 
 addressDictionary : Optional([AnyHashable("Country"): 中国, AnyHashable("City"): 北京市, AnyHashable("Name"): 妙峰山镇, AnyHashable("State"): 北京市, AnyHashable("FormattedAddressLines"): <__NSArrayM 0x600000056320>(
 中国北京市门头沟区妙峰山镇
 )
 , AnyHashable("CountryCode"): CN, AnyHashable("SubLocality"): 门头沟区])
 )*/
