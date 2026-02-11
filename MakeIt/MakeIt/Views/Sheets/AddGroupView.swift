//
//  AddGroupView.swift
//  MakeIt
//
//  Created by Noah tesson on 12/11/2025.
//

import SwiftUI

struct AddGroupView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var selectedColor: Color = .blue

    let availableColors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .yellow, .cyan]
    let columns = Array(repeating: GridItem(.fixed(60)), count: 4)

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informations")) {
                    TextField("Nom du groupe", text: $name)
                }
                
                Section(header: Text("Couleur")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(availableColors, id: \.self) { color in
                            Button(action: { selectedColor = color }) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: selectedColor == color ? 0 : 4)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Nouveau Groupe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Créer") {
                        createGroup()
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func createGroup() {
        Task {
            do {
                let _ = try await Api.createGroup(name: name, color: selectedColor.description)
                dismiss()
            } catch {
                print("Error create task: ", error)
            }
        }
    }
}
