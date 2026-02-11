//
//  ContentView.swift
//  MakeIt
//
//  Created by Noah tesson on 03/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddExercise = false
    @State private var showingAddGroup = false
    @State private var groupId: Int = -1
    
    var body: some View {
        NavigationStack  {
            Dashboard()
                .navigationTitle("My Tasks")
                .navigationViewStyle(StackNavigationViewStyle())
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { showingAddExercise = true }) {
                                Label("Nouvel exercice", systemImage: "plus.circle")
                            }
                            Button(action: { showingAddGroup = true }) {
                                Label("Nouveau groupe", systemImage: "folder.badge.plus")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        }
                        .foregroundColor(.white)
                    }
                }
                .sheet(isPresented: $showingAddExercise) {
                    AddExerciseView(groupId: $groupId)
                }
                .sheet(isPresented: $showingAddGroup) {
                    AddGroupView()
                }
        }
        /*
        TabView {
            TasksView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Tasks")
                }
            
            ResumeView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Résumé")
                }
                .background(Color("MyAdaptiveColor"))
        }
         */
    }
}

#Preview {
    ContentView()
}
