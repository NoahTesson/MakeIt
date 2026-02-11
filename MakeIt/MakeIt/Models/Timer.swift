//
//  Timer.swift
//  MakeIt
//
//  Created by Noah tesson on 14/11/2025.
//

import Foundation

struct TimerMakeIt: Identifiable, Codable {
    let id: Int?
    var nbHours: Int
    var nbMinutes: Int
    var nbSeconds: Int
    var createdAt: Date?
    var updatedAt: Date?
}

extension TimerMakeIt {
    static func empty() -> TimerMakeIt {
        return TimerMakeIt(
            id: 0,
            nbHours: 0,
            nbMinutes: 0,
            nbSeconds: 0,
            createdAt: nil,
            updatedAt: nil
        )
    }
}
