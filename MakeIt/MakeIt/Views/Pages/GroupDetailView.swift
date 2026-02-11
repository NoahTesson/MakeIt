//
//  GroupDetailView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct GroupDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var tasks: [TaskMakeIt] = []
    @State private var showingAddExercise = false
    @State private var groupId: Int = -1
    
    let group: GroupMakeIt
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Exercices")) {
                    if tasks.isEmpty {
                        EmptyExerciceStateView()
                    } else {
                        ForEach(tasks, id: \.self) { task in
                            NavigationLink(destination: ExerciseDetailView(
                                task: task,
                            )) {
                                ExerciseRowView(task: task)
                            }
                            //.disabled(isTaskAlreadyDid(task: task))
                        }
                    }
                }
            }
            .listStyle(.inset)
            .scrollBounceBehavior(.basedOnSize)
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddExercise = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(groupId: $groupId)
        }
        .onAppear {
            groupId = group.id
        }
        .onAppear {
            Task {
                do {
                    let result = try await Api.getTasksByGroupId(groupId: group.id)
                    tasks = result
                    
                } catch {
                    print("Error get task by group id: ", error)
                }
            }
        }
    }
    
    func isTaskAlreadyDid(task: TaskMakeIt) -> Bool {
        Task {
            do {
                let result = try await Api.getSmartTimer(id: task.systemId)
                if (result.currentSeries == result.nbSeries) {
                    print(result.currentSeries, result.nbSeries)
                    return true
                }
                return false
            } catch {
                print("Error get timer in class: ", error)
            }
            return false
        }
        
        return false
    }
    
    
}
