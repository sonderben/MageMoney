//
//  MyExtensions.swift
//  MageMoney
//
//  Created by Benderson Phanor on 18/7/22.
//

import Foundation
import SwiftUI
import PencilKit

extension Date {
    //https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-dates-months-days-hours-minutes-seconds-in
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
/* extension Double{
     func interest(typeInteres tI:Int, rate i:Double, tiempo t:Int) -> Double{
         if tI==0{
             return 0
         }
         if tI == 1{
             return self*i*Double(t)
         }
         if tI == 2{
             return self*pow((1+i), Double(t))
         }
        return 0
    }
}*/
extension Double {
    
    func percentFormatting() -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
        return formatter.string(for: self) ?? ""
    }
}
extension Double {
    
    func pretty() -> String {
            let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        return formatter.string(for: self) ?? ""
    }
}

extension Date{
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .long
        return formater
    }
    var dateFormater2: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .none
        return formater
    }
    
    var dateFormater3: DateFormatter{
        let formatter=DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var dateFormater4: DateFormatter{
        let formatter=DateFormatter()
        //formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    func prettyShort(includeHour a :Bool=false)->String{
        return dateFormater4.string(from: self)
    }
    func pretty(includeHour a :Bool=false)->String{
        if a {
            return dateFormater.string(from: self)
        }
        return dateFormater2.string(from: self)
    }
    func prettyMedium(includeHour a :Bool=false)->String{
        if a {
            return dateFormater.string(from: self)
        }
        return dateFormater3.string(from: self)
    }
}

extension String {
    
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            //formatter.locale = Locale(identifier: "fr_Fr")
            
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return str.filter({ !$0.isLetter && !$0.isCurrencySymbol })
            }
        }
        return ""
    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





/*struct Loan_Previews: PreviewProvider {
    @State var canvas = PKCanvasView()
    static var previews: some View {
        SignatureView(canvas: $canvas)
    }
}*/
