//
//  TimerSystem.swift
//  MakeIt
//
//  Created by Noah tesson on 17/11/2025.
//

import WidgetKit
import SwiftUI
import Combine

class TimerSystem: ISystem {
    
    @Published var timerData: TimerMakeIt?
    
    override init(id: Int) {
        super.init(id: id)
        loadData(systemId: id)
    }
    
    override init() {
        super.init()
    }
    
    private func loadData(systemId: Int) {
        // Exemple d’appel API (à adapter à ton code)
        Task {
            do {
                let result = try await Api.getTimer(id: systemId)
                await MainActor.run {
                    self.timerData = result
                }
            } catch {
                print("Error get timer in class: ", error)
            }
        }
    }
    
    override var model: SystemMakeIt { return SystemMakeIt.Timer }
    override var icon: String { return "timer" }
    override var color: Color { return Color.blue }
    
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
    override func data(for id: Int, isEditing: Bool) -> any View { TimerDataView(taskId: id, isEditing: isEditing) }
    override func view() -> any View { EmptyView() /*TimerDataView(taskId: id)*/ }
}
