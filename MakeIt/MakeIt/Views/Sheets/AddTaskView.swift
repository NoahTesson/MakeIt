//
//  AddTaskView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var groups: [GroupMakeIt] = []
    @Binding var groupId: Int
    
    @State private var name = ""
    @State private var selectedType: SystemMakeIt = .None
    @State private var selectedRecurrence: RecurrenceMakeIt = .Chaquejour
    
    @State private var nbHours: String = ""
    @State private var nbMinutes: String = ""
    @State private var nbSeconds: String = ""
    
    @State private var nbRep: String = ""
    @State private var nbSeries: String = ""
    @State private var timeRecup: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField("Nom de l'exercice", text: $name)
                    
                    Picker("Type", selection: $selectedType) {
                        Text("None").tag(SystemMakeIt.None)
                        Text("Smart Timer").tag(SystemMakeIt.SmartTimer)
                        Text("Timer").tag(SystemMakeIt.Timer)
                    }
                    .pickerStyle(.segmented)
                }
                
                if !groups.isEmpty {
                    Section(header: Text("Groupe")) {
                        Picker("Group", selection: $groupId) {
                            Text("Aucun groupe").tag(-1)
                            ForEach(groups) { group in
                                Text(group.name).tag(group.id)
                            }
                        }
                    }
                }
                
                Section(header: Text("Récurrence")) {
                    Picker("Fréquence", selection: $selectedRecurrence) {
                        ForEach(RecurrenceMakeIt.allCases, id: \.self) { recurrence in
                            Text(recurrence.rawValue).tag(recurrence)
                        }
                    }
                }
                
                DataSelectedSystemView
            }
            .navigationTitle("Nouvel Exercice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Créer") {
                        createTask()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let result = try await Api.getGroups()
                    groups = result
                    
                } catch {
                    print("Error get groups: ", error)
                }
            }
        }
    }
    
    private var DataSelectedSystemView: some View {
        Group {
            switch (selectedType) {
                case .None:
                    EmptyView()
                case .SmartTimer:
                    Section(header: Text("Smart Timer")) {
                        Section() {
                            TextField("Nombre de repetitions", text: $nbRep)
                        }
                        Section() {
                            TextField("Nombre de series", text: $nbSeries)
                        }
                        Section() {
                            TextField("Temps de recuperation (en s)", text: $timeRecup)
                        }
                    }
                case .Timer:
                    Section(header: Text("Timer")) {
                        Section() {
                            TextField("Heures", text: $nbHours)
                        }
                        Section() {
                            TextField("Minutes", text: $nbMinutes)
                        }
                        Section() {
                            TextField("Seconds", text: $nbSeconds)
                        }
                    }
            }
        }
    }
    
    private func createTask() {
        Task {
            do {
                switch (selectedType) {
                    case .None:
                    _ = try await Api.postNone(groupId: groupId, name: name, recurrence: selectedRecurrence)
                    case .Timer:
                    _ = try await Api.postTimer(
                        groupId: groupId,
                        name: name,
                        recurrence: selectedRecurrence,
                        nbHours: Int(nbHours)  ?? 0,
                        nbMinutes: Int(nbMinutes) ?? 0,
                        nbSeconds: Int(nbSeconds) ?? 0
                        )
                    case .SmartTimer:
                    _ = try await Api.postSmartTimer(
                        groupId: groupId,
                        name: name,
                        recurrence: selectedRecurrence,
                        nbRep: Int(nbRep) ?? 0,
                        nbSeries: Int(nbSeries) ?? 0,
                        timeRecup: Int(timeRecup) ?? 0
                    )
                }
                
                dismiss()
            } catch {
                print("Error create task: ", error)
            }
        }
    }
}
