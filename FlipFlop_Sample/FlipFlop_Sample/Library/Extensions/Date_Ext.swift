//
//  Date_Ext.swift
//  FlipFlop_Sample
//
//  Created by DoHyoung Kim on 2023/07/06.
//

import Foundation

extension Date {
    func convertISOTime() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: self)
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
