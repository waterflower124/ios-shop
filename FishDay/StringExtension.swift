//
//  StringExtension.swift
//  FishDay
//
//  Created by Medhat Mohamed on 3/29/18.
//  Copyright © 2018 Anas Sherif. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    func toDateTime() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
    func toSupportDate() -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        print(self)
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}
