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
}
