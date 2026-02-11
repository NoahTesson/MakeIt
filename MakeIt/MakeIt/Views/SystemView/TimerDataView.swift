//
//  TimerDataView.swift
//  MakeIt
//
//  Created by Noah tesson on 18/11/2025.
//

import SwiftUI

struct TimerDataView: View {
    let taskId: Int
    let isEditing: Bool
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    
    var body: some View {
        VStack {
            InfoCard(
                icon: "h.square",
                title: "Hours",
                value: String(hours),
                isEditing: isEditing
            )
            
            InfoCard(
                icon: "m.square",
                title: "Minutes",
                value: String(minutes),
                isEditing: isEditing
            )
            
            InfoCard(
                icon: "s.square",
                title: "Seconds",
                value: String(seconds),
                isEditing: isEditing
            )
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                do {
                    let result = try await Api.getTimer(id: taskId)
                    hours = result.nbHours
                    minutes = result.nbMinutes
                    seconds = result.nbSeconds
                } catch {
                    print("Error get time data: ", error)
                }
            }
        }
    }
}
