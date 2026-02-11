//
//  Sytem.swift
//  MakeIt
//
//  Created by Noah tesson on 14/11/2025.
//

import Foundation

enum SystemMakeIt: String, CaseIterable, Identifiable, Codable, Hashable {
    case None, Timer, SmartTimer
    var id: Self { self }
}

extension SystemMakeIt {
    var displayName: String {
        switch self {
        case .None: return "None"
        case .Timer: return "Timer"
        case .SmartTimer: return "SmartTimer"
        }
    }
}


extension SystemMakeIt {
    func linkToClass(_ systemId: Int) -> ISystem {
        switch self {
        case .None: return NoneSystem(id: systemId)
        case .Timer: return TimerSystem(id: systemId)
        case .SmartTimer: return SmartTimerSystem(id: systemId)
        }
    }
}
