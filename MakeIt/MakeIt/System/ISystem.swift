//
//  ISystem.swift
//  MakeIt
//
//  Created by Noah tesson on 17/11/2025.
//

import SwiftUI
import Combine

class ISystem: Hashable {
    
    let id: Int?
    
    init() {
        self.id = nil
    }
    
    init(id: Int) {
        self.id = id
    }
    
    static func == (lhs: ISystem, rhs: ISystem) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var model: SystemMakeIt { return SystemMakeIt.None }
    var icon: String { return "" }
    var color: Color { return Color.clear }
    
    func modelView() -> any View { EmptyView() }
    func iconView() -> any View { EmptyView() }
    func data(for id: Int, isEditing: Bool) -> any View { EmptyView() }
    func view() -> any View { EmptyView() }
}

