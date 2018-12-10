//
//  Calander_extension.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit
extension Calendar {
    ///当月天数
    var currentMonthForDays: Int {
        get{
            let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date.init())
            let num = range?.count
            return num ?? 31
        }
    }

    
    ///当前时区和格林尼治时区的时间差
    func getSeconds() -> Int {
        let now = Date.init()
        //获取当前时区
        let zone = NSTimeZone.system
        let seconds = zone.secondsFromGMT(for: now)
        return seconds
    }
    ///东八区时间转格林尼治时间
    func getDateWithShangHaiDate(shangHaiDate: Date) -> Date {
        let seconds = self.getSeconds()
        let date = shangHaiDate.addingTimeInterval(TimeInterval.init(-seconds))
        return date
    }
    ///获取东八区的时间现在的时间。
    func getShangHaiDate(date: Date = Date.init()) -> Date {
        let sencods = date.timeIntervalSince1970
        let sencodsInt = Int(sencods)
        let shangHaiSeconds = self.getSeconds() + sencodsInt
        let date = Date.init(timeIntervalSince1970: TimeInterval(shangHaiSeconds))
        return date
    }
    ///获取指定字符串的东八区的时间date
    func getShangHaiDateWithString(time: String) -> Date {
        //首先字符串转换成date
        let date  = self.theTargetStringConversionDate(str: time)
        let target = self.getShangHaiDate(date: date)
        return target
        
    }
    ///指定日期一定天数之后的日期
    func getShanghaiDatedelayday(day: Int = 7) -> Date {
        let date = self.getShangHaiDate()
        let future = date.addingTimeInterval(TimeInterval.init(day * 86400))
        return future
        
    }
    
    
    
    ///获取指定月天数
    func getTargetMonthCountDay(month: Int) -> Int {
        let now = Date.init()
        
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)

        comp.month = month
        let targetDate = self.date(from: comp) ?? now
        let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: targetDate)
        let num = range?.count
        return num ?? 31
    }
    func getTargetMonthDays(year: Int?, month: Int?, day: Int?) -> Int {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: String.init(format: "%ld%02ld%02ld", year ?? 0, month ?? 0, day ?? 0)) ?? Date.init()
        let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)
        let num = range?.count
        return num ?? 31
        
    }
    
    
    
    ///获取指定月份的天数
    func getTargetMonthCountDay(time: String) -> Int {
        let now = self.theTargetStringConversionDate(str: time)
        
//        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
//
        
        
        let range = self.range(of: Calendar.Component.day, in: Calendar.Component.month, for: now)
        let num = range?.count
        return num ?? 31
    }
    ///计算从现在开始到指定时间间隔之后的时间
    func getTargetTimeWith(day: String, num: Int) -> Date{
        let now = Date.init()
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        let currentDay = comp.day ?? 1
        comp.day = currentDay + num
        let targetDate = calendar.date(from: comp)
        return targetDate ?? Date.init()
    }
    ///将date转换成字符串
    func getYearAndMonthAndDayWithDate(date: Date) -> String {
        let comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: date)
        let year: String = String(comp.year ?? 2018)
        let month: String = String(comp.month ?? 10)
        let day: String = String(comp.day ?? 22)
        return year + "-" + month + "-" + day
        
    }
    ///获取指定日期的date
    func getZhiDingTime(month: Int, day: Int, year: Int = 2018) -> Date {
        let now = Date.init()
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        comp.day = day
        comp.year = year
        comp.month = month
        let date = self.date(from: comp)
        return date ?? Date.init()
        
    }
    func getZhiDingTimeWithShangHai(month: Int, day: Int, year: Int = 2018) -> Date {
        let now = Date.init()
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: now)
        comp.day = day
        comp.year = year
        comp.month = month
        let date = self.date(from: comp)
        if let subDate = date {
            return self.getShangHaiDate(date: subDate)
        }else {
           return now
        }
        
        
    }
    ///获取东八区指定指定日期的date
    func getShangHaiCurrentMonthDateWithDay(day: Int) -> Date {
        let now = self.getShangHaiDate()
        var comp = self.dateComponents(Set<Calendar.Component>.init([ Calendar.Component.month, Calendar.Component.day]), from: now)
        comp.day = day
        let date = self.date(from: comp)
        return date ?? now
    }
    ///两个日期的比较1, date1在date2的右边。-1：date1在date2的左边, 0: 两个相等
    func comparDate(date1: Date, date2: Date) -> Int {
        let result = date1.compare(date2)
        if result == .orderedDescending {
            return 1
        }else if (result == .orderedAscending) {
            return -1
        }else {
            return 0
        }
    }
    ///字符串转换成date,指定日期的字符串转换成date
    func theTargetStringConversionDate(str: String) -> Date {
        let str = str + " 12:00:00"
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = formatter.date(from: str) ?? Date.init()
        date.addingTimeInterval(8 * 3600)
        return date
    }
    ///date对象转换成字符串
    func theTargetDateConversionStr(date: Date) -> String {
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateStr = dateFormat.string(from: date)
        return currentDateStr
    }
    ///获取给定字符串的月份
    func getTargetMonthWithStr(time: String) -> Int {
        let date = self.theTargetStringConversionDate(str: time)
        //获取指定日期的月份
        let month = self.getMonth(date: date)
        return month
    }
    ///用字符串获取指定的日
    func getTargetDayWithStr(time: String) -> Int {
        let date = self.theTargetStringConversionDate(str: time)
        //获取指定日期的月份
        let day = self.getDay(date: date)
        return day
    }
    ///用字符串获取指定的年。
    func getTargetYearWithStr(time: String) -> Int {
        let date = self.theTargetStringConversionDate(str: time)
        //获取指定日期的月份
        let year = self.getyear(date: date)
        return year
    }
    
    
    func getMonth(date: Date = Date.init()) -> Int {
        
        let calendar = Calendar.current
        var comp = calendar.dateComponents(Set<Calendar.Component>.init([ Calendar.Component.month]), from: date)
        let month = comp.month ?? 1
        
        return month
    }
    ///获取现在是第几号。
    func getDay(date: Date = Date.init()) -> Int {
        
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.day]), from: date)
        let day = comp.day ?? 1
        return day
    }
    
    ///获取当前年
    func getCurrentYear(date: Date = Date.init()) -> Int {
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year]), from: date)
        let day = comp.year ?? 1
        return day
    }
    ///获取时分秒
    func getHHMMSS(date: Date = Date.init()) -> String {
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: date)
        let hour = comp.hour ?? 0
        let minute = comp.minute ?? 0
        let second = comp.second ?? 0
        return String.init(format: "%02d:%02d:%02d", hour, minute, second)
    }
    ///获取年月日
    func getYYMMDD(date: Date = Date.init()) -> String {
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: date)
        let year = comp.year ?? 0
        let month = comp.month ?? 0
        let day = comp.day ?? 0
        return String.init(format: "%02d年%02d月%02d日", year, month, day)
    }
    
    
    
    
    
    func getWeakDay(date: Date) -> Int {
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.weekday]), from: date)
        let day = comp.weekday ?? 1
        return day
    }
    
    func getDate(year: Int?, month: Int?, day: Int?) -> Date {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: String.init(format: "%d-%02d-%02d" + " 6:00:00", year ?? 0, month ?? 0, day ?? 0)) ?? Date.init()
        
    }
    func getDate(year: Int?, month: Int?, day: Int?, h: Int = 0, m: Int = 0, s: Int = 0) -> Date {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: String.init(format: "%d-%02d-%02d" + " %d:%02d:%02d", year ?? 0, month ?? 0, day ?? 0, h, m, s)) ?? Date.init()
        
    }
    
    
    func getDayWithStr(time: String) {
        let date = self.theTargetStringConversionDate(str: time)
    }
    func getyear(date: Date = Date.init()) -> Int {
       
        var comp = self.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year]), from: date)
        let year = comp.year ?? 2018
        return year
    }

    
    func getDifferenceByDate(oldTime: String, newTime: String) -> Int {
        
        let calander = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let old = calander.theTargetStringConversionDate(str: oldTime)
        let new = calander.theTargetStringConversionDate(str: newTime)
        mylog(old)
        mylog(new)
        let comp = calander.dateComponents(Set<Calendar.Component>.init([Calendar.Component.day]), from: old, to: new)
        
        
        return comp.day ?? 15
        
    }
    
    
    
    func configStart() -> String {
        //获取当前月份。
        let now = self.getShangHaiDate()
        let currentMonth = self.getMonth()
        ///首先看看从现在开始推迟7天后有没有超过16号
        let zhidingDate = self.getZhiDingTimeWithShangHai(month: currentMonth, day: 16)
        ///退职七天之后的日期
        let targetDate = self.getShanghaiDatedelayday(day: 7)
        var selectMonth = currentMonth
        var selectDay = 1
        let result = self.comparDate(date1: zhidingDate, date2: targetDate)
        if (result == -1) || (result == 0) {
            //开始时间移动到下一个月
            let targetMonth = currentMonth + 1
            selectMonth = targetMonth
            let targetDay = self.getDay(date: self.getDateWithShangHaiDate(shangHaiDate: targetDate))
            if targetDay > 1 {
                selectDay = 16
            }else {
                selectDay = 1
            }
            
        }else {
            selectDay = 16
        }
        let month: String = String.init(format: "%02d", selectMonth)
        let day: String = String.init(format: "%02d", selectDay)
        return "2018-\(month)-\(day)"
    }
    
    
    func configEnd(startTime: String) -> [String: String] {
        var startMonth = self.getTargetMonthWithStr(time: startTime)
        var startDay = self.getTargetDayWithStr(time: startTime)
        var endDay: Int = 15
        if startDay == 1 {
            //是从该月的第一天开始的。
            
        }else {
            endDay = self.getTargetMonthCountDay(time: startTime)
            
            
        }
        let month: String = String.init(format: "%02d", startMonth)
        let day: String = String.init(format: "%02d", endDay)
        let endTime: String = "2018-\(month)-\(day)"
        
        let dayCount = self.getDifferenceByDate(oldTime: startTime, newTime: endTime) + 1
        let dayCountStr = String.init(format: "%d", dayCount)
        
        
        return ["endTime": endTime, "dayCount": dayCountStr]
        
    }
    
    
    
   
    
}
