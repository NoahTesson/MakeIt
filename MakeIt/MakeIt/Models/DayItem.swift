//
//  DayItem.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct DayItem: Identifiable {
    let id = UUID()
    let date: Date
    let dayNumber: Int
    let dayName: String
    let isToday: Bool
}

extension Date {
    func jourDeLaSemaine() -> String {
        let calendar = Calendar.current
        let jourIndex = calendar.component(.weekday, from: self)
        
        switch jourIndex {
        case 1:
            return "Sun"
        case 2:
            return "Tue"
        case 3:
            return "Mon"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Jour inconnu"
        }
    }
}

extension Date {
    func formattedDate(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = format // ex: "8 juillet"
        return formatter.string(from: self)
    }
}
