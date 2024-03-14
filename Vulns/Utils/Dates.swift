//
//  Dates.swift
//  VulnIntel
//
//  Created by Caleb Kinney on 1/14/24.
//

import Foundation

func dateFormat(date: Date) -> String {
    let format = DateFormatter()
    format.dateStyle = .full
    return format.string(from: date)
}

func dateSince(date: Date) -> String {
    let cal = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: Date.now)
    switch cal {
    case _ where cal.day ?? 0 > 0:
        return "\(cal.day ?? 0)d"
    case _ where cal.hour ?? 0 > 0:
        return "\(cal.hour ?? 0)h"
    default:
        return "\(cal.minute ?? 0)m"
    }
}

func dayOfDate(date: Date) -> Date? {
    let calendar = Calendar.current
    return calendar.startOfDay(for: date)
}
