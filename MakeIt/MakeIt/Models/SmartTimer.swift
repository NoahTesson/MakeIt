//
//  SmartTimer.swift
//  MakeIt
//
//  Created by Noah tesson on 14/11/2025.
//

import Foundation

struct SmartTimerMakeIt: Identifiable, Codable {
    let id: Int?
    var nbRep: Int
    var nbSeries: Int
    var currentRep: Int
    var currentSeries: Int
    var timeRecup: Int
    var createdAt: Date?
    var updatedAt: Date?
}

extension SmartTimerMakeIt {
    static func empty() -> SmartTimerMakeIt {
        return SmartTimerMakeIt(
            id: 0,
            nbRep: 0,
            nbSeries: 0,
            currentRep: 0,
            currentSeries: 0,
            timeRecup: 0,
            createdAt: nil,
            updatedAt: nil
        )
    }
}
