//
//  RowView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI


// MARK: - Ligne d'exercice
struct ExerciseRowView: View {
    let task: TaskMakeIt
    
    var body: some View {
        HStack (spacing: 12) {
            Image(systemName: "figure.run")
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(task.name)
                        .font(.headline)
                }
                
                HStack {
                    Image(systemName: "repeat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(task.recurrence.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 1) {
                Image(systemName: "flame")
                    .foregroundColor(.orange)
                
                Text(String(task.inArow))
                    .foregroundColor(.gray)
            }
            
            Text(task.system.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(task.system == SystemMakeIt.SmartTimer ? Color.blue : Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            
        }
    }
}


// MARK: - Ligne de groupe
struct GroupRowView: View {
    let group: GroupMakeIt
    let exerciseCount: Int
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "figure.2")
                .font(.system(size: 20))
                .foregroundStyle(Color(from: group.color) ?? .blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                
                Text("\(exerciseCount) exercice\(exerciseCount > 1 ? "s" : "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}



