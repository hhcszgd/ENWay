//
//  DDAccount.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
class DDAccount: Codable{
    init() {
    }
    ///电工身份验证-1未提交，0待审核，1，审核通过，2审核不通过。
    var electrician_examine_status: String?
    var parent_id: String?
    var mobile: String?
    var email: String?
    var sex: String?
    var creatAt: String?
    var saltCode: String?
    var name: String?
    var countryID: String?
    var countryCode: String?
    var id: String? // = 95
    var token: String?// "101faa72fd8cd4f1cdb5ef3ca6e8d49c29cd36e9"
    var head_images:String?
    var nickName: String?
    var password: String?
    var companyName: String?
    var companyPhone: String?
    var school: String?
    ///地址到区县
    var district: String?
    ///地址到街道
    var area_name: String?
    
    ///员工编号
    var number: String?
    ///紧急联系人关系
    var relation: String?
    ///紧急联系人电话
    var relationMobile: String?
    ///紧急联系人姓名
    var relationName: String?
    var education: String?
    var area: String?
    var address: String?
    var detailAddress: String?
    var memberType: String?
    var idNumber: String?
    var idFrontImage: String?
    var idBackImage: String?
    var idHandImage: String?
    /// 审核结果(-1、未提交 0、待审核 1、审核通过 2、审核不通过)
    var examineStatus: String?
    var memberTyep: String?
    var examineDesc: String?
    var canEditBasic: Bool {
        //身份证id存在且是在待审核状态,不能修改
        if let id = self.idNumber, id.count > 0, self.examineStatus == "0" {
            return false
        }
        if ((self.idNumber == nil) || (self.idNumber?.count == 0)) && (self.examineStatus == "0") {
            return true
        }
        if self.examineStatus == "1" {
            return false
        }
        if self.examineStatus == "2" {
            return true
        }
        return true
    }
    
    
    
    var avatar: String?
    
    
    var isLogin : Bool {
        if let token = self.token, token.count > 0{
            return true
        }else {
            return false
        }
        
    }
   
    static let share = DDAccount.read()
    

    
    ///save account from memary to disk .
    
    /// return value  : save success or not
    @discardableResult
    func save() -> Bool {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let isSuccess =  NSKeyedArchiver.archiveRootObject(self , toFile: filePath)
            if isSuccess {
                mylog("archive success")
            }else{
                mylog("archive failure")
            }
            return isSuccess
        }else{
            mylog("the  path of archive is not exist")
            return false
        }
    }
    ///load account from local disk
    class  func read() -> DDAccount {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let object =  NSKeyedUnarchiver.unarchiveObject(withFile:  filePath)
            if let realObjc = object as? DDAccount {
                return realObjc
            }else{
                return  DDAccount()
            }
        }else{
            mylog("the  path of unarchive is not exist")
            return  DDAccount.init()
        }
    }
    ///set share account's propertis by other account dictionary
    
    
    ///set share account's propertis by other account instance
    func setPropertisOfShareBy( otherAccount : DDAccount)  {
        if let token = otherAccount.token, token.count > 0 {
            self.token = token
        }

        if let name = otherAccount.name, name.count > 0 {
            self.name = name
        }
        if let mobile = otherAccount.mobile, mobile.count > 0 {
            self.mobile = mobile
        }
        if let idNumber = otherAccount.idNumber, idNumber.count > 0 {
            self.idNumber = idNumber
        }
        if let address = otherAccount.address, address.count > 0 {
            self.address = address
        }
        if let school = otherAccount.school, school.count > 0 {
            self.school = school
        }
        if let education = otherAccount.education, education.count > 0 {
            self.education = education
        }
        if let relationName = otherAccount.relationName, relationName.count > 0 {
            self.relationName = relationName
        }
        if let relation = otherAccount.relation, relation.count > 0 {
            self.relation = relation
        }
        if let relationMobile = otherAccount.relationMobile, relationMobile.count > 0 {
            self.relationMobile = relationMobile
        }
        if let id = otherAccount.id, id.count > 0 {
            self.id = id
        }
        if let avatar = otherAccount.avatar, avatar.count > 0 {
            let cutWhiteSpace = avatar.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.avatar = cutWhiteSpace
//            self.avatar = avatar
         }
        if let examitionStatus = otherAccount.examineStatus, examitionStatus.count > 0 {
            self.examineStatus = examitionStatus
        }
        if let parent_id = otherAccount.parent_id, parent_id.count > 0 {
            self.parent_id = parent_id
        }
        
        /*
            self.token = otherAccount.token
            self.memberId = otherAccount.memberId
            self.name = otherAccount.name
            self.mobile = otherAccount.mobile
            self.idNumber = otherAccount.idNumber
            self.address = otherAccount.address
            self.school = otherAccount.school
            self.education = otherAccount.education
            self.relationName = otherAccount.relationName
            self.relation = otherAccount.relation
            self.relationMobile = otherAccount.relationMobile
            self.id = otherAccount.id
            self.avatar = otherAccount.avatar
            self.examineStatus = otherAccount.examineStatus
        */
        
        
        
        
        
        self.electrician_examine_status = otherAccount.electrician_examine_status
        self.district = otherAccount.district
        self.area = otherAccount.area
        self.area_name = otherAccount.area_name
        self.memberTyep = otherAccount.memberTyep
        self.save()
    }
    
    ///remove account data from disk
    @discardableResult
    func deleteAccountFromDisk() -> Bool {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("Account.data")
        do {
            try  FileManager.default.removeItem(atPath: path)
            mylog("remove account data from disk success")
            self.token = nil
            self.name = nil
            self.idNumber = nil
            self.examineStatus = nil

            self.mobile = nil
            self.sex = nil
            self.saltCode = nil
            self.countryID = nil
            self.id = nil
            self.nickName = nil
            self.head_images = nil
            self.password = nil
            self.electrician_examine_status = nil
            self.parent_id = nil
            UserDefaults.standard.setValue(nil, forKey: "ShopCount")
            return true
        }catch  let error as NSError {
            mylog("remove account data from disk failure")
            mylog(error)
            return false
        }
        
        
        
        
    }


    //unarchive binary data to instance
    required init?(coder aDecoder: NSCoder) {
        self.token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        self.mobile = (aDecoder.decodeObject(forKey: "mobile") as? String) ?? ""
        self.email = (aDecoder.decodeObject(forKey: "email") as? String) ?? ""
        self.sex = (aDecoder.decodeObject(forKey: "sex") as? String)
        self.saltCode = (aDecoder.decodeObject(forKey: "saltCode") as? String) ?? ""
        self.countryID = aDecoder.decodeObject(forKey: "countryID") as? String
        self.countryCode = aDecoder.decodeObject(forKey: "countryCode") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as? String
        head_images = aDecoder.decodeObject(forKey: "head_images") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.electrician_examine_status = aDecoder.decodeObject(forKey: "electrician_examine_status") as? String
    }
    
    
    //unarchive instance to binary data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mobile, forKey: "mobile")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.sex, forKey: "sex")
        aCoder.encode(self.saltCode, forKey: "saltCode")
        aCoder.encode(self.countryID, forKey: "countryID")
        aCoder.encode(self.countryCode, forKey: "countryCode")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.nickName, forKey: "nickName")
        aCoder.encode(head_images, forKey: "head_images")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.electrician_examine_status, forKey: "electrician_examine_status")
    }
    func refreshAccountInfo(_ completed : (() -> Void)? = nil ) {
//        if DDAccount.share.isLogin{
//            NetWork.manager.requestData(router: Router.get("member/\(DDAccount.share.id ?? "" )", .api, ["token": DDAccount.share.token ?? ""])).subscribe(onNext: { (dict) in
//                let model = BaseModel<DDAccount>.deserialize(from: dict)
//
//                if let data = model?.data {
//                    DDAccount.share.setPropertisOfShareBy(otherAccount: data)
//                }
//                completed?()
//            }, onError: { (error) in
//                completed?()
//            }, onCompleted: {
//                mylog("结束")
//            }) {
//                mylog("回收")
//            }
//        }
    }
    

    
}
