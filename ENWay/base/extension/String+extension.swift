//
//  String+extension.swift
//  zuidilao
//
//  Created by 张凯强 on 2017/10/11.
//  Copyright © 2017年 张凯强. All rights reserved.
//

import UIKit
import CryptoSwift
extension String {
    
    /** 银行卡号有效性问题Luhn算法
     * 现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
     * 可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
     * 16 位卡号校验位采用 Luhn 校验方法计算：
     * 1，将银行卡逆序排列 ，在此基础上 ,位于奇数位号上的数字乘以 2
     * 2，将各个奇数位乘2的结果(大于9的要减去9)全部相加得出sum1
     * 3 ,将各个偶数位全部相加得出sum2
     * 3，将sum1加上sum2的和能被 10 整除 就验证成功了。
     */
    /*
    func bankCardCheck()-> Bool {
        if self.count >= 10 && self.count <= 30{
            return true
        }
        return false
    }
    */
    
    func bankCardCheck()-> Bool {
        if self.isEmpty {
            return false
        }
        var forwardDescArr = [String]()
            for (_ , char)  in self.enumerated() {
                forwardDescArr.insert(String(char), at: 0)
            }
        var  arrOddNum = [Int]()//偶数位数组
//        var  arrOddNum2 =  [Int]()//奇数位*2的积 > 9
        var  arrEvenNum =  [Int]()//奇数位*2的积 < 9
        for (index ,char) in forwardDescArr.enumerated() {
            let intNum = Int(char) ?? 0
            if index % 2 != 0 {
                if intNum * 2 < 9 {
                    arrEvenNum.append(intNum * 2)
                }else{
                    arrEvenNum.append(intNum * 2 - 9)
                }
            }else {
                 arrOddNum.append(intNum)
            }
        }
        var sumOddNumTotal = 0
        for (_ , intValue ) in arrOddNum.enumerated() {
           sumOddNumTotal += intValue
        }
        var sumEvenNumTotal = 0
        for (_ , intValue ) in arrEvenNum.enumerated() {
            sumEvenNumTotal += intValue
        }
//        let  lastNumber = Int(lastNum) ?? 0
        
        let  luhmTotal =  sumEvenNumTotal + sumOddNumTotal
        
        return (luhmTotal%10 == 0) ? true : false
    }
    
    
    
    
    ///获取类名
    static func getClassName(file: AnyClass) -> String {
        let className = String.init(describing: file)
        return className
    }
    
    
    
    

    ///解码
//    func aesDecrypt(key: String) throws -> [String: String]? {
        //        let key = "4974949650676986"
//        let iv = key
//        //        let str = "uLjChSYtNCkPYkKV9kmkP5GCA/rAbHHCWRWaVxQC36VrX/voRhvV1RhVNGq1lHBR4Wb7uzU97DMT3qe4rSIVNQ=="
//        let data1 = self.data(using: String.Encoding.utf8)!
//        let data = Data(base64Encoded: data1)!
//
//        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).decrypt([UInt8](data))
//        let decryptedData = Data(decrypted)
//        let result = String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
//        let josnData = result.data(using: String.Encoding.utf8)
//        do {
//            let dict = try JSONSerialization.jsonObject(with: josnData!, options: JSONSerialization.ReadingOptions.mutableContainers)
//            if let josnDic = dict as? [String: String] {
//                return josnDic
//            }else {
//                return nil
//            }
//        } catch {
//            return nil
//        }
        
//    }
    ///MARK: Unicode转中文
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = ("\"" + tempStr2) + "\""
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: PropertyListSerialization.MutabilityOptions(), format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    ///MARK:计算多行字符串的size
    func sizeWith(font : UIFont , maxSize : CGSize) -> CGSize {
        var tempMaxSize = CGSize.zero
        if maxSize == CGSize.zero {
            tempMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        }else{
            tempMaxSize = CGSize.init(width: maxSize.width, height: CGFloat(MAXFLOAT))
        }
        let attribute = Dictionary(dictionaryLiteral: (NSAttributedString.Key.font,font) )
        let size = self.boundingRect(with: tempMaxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attribute, context: nil).size
        return  size
    }
    ///MARK:计算多行字符串的size
    func sizeWith(font : UIFont , maxWidth : CGFloat) -> CGSize {
        var tempMaxSize = CGSize.zero
        if maxWidth == 0 {
            tempMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        }else{
            tempMaxSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        }
        let attribute = Dictionary(dictionaryLiteral: (NSAttributedString.Key.font,font) )
        let size = self.boundingRect(with: tempMaxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading], attributes: attribute, context: nil).size
        return  size
    }
    
    func firstCharactorWithString() -> String {
        if #available(iOS 9.0, *) {
            if let str1 = self.applyingTransform(StringTransform.toLatin, reverse: false) as? String {
                if let str2 = str1.applyingTransform(.stripCombiningMarks, reverse: false) as? String {
                    let index = str2.index(str2.startIndex, offsetBy: 1)
                    let str3 = str2.prefix(upTo: index)
                    return String.init(str3)
                    
                }
                
            }
            return ""
        }else {
            
            var str = NSMutableString.init(string: self) as CFMutableString
            CFStringTransform(str, nil, kCFStringTransformToLatin, false)
            CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, false)
            let str2 = CFStringCreateWithSubstring(nil, str, CFRangeMake(0, 1))
            return String(str2!)
        }
    }
    ///insert string in currentString
    /// 
    /// "1234567".insertSplit(string: "oo", perDistance: 3) -> "123oo456oo7"
    func insertSplit(string:String , perDistance:Int) -> String {
        if perDistance <= 0{return self}
        let groupcount = self.count / perDistance
        let left = self.count % perDistance
        let totalCount = groupcount + (left > 0 ? 1 : 0)
        var bankCardNumberString = self
        for index   in 0..<(totalCount - 1) {
            bankCardNumberString.insert(contentsOf:string, at: bankCardNumberString.index(bankCardNumberString.startIndex, offsetBy: (index + 1) * perDistance + index * string.count))
        }
        return bankCardNumberString
    }
    //MARK:计算单行字符串的size
    func sizeSingleLine(font : UIFont ) -> CGSize  {
        return self.size(withAttributes: Dictionary(dictionaryLiteral: (NSAttributedString.Key.font,font) ))
    }
    
    ///上色
    func setColor(color:UIColor ) -> NSAttributedString {
        let attributeString = NSMutableAttributedString.init(string: self)
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor : color ], range: NSRange.init(location: 0, length: self.count))
        return attributeString
    }
    
    
    /// AES Decode
    static func AESDecode(key:String,iv:String,codeStr:String) -> String?{
        if let targetData =  Data.init(base64Encoded: codeStr){
            do {
               
//                let decrypted = try AES(key: key.bytes, blockMode: BlockMode.CBC(iv: iv.bytes), padding: .pkcs7).decrypt(targetData.bytes)
                let decrypted = try AES(key: key, iv: iv, blockMode: BlockMode.CBC, padding: .pkcs7).decrypt(targetData.bytes)
                
                let decryptedData = Data(decrypted)
                return String(bytes: decryptedData.bytes, encoding: .utf8) ?? nil
            } catch  {
                mylog(error )
                return nil
            }
        }
        return nil
    }
    
    
    
    
    /// 关键词高亮
    func setColor(color:UIColor , keyWord:String) -> NSAttributedString{
        let att = NSMutableAttributedString.init(string:self)
        let nsstr = NSString.init(string: self )
        if nsstr.contains(keyWord){
            if let nsRanges =    self.ranges(keyWord: keyWord, nsrange: NSRange.init(location: 0, length: self.count)){
                for range in nsRanges {
                    att.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                }
            }
            return att
        }
        return att
    }
    
    /// 关键词替换
    func replace(keyWord:String , to : String ) -> String{
        let att = NSMutableAttributedString.init(string:self)
        var nsstr = NSString.init(string: self )
        return nsstr.replacingOccurrences(of: keyWord, with: to)
    }
    
    
    func setColor(color:UIColor , keyWords:[String]) -> NSAttributedString{
        let att = NSMutableAttributedString.init(string:self)
        let nsstr = NSString.init(string: self )
        keyWords.forEach { (keyWord) in
            if nsstr.contains(keyWord){
                if let nsRanges =    self.ranges(keyWord: keyWord, nsrange: NSRange.init(location: 0, length: self.count)){
                    for range in nsRanges {
                        att.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                    }
                }
               
            }
        }
        
        return att
    }
    func ranges(keyWord : String  , nsrange : NSRange) -> [NSRange]? {
        var tempArr = [NSRange]()
        var diedaiRange = nsrange
        while self.getNSRange(keyWord: keyWord, nsrange: diedaiRange) != nil  {
            let  result = self.getNSRange(keyWord: keyWord, nsrange: diedaiRange)
            tempArr.append(result!)
            let  location = result!.location + result!.length
            let  length = self.count - (result!.location + result!.length)
            if length <= 0 {break}
            let nextNSRange = NSRange.init(location: location, length: length)
            diedaiRange = nextNSRange
        }
        return tempArr
    }
    
    func getNSRange(keyWord : String  , nsrange : NSRange)  -> NSRange?{
        let nsstring = NSString.init(string: self )
        let subStr = nsstring.substring(with: nsrange)
        if subStr.contains(keyWord){
            let range = nsstring.range(of: keyWord , options: NSString.CompareOptions.literal, range: nsrange)
            return range
        }
        return nil
    }
    ///密码格式是否正确
    func passwordLawful() -> Bool {
        let pass = "^[0-9A-Za-z]{6,12}$"
        let result = NSPredicate.init(format: "SELF MATCHES %@", pass)
        if result.evaluate(with: self) {
            return true
        }else {
            if self.count == 0 {
                return true
            }
            return false
        }
    }
    
    
    ///11位手机号中间替换星号
    func prefixphone() -> String {
        
        let phoneStr = NSString.init(string: self)
        let prefix = phoneStr.substring(to: 3)
        let sub = phoneStr.substring(from: 7)
        let id = prefix + "****" + sub
        return id
    }
    ///判断手机号是否合法
//    func mobileLawful() -> Bool {
//        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//        let cm = "1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//        let cu = "1(3[0-2]|5[256]|8[56])\\d{8}$"
//        let ct = "1((33|53|77|8[09])[0-9]|349)\\d{7}$"
//        let phs = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
//        let new = "1((76|66|55|8[0-9])[0-9]|349)\\d{7}$"
//        let regextextMobile = NSPredicate.init(format: "SELF MATCHES %@", mobile)
//        let regextextcm = NSPredicate.init(format: "SELF MATCHES %@", cm)
//        let regextextcu = NSPredicate.init(format: "SELF MATCHES %@", cu)
//        let regextextct = NSPredicate.init(format: "SELF MATCHES %@", ct)
//        let regextextphs = NSPredicate.init(format: "SELF MATCHES %@", phs)
//        let regexTextNew = NSPredicate.init(format: "SELF MATCHES %@", new)
//        let result: Bool = regextextMobile.evaluate(with: self) || regextextcm.evaluate(with: self) || regextextcu.evaluate(with: self) || regextextct.evaluate(with: self) || regextextphs.evaluate(with: self) || regexTextNew.evaluate(with: self)
//        return  result
//    }
    func mobileLawful() -> Bool {

        let new = "1([3-9][0-9])\\d{8}$"
        let regexTextNew = NSPredicate.init(format: "SELF MATCHES %@", new)
        let result: Bool = regexTextNew.evaluate(with: self)
        return  result
    }
    
    ///判断验证码是否合法
    func authoCodeLawful() -> Bool {
        let authCode = "^[0-9]{6}$"
        let regextextAuthCode = NSPredicate.init(format: "SELF MATCHES %@", authCode)
        let result: Bool = regextextAuthCode.evaluate(with: self)
        return  result
    }
    ///判断用户名是否合法
    func userNameLawful() -> Bool {
        let name  = "^[\\u4e00-\\u9fa5]{2,6}$"
        let regextextName = NSPredicate.init(format: "SELF MATCHES %@", name)
        let result: Bool = regextextName.evaluate(with: self)
        return  result
    }
    
}


extension Data {
    /*
     func viewDidLoad() {
        myEncrypt(encryptData:"my string to encrypt")
    }
    
    
    func myEncrypt(encryptData:String) -> NSData?{
        
        var myKeyData : NSData = ("myEncryptionKey" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var myRawData : NSData = encryptData.dataUsingEncoding(NSUTF8StringEncoding)!
        var iv : [UInt8] = [56, 101, 63, 23, 96, 182, 209, 205]  // I didn't use
        var buffer_size : size_t = myRawData.length + kCCBlockSize3DES
        var buffer = UnsafeMutablePointer<NSData>.alloc(buffer_size)
        var num_bytes_encrypted : size_t = 0
        
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let keyLength        = size_t(kCCKeySize3DES)
        
        var Crypto_status: CCCryptorStatus = CCCrypt(operation, algoritm, options, myKeyData.bytes, keyLength, nil, myRawData.bytes, myRawData.length, buffer, buffer_size, &num_bytes_encrypted)
        
        if UInt32(Crypto_status) == UInt32(kCCSuccess){
            
            var myResult: NSData = NSData(bytes: buffer, length: num_bytes_encrypted)
            
            free(buffer)
            println("my result \(myResult)") //This just prints the data
            
            let keyData: NSData = myResult
            let hexString = keyData.toHexString()
            println("hex result \(hexString)") // I needed a hex string output
            
            
            myDecrypt(myResult) // sent straight to the decryption function to test the data output is the same
            return myResult
        }else{
            free(buffer)
            return nil
        }
    }
    
    
    func myDecrypt(decryptData : NSData) -> NSData?{
        
        var mydata_len : Int = decryptData.length
        var keyData : NSData = ("myEncryptionKey" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        
        var buffer_size : size_t = mydata_len+kCCBlockSizeAES128
        var buffer = UnsafeMutablePointer<NSData>.alloc(buffer_size)
        var num_bytes_encrypted : size_t = 0
        
        var iv : [UInt8] = [56, 101, 63, 23, 96, 182, 209, 205]  // I didn't use
        
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let keyLength        = size_t(kCCKeySize3DES)
        
        var decrypt_status : CCCryptorStatus = CCCrypt(operation, algoritm, options, keyData.bytes, keyLength, nil, decryptData.bytes, mydata_len, buffer, buffer_size, &num_bytes_encrypted)
        
        if UInt32(decrypt_status) == UInt32(kCCSuccess){
            
            var myResult : NSData = NSData(bytes: buffer, length: num_bytes_encrypted)
            free(buffer)
            println("decrypt \(myResult)")
            
            var stringResult = NSString(data: myResult, encoding:NSUTF8StringEncoding)
            println("my decrypt string \(stringResult!)")
            return myResult
        }else{
            free(buffer)
            return nil
            
        }
    }
 */
}
