//
//  NoneSystem.swift
//  MakeIt
//
//  Created by Noah tesson on 18/11/2025.
//

import SwiftUI
import Combine

class NoneSystem: ISystem {
    
    override var model: SystemMakeIt { return SystemMakeIt.None }
    override var icon: String { return "lasso" }
    override var color: Color { return Color.green }
    
    override func modelView() -> any View {
        Text(self.model.displayName)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(self.color)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    override func iconView() -> any View {
        Image(systemName: self.icon)
            .font(.system(size: 60))
    }
    override func data(for id: Int, isEditing: Bool) -> any View { EmptyView() }
    override func view() -> any View { EmptyView() }
}
