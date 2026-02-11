//
//  Tasks.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import Foundation

struct TaskMakeIt: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    var groupId: Int?
    var name: String
    var system: SystemMakeIt
    var systemId: Int
    var recurrence: RecurrenceMakeIt
    var createdAt: Date?
    var updatedAt: Date?
    var inArow: Int
}
