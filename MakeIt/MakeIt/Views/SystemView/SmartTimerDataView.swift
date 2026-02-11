//
//  SmartTimerDataView.swift
//  MakeIt
//
//  Created by Noah tesson on 18/11/2025.
//

import SwiftUI

struct SmartTimerDataView: View {
    let taskId: Int
    let isEditing: Bool
    @State private var rep: Int = 0
    @State private var series: Int = 0
    @State private var currentRep: Int = 0
    @State private var currentSeries: Int = 0
    @State private var timerRecup: Int = 0
    
    private var isCompleted: Bool {
        currentSeries == series && series > 0
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Statut exercice
            HStack {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "clock.fill")
                    .foregroundColor(isCompleted ? .green : .orange)

                Text(isCompleted ? "Exercice terminé" : "Exercice en cours")
                    .font(.headline)
                    .foregroundColor(isCompleted ? .green : .orange)

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            
            // MARK: - Objectif total
            SectionCard(title: "Objectif") {
                HStack {
                    InfoCard(icon: "repeat", title: "Séries", value: "\(series)", isEditing: isEditing)
                    InfoCard(icon: "figure.strengthtraining.traditional", title: "Répétitions", value: "\(rep)", isEditing: isEditing)
                    InfoCard(icon: "timer", title: "Repos (s)", value: "\(timerRecup)", isEditing: isEditing)
                }
            }
            
            // MARK: - Progression actuelle
            SectionCard(title: "Progression actuelle") {
                HStack {
                    InfoCard(
                        icon: "chart.bar.fill",
                        title: "Séries",
                        value: "\(currentSeries) / \(series)",
                        isEditing: false
                    )

                    InfoCard(
                        icon: "bolt.fill",
                        title: "Répétitions",
                        value: "\(currentRep) / \(rep)",
                        isEditing: false
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                do {
                    let result = try await Api.getSmartTimer(id: taskId)
                    rep = result.nbRep
                    series = result.nbSeries
                    timerRecup = result.timeRecup
                    currentRep = result.currentRep
                    currentSeries = result.currentSeries
                } catch {
                    print("Error get time data: ", error)
                }
            }
        }
    }
}


struct SectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            content
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
