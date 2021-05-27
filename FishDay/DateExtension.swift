//
//  DateExtension.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/29/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

extension Date {
    
    
    struct Date_ {
        static let formatter = DateFormatter()
    }
    
    func CalederStyle(calender:Calendar.Identifier){
        
        let calender = Calendar.init(identifier: calender)
        Date_.formatter.calendar=calender
        
    }
    
    var dateString: String {
        Date_.formatter.dateFormat = "yyyy-MM-dd"
        Date_.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        
        CalederStyle(calender: Calendar.Identifier.gregorian)
        
        return Date_.formatter.string(from: self)
    }
    
    var dayMonthString: String {
        Date_.formatter.dateFormat = "d MMM"
        Date_.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        
        return Date_.formatter.string(from: self)
    }
    
    var timeString: String {
        Date_.formatter.dateFormat = "HH:mm"
        Date_.formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        
        return Date_.formatter.string(from: self)
    }
    
    
}
