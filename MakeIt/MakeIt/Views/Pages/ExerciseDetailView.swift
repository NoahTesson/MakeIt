//
//  ExerciseDetailView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct ExerciseDetailView: View {
    @Environment(\.dismiss) var dismiss
    let task: TaskMakeIt
    
    @State private var SystemTask: ISystem = NoneSystem()
    
    @State private var isExerciceStart: Bool = false
    @State private var isExerciceEditing: Bool = false
    
    var body: some View {
        VStack {
            if (isExerciceStart) {
                AnyView(SystemTask.view())
            } else {
                VStack(spacing: 24) {
                    HStack(spacing: 12) {
                        AnyView(SystemTask.iconView())
                        
                        Text(task.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        AnyView(SystemTask.modelView())
                        
                    }
                    
                    ScrollView {
                        // MARK: - Statut exercice
                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(.blue)

                            Text("Récurrence")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(task.recurrence.rawValue)
                                .font(.headline)

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        AnyView(SystemTask.data(for: task.systemId, isEditing: isExerciceEditing))
                    }
                    
                    ButtonStartTask
                }
                .padding()
            }
        }
        .background(
            NavigationGestureDisabler(disabled: isExerciceStart)
        )
        .navigationBarBackButtonHidden(isExerciceStart)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: { deleteTask() }) {
                        Label("Supprimer task", systemImage: "trash")
                    }
                    Button(action: { }) {
                        Label("Modifier la task", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            for system in SystemMakeIt.allCases {
                if (task.system == system) {
                    SystemTask = task.system.linkToClass(task.systemId)
                }
            }
        }
    }
    
    private var ButtonStartTask: some View {
        Button(action: {
            isExerciceStart = true
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Démarrer l'exercice")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    private func deleteTask() {
        Task {
            do {
                let _ = try await Api.deleteTask(id: task.id)
                dismiss()
            } catch {
                print("Error delete task: ", error)
            }
        }
    }
}

// MARK: - Carte d'information
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let isEditing: Bool
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)
                .padding(.bottom, 5)
            
            VStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if isEditing {
                    // Version éditable : un TextField spécifique aux nombres
//                    TextField("", value: $value, format: .number)
//                        .font(.body)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.center)
//                        .keyboardType(.numberPad) // Clavier numérique
//                        .textFieldStyle(.roundedBorder)
//                        .frame(maxWidth: 60)
                } else {
                    // Version lecture seule
                    Text("\(value)")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
            Spacer()
        }
        .padding(10) // Un peu moins de padding pour laisser de la place au TextField
        .background(Color(.systemGray5)) // Un peu plus foncé pour voir la différence
        .cornerRadius(12)
    }
}

struct NavigationGestureDisabler: UIViewControllerRepresentable {
    var disabled: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController
                .navigationController?
                .interactivePopGestureRecognizer?
                .isEnabled = !disabled
        }
    }
}
