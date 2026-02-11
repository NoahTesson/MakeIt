//
//  Group.swift
//  MakeIt
//
//  Created by Noah tesson on 14/11/2025.
//

import SwiftUI
import Foundation

struct GroupMakeIt: Identifiable, Codable, Hashable {
    let id: Int
    var name: String
    var color: String
    var createdAt: Date?
    var udpatedAt: Date?
}

extension Color {
    init?(from string: String) {
        let colorMap: [String: Color] = [
            "red": .red,
            "blue": .blue,
            "green": .green,
            "yellow": .yellow,
            "orange": .orange,
            "purple": .purple,
            "pink": .pink,
            "gray": .gray
        ]
        let key = string.replacingOccurrences(of: ".", with: "")
        if let mapped = colorMap[key] {
            self = mapped
        } else {
            return nil
        }
    }
}
