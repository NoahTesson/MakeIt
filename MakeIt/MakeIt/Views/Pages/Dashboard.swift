//
//  Dashboard.swift
//  MakeIt
//
//  Created by Noah tesson on 04/11/2025.
//

import SwiftUI

struct Dashboard: View {
    @State private var selectedDate = Date()
    @State private var days: [DayItem] = []
    
    @State private var tasks: [TaskMakeIt] = []
    @State private var groups: [GroupMakeIt] = []
    
    var body: some View {
        VStack(spacing: 0) {
            if (groups.isEmpty && tasks.isEmpty) {
                EmptyStateView()
            } else {
                List {
                    if groups.isEmpty {
                        EmptyGroupStateView()
                    } else {
                        Section("Groupes") {
                            ForEach(groups, id: \.self) { group in
                                NavigationLink(destination: GroupDetailView(group: group)) {
                                    GroupRowView(group: group, exerciseCount: countExercisesInGroup(group.id))
                                 }
                            }
                        }
                    }
                    if tasks.isEmpty {
                        EmptyExerciceStateView()
                    } else {
                        Section("Exercices") {
                            ForEach(tasks, id: \.self) { task in
                                if (task.groupId == nil) {
                                    NavigationLink(destination: ExerciseDetailView(task: task)) {
                                        ExerciseRowView(task: task)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .padding(.top, 5)
        .onAppear {
            Task {
                do {
                    let result = try await Api.getTasks()
                    tasks = result
                } catch {
                    print("Error get tasks: ", error)
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
    
    private func countExercisesInGroup(_ groupId: Int) -> Int {
        return tasks.filter { $0.groupId == groupId }.count
    }
    
    private func generateDays() {
        let calendar = Calendar.current
        let today = Date()
        var generatedDays: [DayItem] = []
        
        for offset in 0...30 {
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                let dayNumber = calendar.component(.day, from: date)
                let dayName = date.formatted(.dateTime.weekday(.abbreviated))
                let isToday = calendar.isDateInToday(date)
                
                generatedDays.append(DayItem(
                    date: date,
                    dayNumber: dayNumber,
                    dayName: dayName,
                    isToday: isToday
                ))
            }
        }
        
        days = generatedDays
    }
}

/*

 private var calendar: some View {
     VStack {
         Divider()
         WeekCalendarView(days: days, selectedDate: $selectedDate)
         Divider()
     }
     .padding(.top, 30)
     .onAppear {
         generateDays()
     }
 }
 
 */
