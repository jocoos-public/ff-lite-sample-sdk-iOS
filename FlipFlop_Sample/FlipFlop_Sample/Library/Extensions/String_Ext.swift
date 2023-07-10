//
//  String_Ext.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/05.
//

import Foundation

extension String {
    func convertTime() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        
        if let date = formatter.date(from: self) {
            let convertFormatter = DateFormatter()
            convertFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return convertFormatter.string(from: date)
        }
        
        return ""
    }
    
    func convertDate() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
